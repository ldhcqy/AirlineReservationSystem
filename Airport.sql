REMARK Drop tables and constraints
DROP TABLE Airports CASCADE CONSTRAINTS;
DROP TABLE AircraftTypes CASCADE CONSTRAINTS;
DROP TABLE Aircraft CASCADE CONSTRAINTS;
DROP TABLE AircraftSeats CASCADE CONSTRAINTS;
DROP TABLE Flights CASCADE CONSTRAINTS;
DROP TABLE Reservations CASCADE CONSTRAINTS;
DROP SEQUENCE ResNoSequence;
REMARK create tables
CREATE TABLE Airports
(
	AirportCode VARCHAR2(3),
	Description VARCHAR2(50),
	CONSTRAINT Airports_PK
		PRIMARY KEY (AirportCode)
);
CREATE TABLE AircraftTypes
(
	AircraftType VARCHAR2(25),
	Capacity NUMBER(3),
	CONSTRAINT AircraftTypes_PK
		PRIMARY KEY (AircraftType)
);
CREATE TABLE Aircraft
(
	aID VARCHAR2(10),
	AircraftType VARCHAR2(25),
	CONSTRAINT Aircraft_PK
		PRIMARY KEY (aID),
  CONSTRAINT Aircraft_AircraftTypes_FK
    FOREIGN KEY (AircraftType)
    REFERENCES AircraftTypes (AircraftType)
);
CREATE TABLE AircraftSeats
(
	AircraftType VARCHAR2(25),
	Seat VARCHAR2(3),
	SeatType VARCHAR2(6),
	CONSTRAINT AircraftSeats_PK
		PRIMARY KEY (AircraftType, Seat),
	CONSTRAINT AircraftSeats_AircraftTypes_FK
		FOREIGN KEY (AircraftType)
		REFERENCES AircraftTypes (AircraftType)
);
CREATE TABLE Flights
(
	FlightNo VARCHAR2(4),
	DepartDate DATE,
	DepartDateTime TIMESTAMP WITH TIME ZONE,
	ArriveDateTime TIMESTAMP WITH TIME ZONE,
	Origin VARCHAR2(3),
	Destination VARCHAR2(3),
	AircraftID VARCHAR2(10),
	SeatsBooked Number(3),
	CONSTRAINT Flights_PK
		PRIMARY KEY (FlightNo, DepartDate),
	CONSTRAINT Flights_Airports_Origin_FK
		FOREIGN KEY (Origin)
		REFERENCES Airports (AirportCode),
	CONSTRAINT Flights_Airports_Dest_FK
		FOREIGN KEY (Destination)
		REFERENCES Airports (AirportCode),
	CONSTRAINT Flights_Aircraft_FK
		FOREIGN KEY (AircraftID)
		REFERENCES Aircraft (aID),
  CONSTRAINT Flights_Orig_Dest_CK
    CHECK (Origin <> Destination)
);
CREATE TABLE Reservations
(
	ResNo NUMBER,
	FlightNo VARCHAR2(4),
	DepartDate DATE,
	Seat VARCHAR2(3),
	PassengerLname VARCHAR2(15),
	PassengerFname VARCHAR2(15),
	PassengerBirthDate DATE,
	CONSTRAINT Reservations_PK
		PRIMARY KEY (ResNo),
	CONSTRAINT Reservations_Flights_FK
		FOREIGN KEY (FlightNo, DepartDate)
		REFERENCES Flights (FlightNo, DepartDate),
	CONSTRAINT Reservations_Seat_UK
		UNIQUE (FlightNo, DepartDate, Seat)
);
REMARK sequence for creating resgistration numbers
CREATE SEQUENCE ResNoSequence
	MINVALUE 0
	START WITH 0
	INCREMENT BY 1
	CACHE 10;
REMARK triggers
CREATE OR REPLACE TRIGGER capacity_check
	-- This trigger ensures the number of seats assigned
	-- to an aircraft does not exceed its capacity.
	BEFORE INSERT
	ON AircraftSeats
	FOR EACH ROW
DECLARE
	totalCapacity AircraftTypes.Capacity%TYPE;
	currentCapacity AircraftTypes.Capacity%TYPE;
	MaxSeats EXCEPTION;
	ExMessage VARCHAR2(200);
BEGIN 
	SELECT Capacity
		INTO totalCapacity
		FROM AircraftTypes
		WHERE AircraftType = :NEW.AircraftType
		FOR UPDATE WAIT 10;

	SELECT COUNT(*) as CurrCap
		INTO currentCapacity
		FROM AircraftSeats
		WHERE AircraftType = :NEW.AircraftType
    GROUP BY AircraftType;
		
	IF currentCapacity >= totalCapacity THEN
		RAISE MaxSeats;
	END IF;
EXCEPTION
	WHEN No_Data_Found THEN
		currentCapacity := 0;
	WHEN MaxSeats THEN
	-- error number between -20000 and -20999
	ExMessage := 'No seats remaining for aircraft type: ' ||
									:NEW.AircraftType || '.' || chr(10); 
	ExMessage := ExMessage || 'Aircraft Capacity: ' ||
									to_char(totalCapacity) || '.' || chr(10); 
	ExMessage := ExMessage || 'Current Capacity: ' ||
									to_char(currentCapacity) || '.';
	Raise_Application_Error(-20001, ExMessage); 
END;
/
CREATE OR REPLACE TRIGGER check_depart_date
	-- This trigger ensures that the departdate part of
	-- the composite primary key is the same as the date
	-- part of the departdatetime timestamp
	BEFORE INSERT OR UPDATE 
	ON Flights
	FOR EACH ROW
DECLARE
	UnmatchedDepart EXCEPTION;
	ExMessage 			VARCHAR2(200);
	tDate 					DATE;
BEGIN
	SELECT TRUNC(:NEW.DepartDateTime)
    INTO tDate
		FROM dual;
	IF tDate != :NEW.DepartDate THEN
		RAISE UnmatchedDepart;
	END IF;
EXCEPTION
	WHEN UnmatchedDepart THEN
	-- error number between -20000 and -20999
	ExMessage := 'DepartDate and DepartDateTime must match.' || chr(10);
	ExMessage := ExMessage || 'DepartDate: ' ||
								to_char(:NEW.DepartDate) || '.' || chr(10);
	ExMessage := ExMessage || 'DepartDateTime: ' ||
								to_char(tDate) || '.';
	Raise_Application_Error(-20001, ExMessage);
END;
/
REMARK trigger to automate seatsbook numbers in flights table
CREATE OR REPLACE TRIGGER adjust_seatsbooked
	-- trigger increments or decrements seats booked
	-- as reservations are made, changed or deleted for flight
	BEFORE INSERT OR UPDATE OR DELETE
	ON Reservations
	FOR EACH ROW
DECLARE
	current_capacity Flights.SeatsBooked%TYPE;
BEGIN
	-- get current capacity
	SELECT SeatsBooked
	INTO current_capacity
		FROM Flights
		WHERE FlightNo = :NEW.FlightNo;
	
	IF INSERTING THEN
		UPDATE Flights
			SET SeatsBooked = current_capacity + 1
			WHERE FlightNo = :NEW.FlightNo;
	ELSIF UPDATING THEN
		UPDATE Flights
			SET SeatsBooked = current_capacity + 1
			WHERE FlightNo = :NEW.FlightNo;
		UPDATE Flights
			SET SeatsBooked = current_capacity - 1
			WHERE FlightNo = :OLD.FlightNo;
	ELSIF DELETING THEN
		UPDATE Flights
			SET SeatsBooked = current_capacity - 1
			WHERE FlightNo = :OLD.FlightNo;
	END IF;
END;
/
CREATE OR REPLACE PROCEDURE make_reservation
(	aFlightNo IN Reservations.FlightNo%TYPE,
	--departDT 	IN Flights.DepartDateTime%TYPE,
	departDate IN VARCHAR2,
	fName 		IN Reservations.PassengerFname%TYPE,
	lName			IN Reservations.PassengerLname%TYPE,
	--pDOB			IN Reservations.PassengerBirthDate%TYPE,
	pDOB IN VARCHAR2,
	aResult		OUT VARCHAR2,
	resNo 		OUT Reservations.ResNo%TYPE) IS
	-- Creates a new reservation from given data
	-- Provides transaction control
	-- Returns message stating result of transaction
	-- 	POSSIBLE RESULTS
	-- 	*No Such Flight
	--  *Flight In Past
	--	*Flight Full
	-- 	*Unknown Error
	--	*Success
	-- If transaction is successful, a new reservation
	--  number will be generated and returned otherwise 
	--  0 will be returned
	
	craftType AircraftTypes.AircraftType%TYPE;
	aFNum Flights.FlightNo%TYPE;
	entered_flightDT Flights.DepartDateTime%TYPE;
	entered_dob Reservations.PassengerBirthDate%TYPE;
	existing_flightDT Flights.DepartDateTime%TYPE;
	current_capacity Flights.SeatsBooked%TYPE;
	aircraft_capacity AircraftTypes.Capacity%TYPE;
	Past_Flight EXCEPTION;
	Full_Flight EXCEPTION;
	fDate Date;
BEGIN
	-- will fire no data found if bad flight number
	SELECT FlightNo 
		INTO aFNum
		FROM Flights
		WHERE FlightNo = aFlightNo AND 
					DepartDateTime = DepartDate;

	-- get depart date and time
	SELECT DepartDateTime
		INTO existing_flightDT
		FROM Flights
		WHERE FlightNo = aFlightNo;
		
	-- get aircrafttype
	SELECT T2.AircraftType
		INTO craftType
	FROM
	(SELECT FlightNo, AircraftID
		FROM Flights
		WHERE FlightNo = aFlightNo) T1
	INNER JOIN
	(SELECT *
		FROM Aircraft) T2
	ON T1.AircraftID = T2.aID;

	-- get aircraft capacity
	SELECT Capacity
		INTO aircraft_capacity
		FROM AircraftTypes
		WHERE AircraftType = craftType
		FOR UPDATE WAIT 10;
		
	-- get current capacity
	SELECT COUNT(*) as CurrCap
		INTO current_capacity
		FROM AircraftSeats
		WHERE AircraftType = craftType
    GROUP BY AircraftType;
	
	-- check for flight in the past
	IF existing_flightDT < to_timestamp_tz(sysdate) THEN
		RAISE Past_Flight;
	-- check for full flight
	ELSIF current_capacity >= aircraft_capacity THEN
		RAISE Full_Flight;
	ELSE
		INSERT INTO Reservations
		VALUES
		(
			ResNoSequence.NextVal,			 -- Reservation Number
			aFlightNo,						 			 -- Flight Number
			to_date(departDate, 'MM-DD-YYYY'),										 -- Departure Date
			NULL,												 -- Seat Number (to be assigned later)
			lName,											 -- Passenger Last Name
			fName,											 -- Passenger First Name
			to_date(pDOB, 'MM-DD-YYYY')	 -- Passenger Date of Birth
		); -- end of insert statement
		COMMIT;
		aResult := 'Success';
	END IF;

EXCEPTION
	-- No_Data_Found is raised if the SELECT statement returns no data.
	-- if flight does not exist
	WHEN No_Data_Found THEN
		aResult := 'No Such Flight';
	-- if flight from past
	WHEN Past_Flight THEN
		aResult := 'Flight In Past';
	-- if flight is full
	WHEN Full_Flight THEN
		aResult := 'Flight Full';
	-- otherwise...
	WHEN OTHERS THEN
		aResult := 'Unknown Error';
END; 
/	
show error;
CREATE OR REPLACE PROCEDURE assign_seat
( aResNo	IN Reservations.ResNo%TYPE,
	seatNum	IN Reservations.Seat%TYPE,
	aResult OUT VARCHAR2) IS
	-- After a reservation is successfully created, 
	--  this method is called to allow client to chose
	--  a seat on the aircraft
	-- Returns a message stating result of transaction
	-- POSSIBLE RESULTS
	--	*Invalid Reservation Number
	--	*Flight in Past
	-- 	*Seat Already Taken
	--	*No Such Seat
	-- 	*Unknown Error
	--	*Success
	aType 						AircraftTypes.AircraftType%TYPE;
	aFlightNo 				Reservations.FlightNo%TYPE;
	departDT					Flights.DepartDateTime%TYPE;
	tempSeat 					Reservations.Seat%TYPE;
	tempResNo					Reservations.ResNo%TYPE;
	existing_flightDT Flights.DepartDateTime%TYPE;
	isValidSeat 			BOOLEAN := FALSE;
	isAvailable 			BOOLEAN := TRUE; 	
	Past_Flight				EXCEPTION;
	Invalid_Seat			EXCEPTION;
	Seat_Taken				EXCEPTION;
	-- Cursor to find all valid seats for aircraft type
	CURSOR SeatRec (seatRequested Reservations.Seat%TYPE) IS
		SELECT Seat
			FROM AircraftSeats
			WHERE AircraftType = aType;
	-- Cursor to find all currently book seats on flight
	CURSOR SeatBooked (seatRequested Reservations.Seat%TYPE) IS
		SELECT Seat
			FROM Reservations
			WHERE FlightNo = aFlightNo
			FOR UPDATE WAIT 10;
			
BEGIN
	-- if all tests pass, transaction is successful
	aResult := 'Success';
	
	-- Check if registration number is valid
	-- No_Data_Found exception will be raised if invalid
	SELECT ResNo
		INTO tempResNo
		FROM Reservations
		WHERE ResNo = aResNo;
		
	-- get flight number
	SELECT FlightNo
		INTO aFlightNo
		FROM Reservations
		WHERE ResNo = aResNo;
	
	-- Get aircraft type
	SELECT T2.AircraftType
		INTO aType
	FROM
	(SELECT FlightNo, AircraftID
		FROM Flights
		WHERE FlightNo = aFlightNo) T1
	INNER JOIN
	(SELECT *
		FROM Aircraft) T2
		ON T1.AircraftID = T2.aID;
		
	-- get existing flight date and time
	SELECT T2.DepartDateTime
		INTO existing_flightDT
	FROM
	(SELECT FlightNo
		FROM Reservations
		WHERE ResNo = aResNo) T1
	INNER JOIN
	(SELECT FlightNo, DepartDateTime
		FROM Flights) T2
	ON T1.FlightNo = T2.FlightNo;
	
	-- check for flight in the past
	IF existing_flightDT < to_timestamp_tz(sysdate) THEN
		RAISE Past_Flight;
	END IF;
	
	-- check that selected seat is valid
	OPEN SeatRec (seatNum);
	LOOP
		FETCH SeatRec INTO tempSeat;
		IF tempSeat = seatNum THEN
			isValidSeat := TRUE;
		END IF;
		EXIT WHEN isValidSeat OR SeatRec%NOTFOUND;
	END LOOP;
	
	-- raise exception if seat is not valid
	IF NOT isValidSeat THEN
		Raise Invalid_Seat;
	END IF;
	
	-- check if seat is available
	OPEN SeatBooked (seatNum);
	LOOP
		FETCH SeatBooked INTO tempSeat;
		IF tempSeat = seatNum THEN
			isAvailable := FALSE;
		END IF;
		EXIT WHEN NOT isAvailable OR SeatBooked%NOTFOUND;
	END LOOP;
	
	-- raise exception if seat not available, otherwise book seat
	IF NOT isAvailable THEN
		RAISE Seat_Taken;
	ELSE
		UPDATE Reservations 
			SET Seat = seatNum
			WHERE resNo = aResNo;
		COMMIT;
	END IF;
	
EXCEPTION
	-- invalid registration number
	WHEN No_Data_Found THEN
		aResult := 'Invalid Reservation Number';
	-- if flight from past
	WHEN Past_Flight THEN
		aResult := 'Flight In Past';
	-- if seat already taken
	WHEN Seat_Taken THEN
		aResult := 'Seat Already Taken';
	-- if seat not valid
	WHEN Invalid_Seat THEN
		aResult := 'No Such Seat';
	-- otherwise...
	WHEN OTHERS THEN
		aResult := 'Unknown Error';
END;
/
show error;