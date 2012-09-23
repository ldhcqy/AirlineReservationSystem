import java.sql.*;

/**
 * AssignSeat.java - calls assign_seat procedure
 * @author Sarah Heredia
 * @version 12/09/2011
 */
public class AssignSeat 
{
	public int resNo;
	public String seatNum, aResult, DBstatus;
	private Connection conn;
	private CallableStatement stmt;
	private String user, pass;
	
	private String storedProc = "{ call assign_seat(?, ?, ?) }";
	
	public AssignSeat(int _resNo, String _seat)
	{
		this.resNo = _resNo;
		this.seatNum = _seat;
		
		user = "sheredia";
		pass = DbConnection.getPassword();
		
		try
		{
			DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
			conn = DriverManager.getConnection("jdbc:oracle:thin:@Picard2:1521:itec2", user, pass);
			
			stmt = conn.prepareCall(storedProc);
			
			// set parameters
			stmt.setInt(1, resNo);
			stmt.setString(2, seatNum);
			stmt.registerOutParameter(3, Types.VARCHAR);
			
			this.aResult = stmt.getString(3);
			
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

