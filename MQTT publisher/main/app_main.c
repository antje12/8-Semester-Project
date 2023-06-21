#include "freertos/FreeRTOS.h"
#include "nvs_flash.h"
#include "esp_log.h"
#include "mqtt_client.h"
#include "driver/adc.h"
#include "esp_adc_cal.h"
#include "hl_wifi.h"
#include <time.h>

#define LMT86_GAIN      -10.9   // Average sensor gain of the LMT86 temperature sensor
#define LMT86_OFFSET    2103.0  // Offset voltage of the LMT86 temperature sensor

// Replace these
#define ENDPOINT        "mqtt://192.168.0.152"
#define DEVICE_ID       "CenterDevice"
#define SSID            "Tonan"
#define PASSWORD        "LetKode123"

bool run;
static const char *TAG = "MQTT_PUBLISHER";
static esp_adc_cal_characteristics_t adc_chars;

typedef struct {
  esp_mqtt_client_handle_t client;
  adc1_channel_t pin;
  int sample_rate;
  int batch_size;
  char topic[35];
  int current;
  int* batches;
  time_t* timestamps;
  char* csv_str;
} paramStruct;

int collectTemp(adc1_channel_t channel)
{
    int sam = adc1_get_raw(channel);
    int voltage = esp_adc_cal_raw_to_voltage(sam, &adc_chars);
    return (voltage - LMT86_OFFSET) / LMT86_GAIN;
}

void insert(int value, paramStruct *params)
{
    params->batches[params->current] = value;
    params->timestamps[params->current] = time(NULL);
    params->current++;
}

void toCSV(paramStruct *params)
{
    for (int i = 0; i < params->batch_size; i++) {
        sprintf(params->csv_str + strlen(params->csv_str), "%llu#%d,", params->timestamps[i], params->batches[i]);
    }
    params->csv_str[strlen(params->csv_str) - 1] = '\0';
    printf("The CSV string is: %s\n", params->csv_str);
}

void post(paramStruct *params)
{
    int msg_id = esp_mqtt_client_publish(params->client, params->topic, params->csv_str, 0, 1, 0);
    ESP_LOGI(TAG, "sent publish successful: msg_id=%d, msg=%s", msg_id, params->csv_str);
}

void reset(paramStruct *params)
{
    params->current = 0;
    memset(params->batches, 0, params->batch_size * sizeof(int));
    memset(params->csv_str, 0, params->batch_size * 2 * sizeof(int));
}

void CollectTemps(void *pvParameters){
	
	paramStruct *params = (paramStruct*) pvParameters; 
    esp_adc_cal_characterize(ADC_UNIT_1, ADC_ATTEN_DB_11, ADC_WIDTH_BIT_DEFAULT, 0, &adc_chars);
    ESP_ERROR_CHECK(adc1_config_width(ADC_WIDTH_BIT_DEFAULT));
	ESP_ERROR_CHECK(adc1_config_channel_atten(params->pin, ADC_ATTEN_DB_11)); 
	
	reset(params);
	while (run)
	{
        int temperature = collectTemp(params->pin); 
		printf("%s: %d C \n", params->topic, temperature); 
        insert(temperature, params);
		
		// Send CSV data
		if (params->current >= params->batch_size) 
		{ 
			toCSV(params); 
			post(params); 
			reset(params); 
		}
		
		vTaskDelay(pdMS_TO_TICKS(params->sample_rate));
	}
	
	vTaskDelete(NULL);
}

paramStruct params_TempSensor;
static void start_TempSensor(esp_mqtt_client_handle_t client){
	params_TempSensor = (paramStruct){ 
        .client=client,
        .pin=ADC1_CHANNEL_5,
        .sample_rate=1000, 
        .batch_size=20, 
        .topic="Temperature/CenterDevice/TempSensor", 
        .current=0};
    params_TempSensor.batches = malloc(params_TempSensor.batch_size * sizeof(int));
    params_TempSensor.timestamps = malloc(params_TempSensor.batch_size * sizeof(time_t));
    params_TempSensor.csv_str = malloc(params_TempSensor.batch_size * 2 * sizeof(int));
    xTaskCreate(CollectTemps, "CollectTemps_TempSensor", 4096, &params_TempSensor, 1, NULL);        
}
paramStruct params_SimSensor;
static void start_SimSensor(esp_mqtt_client_handle_t client){
	params_SimSensor = (paramStruct){ 
        .client=client,
        .pin=ADC1_CHANNEL_6,
        .sample_rate=1000, 
        .batch_size=20, 
        .topic="Sim/CenterDevice/SimSensor", 
        .current=0};
    params_SimSensor.batches = malloc(params_SimSensor.batch_size * sizeof(int));
    params_SimSensor.timestamps = malloc(params_SimSensor.batch_size * sizeof(time_t));
    params_SimSensor.csv_str = malloc(params_SimSensor.batch_size * 2 * sizeof(int));
    xTaskCreate(CollectTemps, "CollectTemps_SimSensor", 4096, &params_SimSensor, 1, NULL);        
}

static void mqtt_event_handler(void *handler_args, esp_event_base_t base, int32_t event_id, void *event_data)
{
    esp_mqtt_event_handle_t event = event_data;
    esp_mqtt_client_handle_t client = event->client;

    switch ((esp_mqtt_event_id_t)event_id)
    {
    case MQTT_EVENT_CONNECTED:
        ESP_LOGI(TAG, "MQTT_EVENT_CONNECTED");
        run = true;
            start_TempSensor(client);
            start_SimSensor(client);
            break;
		case MQTT_EVENT_DISCONNECTED:
        	ESP_LOGI(TAG, "MQTT_EVENT_DISCONNECTED");
            run = false;
            break;
        default:
        	// ESP_LOGI(TAG, "Other event id:%d", event->event_id);
            break;
    }
}

void mqtt_app_start(void)
{
    esp_mqtt_client_config_t mqtt_cfg = {
        .broker.address.uri = ENDPOINT,
    };
    esp_mqtt_client_handle_t client = esp_mqtt_client_init(&mqtt_cfg);
    esp_mqtt_client_register_event(client, ESP_EVENT_ANY_ID, mqtt_event_handler, NULL);
    esp_mqtt_client_start(client);
}

void app_main(void)
{
    hl_wifi_init(SSID, PASSWORD, &mqtt_app_start);
}
