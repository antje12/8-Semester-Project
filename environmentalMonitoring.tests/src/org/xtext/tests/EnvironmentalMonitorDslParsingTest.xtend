/*
 * generated by Xtext 2.29.0
 */
package org.xtext.tests

import com.google.inject.Inject
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith
import org.xtext.environmentalMonitorDsl.Model
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.eclipse.xtext.xbase.testing.CompilationTestHelper

//import static extension org.xtext.generator.EnvironmentalMonitorDslGenerator.compute
@ExtendWith(InjectionExtension)
@InjectWith(EnvironmentalMonitorDslInjectorProvider)
class EnvironmentalMonitorDslParsingTest {
	@Inject extension ParseHelper<Model>
	@Inject extension ValidationTestHelper
	@Inject extension CompilationTestHelper

	@Test
	def void handleURL() {
		val result = '''
			system Building44
			    baseURL 'mqtt://broker.hivemq.com'
			    sampRate 1000 ms
			    batchSize 20
			    location U180
			        WiFi 'Tonan' 'LetKode123'
			    device CenterDevice in U180
			        deviceType ESP32
			        sensor TempSensor
			            signalType Analog
			            output Temperature
		'''.parse
		Assertions.assertNotNull(result)
		val errors = result.eResource.errors
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')
	}

	@Test
	def void handleIP() {
		val result = '''
			system Building44
			    baseURL 'mqtt://192.168.1.102'
			    sampRate 1000 ms
			    batchSize 20
			    location U180
			        WiFi 'Tonan' 'LetKode123'
			    device CenterDevice in U180
			        deviceType ESP32
			        sensor TempSensor
			            signalType Analog
			            output Temperature
		'''.parse
		Assertions.assertNotNull(result)
		val errors = result.eResource.errors
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')
	}

	@Test
	def void handleMultipleDevices() {
		val result = '''
			system Building44
			    baseURL 'mqtt://broker.hivemq.com'
			    sampRate 1000 ms
			    batchSize 20
			    location U180
			        WiFi 'Tonan' 'LetKode123'
			    device DoorDevice in U180
			        deviceType ESP32
			        sensor TempSensor
			            signalType Analog
			            output Temperature
			    device WindowDevice in U180
			        deviceType ESP32
			        sensor TempSensor
			            signalType Analog
			            output Temperature
		'''.parse
		Assertions.assertNotNull(result)
		val errors = result.eResource.errors
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')
	}

	@Test
	def void handleMultipleSensors() {
		val result = '''
			system Building44
				baseURL 'mqtt://broker.hivemq.com'
				   sampRate 1000 ms
				   batchSize 20
				   location U180
				   	WiFi 'Tonan' 'LetKode123'
				   device DoorDevice in U180
				   	deviceType ESP32
				   	   sensor TempSensor1
				   	   	signalType Analog
				   	   	output Temperature
				   	   sensor TempSensor2
				   	   	signalType Analog
				   	   	output Temperature
		'''.parse
		Assertions.assertNotNull(result)
		val errors = result.eResource.errors
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')
	}

	@Test
	def void noDuplicateDeviceNames() {
		val result = '''
			system Building44
			    baseURL 'mqtt://broker.hivemq.com'
			    sampRate 1000 ms
			    batchSize 20
			    location U180
			        WiFi 'Tonan' 'LetKode123'
			    device CenterDevice in U180
			        deviceType ESP32
			        sensor TempSensor
			            signalType Analog
			            output Temperature
			    device CenterDevice in U180
			        deviceType ESP32
			        sensor TempSensor
			            signalType Analog
			            output Temperature
		'''.parse
		Assertions.assertTrue(result.eResource.validate.size > 0)
	}

	@Test
	def void noDuplicateSensorNames() {
		val result = '''
			system Building44
			    baseURL 'mqtt://broker.hivemq.com'
			    sampRate 1000 ms
			    batchSize 20
			    location U180
			        WiFi 'Tonan' 'LetKode123'
			    device CenterDevice in U180
			        deviceType ESP32
			        sensor TempSensor
			            signalType Analog
			            output Temperature
					sensor TempSensor
					          signalType Analog
					          output Sim
		'''.parse
		Assertions.assertTrue(result.eResource.validate.size > 0)
	}

	@Test
	def void noBadSampleRate1() {
		val result = '''
			system Building44
			    baseURL 'mqtt://broker.hivemq.com'
			    sampRate 999 ms
			    batchSize 20
			    location U180
			        WiFi 'Tonan' 'LetKode123'
			    device CenterDevice in U180
			        deviceType ESP32
			        sensor TempSensor
			            signalType Analog
			            output Temperature
		'''.parse
		Assertions.assertTrue(result.eResource.validate.size > 0)
	}

	@Test
	def void noBadSampleRate2() {
		val result = '''
			system Building44
			    baseURL 'mqtt://broker.hivemq.com'
			    sampRate 10001 ms
			    batchSize 20
			    location U180
			        WiFi 'Tonan' 'LetKode123'
			    device CenterDevice in U180
			        deviceType ESP32
			        sensor TempSensor
			            signalType Analog
			            output Temperature
		'''.parse
		Assertions.assertTrue(result.eResource.validate.size > 0)
	}

	@Test
	def void noBadBatchSize1() {
		val result = '''
			system Building44
			    baseURL 'mqtt://broker.hivemq.com'
			    sampRate 1000 ms
			    batchSize 9
			    location U180
			        WiFi 'Tonan' 'LetKode123'
			    device CenterDevice in U180
			        deviceType ESP32
			        sensor TempSensor
			            signalType Analog
			            output Temperature
		'''.parse
		Assertions.assertTrue(result.eResource.validate.size > 0)
	}

	@Test
	def void noBadBatchSize2() {
		val result = '''
			system Building44
			    baseURL 'mqtt://broker.hivemq.com'
			    sampRate 1000 ms
			    batchSize 101
			    location U180
			        WiFi 'Tonan' 'LetKode123'
			    device CenterDevice in U180
			        deviceType ESP32
			        sensor TempSensor
			            signalType Analog
			            output Temperature
		'''.parse
		Assertions.assertTrue(result.eResource.validate.size > 0)
	}

	@Test
	def void testParsing() {
		val system = '''
			system Building44
			    baseURL 'mqtt://broker.hivemq.com'
			    sampRate 1000 ms
			    batchSize 10
			    location U180
			        WiFi 'Tonan' 'LetKode123'
			    device DoorDevice in U180
			        sampRate 2000 ms
			        batchSize 20
			        deviceType ESP32
			        sensor TempSensor
			            sampRate 3000 ms
			            batchSize 30
			            signalType Analog
			            output Temperature
			    device WindowDevice in U180
			        deviceType ESP32
			        sensor TempSensor
			            signalType Analog
			            output Temperature
		'''.parse

		system.assertNoErrors
		Assertions.assertEquals("Building44", system.name)
		Assertions.assertEquals("mqtt://broker.hivemq.com", system.getUrl.value)
		Assertions.assertEquals(1000, system.rate.value)
		Assertions.assertEquals(10, system.batch.value)

		Assertions.assertEquals(1, system.locations.length)
		val location = system.locations.get(0)
		Assertions.assertEquals("U180", location.name)

		val connection = location.connection
		Assertions.assertEquals("Tonan", connection.ssid.value)
		Assertions.assertEquals("LetKode123", connection.password.value)

		Assertions.assertEquals(2, system.devices.length)
		val device = system.devices.get(0)
		Assertions.assertEquals(location, device.location)
		Assertions.assertEquals("DoorDevice", device.name)
		Assertions.assertEquals(2000, device.rate.value)
		Assertions.assertEquals(20, device.batch.value)

		Assertions.assertEquals("ESP32", device.type)
		Assertions.assertEquals(1, device.sensors.length)
		val sensor = device.sensors.get(0)
		Assertions.assertEquals("TempSensor", sensor.name)
		Assertions.assertEquals(3000, sensor.rate.value)
		Assertions.assertEquals(30, sensor.batch.value)
		Assertions.assertEquals("Analog", sensor.type)
		Assertions.assertEquals("Temperature", sensor.output)
	}

	@Test
	def void testGeneratorNoShadow() {
		'''
			system Building44
				baseURL 'mqtt://broker.hivemq.com'
				sampRate 1000 ms
				batchSize 10
				location U180
					WiFi 'Tonan' 'LetKode123'
				device DoorDevice in U180
					deviceType ESP32
					sensor TempSensor
						signalType Analog
						output Temperature
		'''.assertCompilesTo('''
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
			#define ENDPOINT        "mqtt://broker.hivemq.com"
			#define DEVICE_ID       "DoorDevice"
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
			  char topic[33];
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
			        .batch_size=10, 
			        .topic="Temperature/DoorDevice/TempSensor", 
			        .current=0};
			    params_TempSensor.batches = malloc(params_TempSensor.batch_size * sizeof(int));
			    params_TempSensor.timestamps = malloc(params_TempSensor.batch_size * sizeof(time_t));
			    params_TempSensor.csv_str = malloc(params_TempSensor.batch_size * 2 * sizeof(int));
			    xTaskCreate(CollectTemps, "CollectTemps_TempSensor", 4096, &params_TempSensor, 1, NULL);        
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
		''')
	}

	@Test
	def void testGeneratorShadow1() {
		'''
			system Building44
				baseURL 'mqtt://broker.hivemq.com'
				sampRate 1000 ms
				batchSize 10
				location U180
					WiFi 'Tonan' 'LetKode123'
				device DoorDevice in U180
					sampRate 2000 ms
					batchSize 20
					deviceType ESP32
					sensor TempSensor
						signalType Analog
						output Temperature
		'''.assertCompilesTo('''
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
			#define ENDPOINT        "mqtt://broker.hivemq.com"
			#define DEVICE_ID       "DoorDevice"
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
			  char topic[33];
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
			        .sample_rate=2000, 
			        .batch_size=20, 
			        .topic="Temperature/DoorDevice/TempSensor", 
			        .current=0};
			    params_TempSensor.batches = malloc(params_TempSensor.batch_size * sizeof(int));
			    params_TempSensor.timestamps = malloc(params_TempSensor.batch_size * sizeof(time_t));
			    params_TempSensor.csv_str = malloc(params_TempSensor.batch_size * 2 * sizeof(int));
			    xTaskCreate(CollectTemps, "CollectTemps_TempSensor", 4096, &params_TempSensor, 1, NULL);        
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
		''')
	}

	@Test
	def void testGeneratorShadow2() {
		'''
			system Building44
				baseURL 'mqtt://broker.hivemq.com'
				sampRate 1000 ms
				batchSize 10
				location U180
					WiFi 'Tonan' 'LetKode123'
				device DoorDevice in U180
					sampRate 2000 ms
					batchSize 20
					deviceType ESP32
					sensor TempSensor
						sampRate 3000 ms
						batchSize 30
						signalType Analog
						output Temperature
		'''.assertCompilesTo('''
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
			#define ENDPOINT        "mqtt://broker.hivemq.com"
			#define DEVICE_ID       "DoorDevice"
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
			  char topic[33];
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
			        .sample_rate=3000, 
			        .batch_size=30, 
			        .topic="Temperature/DoorDevice/TempSensor", 
			        .current=0};
			    params_TempSensor.batches = malloc(params_TempSensor.batch_size * sizeof(int));
			    params_TempSensor.timestamps = malloc(params_TempSensor.batch_size * sizeof(time_t));
			    params_TempSensor.csv_str = malloc(params_TempSensor.batch_size * 2 * sizeof(int));
			    xTaskCreate(CollectTemps, "CollectTemps_TempSensor", 4096, &params_TempSensor, 1, NULL);        
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
		''')
	}
}
