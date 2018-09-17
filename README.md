# WheresMyPhone
## App overview

This app is intended to track changes in position of the other eligible device, with the possibility to choose the date range for changes observation. Date range will be specified by Central device in the fetch request. The initial release of the app will only have basic functionality, where the Central Device will pick-up bluetooth signal from any advertising device within BLE range by using predefined characteristic which complies with UUID of the required service, which is `location` data, with below specified requirements.

### Communication protocol between Central device and Peripheral device 

Central device (requesting party) will implement protocol that any Service (party sending data / Peripheral device (server)) interested in sending its data to Central device will adopt.

This protocol will contain following properties:

	- NAME of the device advertising it’s data
	- UUID of services and characteristics satisfying requested services and characteristics
	- COORDINATES of the Peripheral device, containing an array of: [Latitude (Double), Longitude (Double), Timestamp, Speed (Double), Accuracy (Double)].

Central Device will initiate connection to a qualifying peripheral device that complies with the passed-in characteristic UUID by providing suitable method- qualifying devices are those that emit UUIDs that Central device is interested in, which will be specified by developer.

This protocol will contain method for sending data back to Central Device:

	▪ Fetch data from the Peripheral device between two dates set by user and passed as function arguments. The fetched data will contain defined properties in properties declaration of the protocol.

All of the data will be sent as encoded data packages that will be decoded and parsed in Central device.
Central device will be the one parsing received data and turning it into information it needs to perform its tasks.

Central device will subscribe to events emitted and stored by Peripheral device, once the new data is available and is within the time interval range, set by Central device in the fetch method. 

Specification:

	• name: String
	• uuid: String  - Specified under 0x1819  assigned number from GATT specification (org.bluetooth.service.location_and_navigation). -  Required Service
	• uuid: String - Specified under 0x2A67  assigned number from GATT specification (org.bluetooth.characteristic.location_and_speed). - Required Characteristic
	• coordinates: Custom type array containing above specified properties
	

