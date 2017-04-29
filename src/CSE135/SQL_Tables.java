package CSE135;

import java.sql.*;
import javax.servlet.annotation.WebServlet;

@WebServlet("/SQL_Tables")
public class SQL_Tables {

	public static Connection connection;
	
	public static Connection connect() throws ClassNotFoundException, SQLException{
		Class.forName("org.postgresql.Driver");
		connection = DriverManager.getConnection("jdbc:postgresql://localhost:5432/CSE_135?" + "user=postgres&password=admin");
		return connection;
	}
}
