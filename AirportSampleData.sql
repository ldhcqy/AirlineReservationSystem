REMARK Sample Data
REMARK Airports table
INSERT INTO Airports VALUES ('ATL', 'Atlanta Internation Airport');
INSERT INTO Airports VALUES ('BOS',	'Boston Logan International Airport');
INSERT INTO Airports VALUES ('ROA',	'Roanoke Regional Airport');
INSERT INTO Airports VALUES ('ORD',	'Chicago Ohare International Airport');
INSERT INTO Airports VALUES ('LAX',	'Los Angeles International Airport');
INSERT INTO Airports VALUES ('LAS',	'Mccarran International Airport');
INSERT INTO Airports VALUES ('BWI',	'Baltimore/Washington International Airport');
INSERT INTO Airports VALUES ('CLT', 'Charlotte/Douglas International Airport');
INSERT INTO Airports VALUES ('PDX','Portland International Airport');
REMARK AircraftTypes table
INSERT INTO AircraftTypes VALUES ('Big Plane', 20);
INSERT INTO AircraftTypes VALUES ('Little Plane', 10);
INSERT INTO AircraftTypes VALUES ('Puddle Jumper', 5);
INSERT INTO AircraftTypes VALUES ('Baby Plane', 2);
INSERT INTO AircraftTypes VALUES ('Big Bertha', 24);
REMARK Aircraft table
INSERT INTO Aircraft VALUES ('A100', 'Big Plane'); 
INSERT INTO Aircraft VALUES ('F200', 'Little Plane');
INSERT INTO Aircraft VALUES ('ZE750', 'Puddle Jumper'); 
INSERT INTO Aircraft VALUES ('US580', 'Puddle Jumper'); 
INSERT INTO Aircraft VALUES ('JVN7', 'Baby Plane'); 
INSERT INTO Aircraft VALUES ('747', 'Big Bertha'); 
REMARK AircraftSeats table
INSERT INTO AircraftSeats VALUES ('Big Plane', '1A', 'Window');
INSERT INTO AircraftSeats VALUES ('Big Plane', '1B', 'Aisle');
INSERT INTO AircraftSeats VALUES ('Big Plane', '1C', 'Window');
INSERT INTO AircraftSeats VALUES ('Big Plane', '1D', 'Aisle');
INSERT INTO AircraftSeats VALUES ('Big Plane', '2A', 'Window');
INSERT INTO AircraftSeats VALUES ('Big Plane', '2B', 'Aisle');
INSERT INTO AircraftSeats VALUES ('Big Plane', '2C', 'Window');
INSERT INTO AircraftSeats VALUES ('Big Plane', '2D', 'Aisle');
INSERT INTO AircraftSeats VALUES ('Big Plane', '3A', 'Window');
INSERT INTO AircraftSeats VALUES ('Big Plane', '3B', 'Aisle');
INSERT INTO AircraftSeats VALUES ('Big Plane', '3C', 'Window');
INSERT INTO AircraftSeats VALUES ('Big Plane', '3D', 'Aisle');
INSERT INTO AircraftSeats VALUES ('Big Plane', '4A', 'Window');
INSERT INTO AircraftSeats VALUES ('Big Plane', '4B', 'Aisle');
INSERT INTO AircraftSeats VALUES ('Big Plane', '4C', 'Window');
INSERT INTO AircraftSeats VALUES ('Big Plane', '4D', 'Aisle');
INSERT INTO AircraftSeats VALUES ('Big Plane', '5A', 'Window');
INSERT INTO AircraftSeats VALUES ('Big Plane', '5B', 'Aisle');
INSERT INTO AircraftSeats VALUES ('Big Plane', '5C', 'Window');
INSERT INTO AircraftSeats VALUES ('Big Plane', '5D', 'Aisle');
INSERT INTO AircraftSeats VALUES ('Little Plane', '1A', 'Window');
INSERT INTO AircraftSeats VALUES ('Little Plane', '1B', 'Window');
INSERT INTO AircraftSeats VALUES ('Little Plane', '2A', 'Window');
INSERT INTO AircraftSeats VALUES ('Little Plane', '2B', 'Window');
INSERT INTO AircraftSeats VALUES ('Little Plane', '3A', 'Window');
INSERT INTO AircraftSeats VALUES ('Little Plane', '3B', 'Window');
INSERT INTO AircraftSeats VALUES ('Little Plane', '4A', 'Window');
INSERT INTO AircraftSeats VALUES ('Little Plane', '4B', 'Window');
INSERT INTO AircraftSeats VALUES ('Little Plane', '5A', 'Window');
INSERT INTO AircraftSeats VALUES ('Little Plane', '5B', 'Window');
INSERT INTO AircraftSeats VALUES ('Puddle Jumper', '1A', 'Window');
INSERT INTO AircraftSeats VALUES ('Puddle Jumper', '1B', 'Window');
INSERT INTO AircraftSeats VALUES ('Puddle Jumper', '2A', 'Window');
INSERT INTO AircraftSeats VALUES ('Puddle Jumper', '2B', 'Middle');
INSERT INTO AircraftSeats VALUES ('Puddle Jumper', '2C', 'Window');
INSERT INTO AircraftSeats VALUES ('Baby Plane', '1A', 'Window');
INSERT INTO AircraftSeats VALUES ('Baby Plane', '1B', 'Middle');
INSERT INTO AircraftSeats VALUES ('Big Bertha', '1A', 'Aisle');
INSERT INTO AircraftSeats VALUES ('Big Bertha', '1B', 'Aisle');
INSERT INTO AircraftSeats VALUES ('Big Bertha', '1C', 'Aisle');
INSERT INTO AircraftSeats VALUES ('Big Bertha', '1D', 'Window');
INSERT INTO AircraftSeats VALUES ('Big Bertha', '1E', 'Middle');
INSERT INTO AircraftSeats VALUES ('Big Bertha', '1F', 'Aisle');
INSERT INTO AircraftSeats VALUES ('Big Bertha', '2A', 'Window');
INSERT INTO AircraftSeats VALUES ('Big Bertha', '2B', 'Middle');
INSERT INTO AircraftSeats VALUES ('Big Bertha', '2C', 'Aisle');
INSERT INTO AircraftSeats VALUES ('Big Bertha', '2D', 'Window');
INSERT INTO AircraftSeats VALUES ('Big Bertha', '2E', 'Middle');
INSERT INTO AircraftSeats VALUES ('Big Bertha', '2F', 'Aisle');
INSERT INTO AircraftSeats VALUES ('Big Bertha', '3A', 'Window');
INSERT INTO AircraftSeats VALUES ('Big Bertha', '3B', 'Middle');
INSERT INTO AircraftSeats VALUES ('Big Bertha', '3C', 'Aisle');
INSERT INTO AircraftSeats VALUES ('Big Bertha', '3D', 'Window');
INSERT INTO AircraftSeats VALUES ('Big Bertha', '3E', 'Middle');
INSERT INTO AircraftSeats VALUES ('Big Bertha', '3F', 'Aisle');
INSERT INTO AircraftSeats VALUES ('Big Bertha', '4A', 'Window');
INSERT INTO AircraftSeats VALUES ('Big Bertha', '4B', 'Middle');
INSERT INTO AircraftSeats VALUES ('Big Bertha', '4C', 'Aisle');
INSERT INTO AircraftSeats VALUES ('Big Bertha', '4D', 'Window');
INSERT INTO AircraftSeats VALUES ('Big Bertha', '4E', 'Middle');
INSERT INTO AircraftSeats VALUES ('Big Bertha', '4F', 'Aisle');
REMARK Flights table
REMARK Past Flights
INSERT INTO Flights
VALUES
(
	'A111',
	to_date('12-31-2099', 
					'MM-DD-YYYY'), 
	to_timestamp_tz('10-01-2011 13:00 America/New_York', 
									'MM-DD-YYYY HH24:MI TZR'),
	to_timestamp_tz('10-01-2011 14:30 America/Los_Angeles', 
									'MM-DD-YYYY HH24:MI TZR'),
	'BWI',
	'LAX',
	'747',
	0
);
INSERT INTO Flights
VALUES
(
	'B222',
	to_date('11-17-2011', 
					'MM-DD-YYYY'), 
	to_timestamp_tz('11-17-2011 06:30 America/New_York', 
									'MM-DD-YYYY HH24:MI TZR'),
	to_timestamp_tz('11-17-2011 07:30 America/New_York', 
									'MM-DD-YYYY HH24:MI TZR'),
	'ROA',
	'CLT',
	'US580',
	0
);
INSERT INTO Flights
VALUES
(
	'C333',
	to_date('11-25-2011', 
					'MM-DD-YYYY'), 
	to_timestamp_tz('11-25-2011 23:00 America/Chicago', 
									'MM-DD-YYYY HH24:MI TZR'),
	to_timestamp_tz('11-26-2011 01:45 America/New_York', 
									'MM-DD-YYYY HH24:MI TZR'),
	'ORD',
	'BOS',
	'A100',
	0
);
REMARK current flights
INSERT INTO Flights
VALUES
(
	'D444',
	to_date('12-02-2011', 
					'MM-DD-YYYY'), 
	to_timestamp_tz('12-02-2011 00:41 America/New_York', 
									'MM-DD-YYYY HH24:MI TZR'),
	to_timestamp_tz('12-02-2011 01:55 America/Los_Angeles', 
									'MM-DD-YYYY HH24:MI TZR'),
	'ATL',
	'PDX',
	'747',
	0
);
INSERT INTO Flights
VALUES
(
	'E555',
	to_date('12-07-2011', 
					'MM-DD-YYYY'), 
	to_timestamp_tz('12-07-2011 13:00 America/New_York', 
									'MM-DD-YYYY HH24:MI TZR'),
	to_timestamp_tz('12-07-2011 14:30 America/New_York', 
									'MM-DD-YYYY HH24:MI TZR'),
	'ROA',
	'ATL',
	'747',
	0
);
INSERT INTO Flights
VALUES
(
	'F666',
	to_date('12-10-2011', 
					'MM-DD-YYYY'), 
	to_timestamp_tz('12-10-2011 15:00 America/Phoenix', 
									'MM-DD-YYYY HH24:MI TZR'),
	to_timestamp_tz('12-10-2011 23:00 America/New_York', 
									'MM-DD-YYYY HH24:MI TZR'),
	'LAS',
	'CLT',
	'JVN7',
	0
);
INSERT INTO Flights
VALUES
(
	'G777',
	to_date('12-12-2011', 
					'MM-DD-YYYY'), 
	to_timestamp_tz('12-12-2011 13:00 America/New_York', 
									'MM-DD-YYYY HH24:MI TZR'),
	to_timestamp_tz('12-12-2011 14:00 America/New_York', 
									'MM-DD-YYYY HH24:MI TZR'),
	'BWI',
	'BOS',
	'747',
	0
);
REMARK Reservations table
INSERT INTO Reservations
VALUES
(
	ResNoSequence.NextVal, 
	'D444',
	to_date('12-02-2011', 
					'MM-DD-YYYY'),
	'1A',
	'Sarah',
	'Heredia',
	to_date('05-07-1984', 'MM-DD-YYYY')
);
INSERT INTO Reservations
VALUES
(
	ResNoSequence.NextVal, 
	'G777',
	to_date('12-12-2011', 
					'MM-DD-YYYY'),
	'1A',
	'Javien',
	'Heredia',
	to_date('12-07-2008', 'MM-DD-YYYY')
);
INSERT INTO Reservations
VALUES
(
	ResNoSequence.NextVal, 
	'F666',
	to_date('12-10-2011', 
					'MM-DD-YYYY'),
	'1A',
	'Sandy',
	'Craft',
	to_date('01-21-1950', 'MM-DD-YYYY')
);
INSERT INTO Reservations
VALUES
(
	ResNoSequence.NextVal, 
	'G777',
	to_date('12-12-2011', 
					'MM-DD-YYYY'),
	'1B',
	'Randall',
	'Craft',
	to_date('12-12-1949', 'MM-DD-YYYY')
);
INSERT INTO Reservations
VALUES
(
	ResNoSequence.NextVal, 
	'F666',
	to_date('12-10-2011', 
					'MM-DD-YYYY'),
	'1B',
	'Greg',
	'Craft',
	to_date('05-27-1982', 'MM-DD-YYYY')
);