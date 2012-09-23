import java.sql.*;
import java.text.*;

/**
 * MakeReservation.java - calls make_reservation procedure
 * @author Sarah Heredia
 * @version 12/09/2011
 */
public class MakeReservation 
{
	public int resNo;
	public String flightNo, departDate, passengerLname, 
				  passengerFname, passengerBirthDate, DBstatus,
				  aResult;
	private java.util.Date dDate;
	private java.util.Date dobDate;
	private Connection conn;
	private CallableStatement stmt;
	private String user, pass;
	
	private String storedProc = "{ call make_reservation(?, ?, ?, ?, ?, ?, ?) }";
	DateFormat formatter = new SimpleDateFormat("MM-dd-yyyy");
	
	
	
	public MakeReservation(String _flightNo, String _departDate, String _pln,
						String _pfn, String _pbd) throws ParseException
	{
		this.resNo = 0;
		this.flightNo = _flightNo;
		this.departDate = _departDate;
		this.passengerLname = _pln;
		this.passengerFname = _pfn;
		this.passengerBirthDate = _pbd;
		this.DBstatus = "";
		this.aResult = "";
		
		// convert string date for depart date to sql date
		this.dDate = (java.util.Date) formatter.parse(departDate);
		java.sql.Date sqlDate = new java.sql.Date(dDate.getTime());
		
		// convert string date for birthdate to sql date
		this.dobDate = (java.util.Date) formatter.parse(passengerBirthDate);
		java.sql.Date sqlDobDate = new java.sql.Date(dobDate.getTime());
		
		user = "sheredia";
		pass = DbConnection.getPassword();
		
		try
		{
			DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
			conn = DriverManager.getConnection("jdbc:oracle:thin:@Picard2:1521:itec2", user, pass);
			
			stmt = conn.prepareCall(storedProc);
			
			// set parameters
			stmt.setString(1, flightNo);
			stmt.setDate(2, sqlDate);
			stmt.setString(3, passengerFname);
			stmt.setString(4, passengerLname);
			stmt.setDate(5, sqlDobDate);
			stmt.registerOutParameter(6, Types.VARCHAR);
			stmt.registerOutParameter(7, Types.INTEGER);
			
			stmt.execute();
			
			this.aResult = stmt.getString(6);
			this.resNo = stmt.getInt(7);
			
			
			
			stmt.execute();
			
			conn.close();
		}
		catch (SQLException e)
		{
			DBstatus = "Error";
			System.out.println(e);
		}
	}
}
