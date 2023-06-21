/*
 * generated by Xtext 2.29.0
 */
package org.xtext.validation

import org.eclipse.xtext.validation.Check
import org.xtext.environmentalMonitorDsl.EnvironmentalMonitorDslPackage.Literals
import org.xtext.environmentalMonitorDsl.EnvironmentalMonitorDslPackage
import org.xtext.environmentalMonitorDsl.SampleBatchSize
import org.xtext.environmentalMonitorDsl.SampleRate
import org.xtext.environmentalMonitorDsl.Device
import org.xtext.environmentalMonitorDsl.Sensor
import org.xtext.environmentalMonitorDsl.Model
import org.xtext.environmentalMonitorDsl.URL
import java.util.regex.Pattern

/**
 * This class contains custom validation rules. 
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class EnvironmentalMonitorDslValidator extends AbstractEnvironmentalMonitorDslValidator {

	public static val fromRate = 1000
	public static val toRate = 10000

	public static val fromBatch = 10
	public static val toBatch = 100

	public static val ipPattern = Pattern.compile(
		"^mqtt://((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))$")
	public static val urlPattern = Pattern.compile("^mqtt://[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)*(\\.[a-zA-Z]{2,6})$")

	public static final String DEVICE_UNIQUE = 'device_unique'
	public static final String SENSOR_UNIQUE = 'sensor_unique'

	@Check
	def checkSamplingRange(SampleRate rate) {
		if (rate.value < fromRate || toRate < rate.value) {
			val error = String.format("A sample rate must be between %d and %d", fromRate, toRate)
			error(error, Literals.SAMPLE_RATE__VALUE)
			return
		}
	}

	@Check
	def checkBatchSize(SampleBatchSize batch) {
		if (batch.value < fromBatch || toBatch < batch.value) {
			val error = String.format("A batch size must be between %d and %d", fromBatch, toBatch)
			error(error, Literals.SAMPLE_BATCH_SIZE__VALUE)
			return
		}
	}

	@Check
	def checkURL(URL url) {
		val ipMatcher = ipPattern.matcher(url.value)
		val urlMatcher = urlPattern.matcher(url.value)
		val matchFound = ipMatcher.find() || urlMatcher.find()
		if (!matchFound) {
			val error = String.format("This URL is not valid")
			error(error, Literals.URL__VALUE);
			return;
		}
	}

	@Check
	def void uniqueDeviceName(Device device) {
		if ((device.eContainer as Model).devices.filter[name == device.name].size > 1) {
			val error = String.format("The device name must be unique pr. model")
			error(error, EnvironmentalMonitorDslPackage.eINSTANCE.device_Name, DEVICE_UNIQUE)
		}
	}

	@Check
	def void uniqueSensorName(Sensor sensor) {
		if ((sensor.eContainer as Device).sensors.filter[name == sensor.name].size > 1) {
			val error = String.format("The sensor name must be unique pr. device")
			error(error, EnvironmentalMonitorDslPackage.eINSTANCE.sensor_Name, SENSOR_UNIQUE)
		}
	}
}
