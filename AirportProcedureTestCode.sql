REMARK Testing code for make_reservation procedure	
SET SERVEROUTPUT ON;
DECLARE
	aResult VARCHAR2(20);
	resNo 	NUMBER;
BEGIN
	-- Test no such flight
	make_reservation
	(
		'Z999',
		to_date('11-25-2011', 'MM-DD-YYYY'),
		'Heredia',
		'Sarah',
		to_date('05-07-1984', 'MM-DD-YYYY'),
		aResult,
		resNo
	);
	dbms_output.put_line(aResult);
		
	-- Flight in Past
	make_reservation
	(
		'A111',
		to_date('10-01-2011', 'MM-DD-YYYY'),
		'Heredia',
		'Sarah',
		to_date('05-07-1984', 'MM-DD-YYYY'),
		aResult,
		resNo
	);
	dbms_output.put_line(aResult);
		
	-- Flight Full
	make_reservation
	(
		'F666',
		to_date('12-10-2011', 'MM-DD-YYYY'),
		'Heredia',
		'Sarah',
		to_date('05-07-1984', 'MM-DD-YYYY'),
		aResult,
		resNo
	);
	make_reservation
	(
		'F666',
		to_date('12-10-2011', 'MM-DD-YYYY'),
		'Heredia',
		'Sarah',
		to_date('05-07-1984', 'MM-DD-YYYY'),
		aResult,
		resNo
	);
	make_reservation
	(
		'F666',
		to_date('12-10-2011', 'MM-DD-YYYY'),
		'Heredia',
		'Sarah',
		to_date('05-07-1984', 'MM-DD-YYYY'),
		aResult,
		resNo
	);
	dbms_output.put_line(aResult);
		
	-- Success
	make_reservation
	(
		'G777',
		to_date('12-07-2011', 'MM-DD-YYYY'),
		'Heredia',
		'Sarah',
		to_date('05-07-1984', 'MM-DD-YYYY'),
		aResult,
		resNo
	);
	dbms_output.put_line(aResult);
END;
/
REMARK Testing code for assign_seat procedure	
SET SERVEROUTPUT ON;
DECLARE
	aResult VARCHAR2(30);
BEGIN
	-- Invalid Reservation Number
	assign_seat(7, '1A', aResult);
	dbms_output.put_line(aResult);
	
	-- Flight in Past
	assign_seat(1, '3B', aResult);
	dbms_output.put_line(aResult);
	
	-- Seat Already Taken
	assign_seat(3, '1B', aResult);
	dbms_output.put_line(aResult);
	
	-- No Such Seat
	assign_seat(3, '1P', aResult);
	dbms_output.put_line(aResult);
	
	-- Success
	assign_seat(6, '2A', aResult);
	dbms_output.put_line(aResult);
END;
/