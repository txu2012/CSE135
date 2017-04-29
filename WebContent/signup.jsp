<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.sql.*" import="java.util.*" import="javax.servlet.annotation.WebServlet" import="CSE135.SQL_Tables"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Sign up page</title>
	</head>
	<body>
	
		<form name = "signupform" action = "signup.jsp" method = "POST">
			<p>
				Name:<input type="text" name ="name">
            </p>
             
            <p> 
				Role:
				<select name = "role">
					<option value="Owner">Owner</OPTION>
					<option value="Customer">Customer</OPTION>
                </select>
			</p>

			<p>
				Age:<input type="text" name = "age" size="10">	
			</p>
			<p>
				States:
					<select name = "states" >
					<option value="Alabama">Alabama</option>
					<option value="Alaska">Alaska</option>
					<option value="Arizona">Arizona</option>
					<option value="Arkansas">Arkansas</option>
					<option value="California">California</option>
					<option value="Colorado">Colorado</option>
					<option value="Connecticut">Connecticut</option>
					<option value="Delaware">Delaware</option>
					<option value="District of Columbia">District Of Columbia</option>
					<option value="Florida">Florida</option>
					<option value="Georgia">Georgia</option>
					<option value="Hawaii">Hawaii</option>
					<option value="Idaho">Idaho</option>
					<option value="Illinois">Illinois</option>
					<option value="Indiana">Indiana</option>
					<option value="Iowa">Iowa</option>
					<option value="Kansas">Kansas</option>
					<option value="Kentucky">Kentucky</option>
					<option value="Louisiana">Louisiana</option>
					<option value="Maine">Maine</option>
					<option value="Maryland">Maryland</option>
					<option value="Massachusetts">Massachusetts</option>
					<option value="Michigan">Michigan</option>
					<option value="Minnesota">Minnesota</option>
					<option value="Mississippi">Mississippi</option>
					<option value="Missouri">Missouri</option>
					<option value="Montana">Montana</option>
					<option value="Nebraska">Nebraska</option>
					<option value="Nevada">Nevada</option>
					<option value="New Hampshire">New Hampshire</option>
					<option value="New Jersey">New Jersey</option>
					<option value="New Mexico">New Mexico</option>
					<option value="New York">New York</option>
					<option value="North Carolina">North Carolina</option>
					<option value="North Dakota">North Dakota</option>
					<option value="Ohio">Ohio</option>
					<option value="Oklahoma">Oklahoma</option>
					<option value="Oregon">Oregon</option>
					<option value="Pennsylvania">Pennsylvania</option>
					<option value="Rhode Island">Rhode Island</option>
					<option value="South Carolina">South Carolina</option>
					<option value="South Dakota">South Dakota</option>
					<option value="Tennessee">Tennessee</option>
					<option value="Texas">Texas</option>
					<option value="Utah">Utah</option>
					<option value="Vermont">Vermont</option>
					<option value="Virginia">Virginia</option>
					<option value="Washington">Washington</option>
					<option value="West Virgina">West Virginia</option>
					<option value="Wisconsin">Wisconsin</option>
					<option value="Wyoming">Wyoming</option>
					</select>
			</p>

			<p>
				<input type = "submit" value = "Sign up">
			</p>

		</form>
		<%
			String pname = null;
			String role = null;
			int age = 0;
			String states = null;
			
			try{
				//Connection connection;
				//Class.forName("org.postgresql.Driver");
				
				try{
					pname = request.getParameter("name");
					role = request.getParameter("role");
					age = Integer.parseInt(request.getParameter("age"));
					states = request.getParameter("states");
				}
				catch(Exception e){
					pname = null;
					role = null;
					age = 0;
					states = null;
				}
				
				if(pname != null && role != null && age != 0 && states != null){
					//connection = DriverManager.getConnection("jdbc:postgresql://localhost:5432/CSE_135?" + "user=postgres&password=admin");
					Connection connection = SQL_Tables.connect();
					
					Statement stmt = connection.createStatement();
					ResultSet results = stmt.executeQuery("SELECT personName FROM users WHERE users.personName = '" + pname + "';");
					
					if(results.next()){
						response.sendRedirect("SignUpFailure.jsp");
						return;
					}
					
					connection.setAutoCommit(false);
					
					
					PreparedStatement pstmt = connection.prepareStatement("INSERT INTO users (personName, roles, age, states) values(?,?,?,?);");
					pstmt.setString(1, pname);
					pstmt.setString(2, role);
					pstmt.setInt(3, age);
					pstmt.setString(4, states);
					pstmt.executeUpdate();
					connection.commit();
					
					response.sendRedirect("SignUpSuccess.jsp");
					return;
				}
			}
			catch (SQLException e){
				System.out.println(e.getMessage());
			}
		%>
	</body>
</html>