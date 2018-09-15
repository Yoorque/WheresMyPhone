# WheresMyPhone

- Communication protocol between Central device and Peripheral device -

Central device (requesting party) will implement protocol that any Service (party sending data / Peripheral device) interested in sending its data to Central device will adopt.

This protocol will contain following properties:

	- NAME of the device advertising it’s data
	- UUID of services and characteristics satisfying requested services and characteristics
	- COORDINATES of the Peripheral device, containing an array of; [Latitude (Double), Longitude (Double), Timestamp, Speed (Double)].

This protocol will contain methods for:

	▪	 Invoking a connection to a qualifying Peripheral device - qualifying devices are those that emit UUIDs that Central device is interested in, which will be specified by developer.
	
//Serves as a connection request to a Peripheral device.
//Swift Example: func connectTo(_ device:). 

	▪	Fetch data from the Peripheral device between two dates set by user and passed as function arguments. The fetched data will contain defined properties in properties declaration of the protocol.
	
// T - represents Data type which will consist of required properties defined in the protocol.
// U - represents Date type in the form of a timestamp.
//Swift Example: func fetchData<T, U>(between startDate: U, and endDate: U) -> T.

All of the data will be sent as encoded data packages that will be decoded and parsed in Central device.
Central device will be the one parsing received data and turning it into information it needs to perform its tasks.

On the Central device side, received data will be converted into suitable data types depending on the platform.

Central device will subscribe to events emitted and stored by Peripheral device, once the new data is available and is within the time interval range, set by Central device in the fetchData(_:between:and:) method. 

Specification:  

	•	NAME - String
	•	UUID - String (…to be specified…)
	•	COORDINATES - Custom type array containing above specified properties
	

