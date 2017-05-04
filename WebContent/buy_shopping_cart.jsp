<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
    import="java.io.PrintWriter" import="java.sql.*" import="java.util.*" import="javax.servlet.annotation.WebServlet" import="CSE135.SQL_Tables"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Shopping Cart</title>
		<h3>Shopping Cart</h3>
	</head>
	<body>
		<%
			Connection connection = SQL_Tables.connect();
			ResultSet results = null;
			Object newMsg = session.getAttribute("msg");
			if(newMsg != null){
				PrintWriter writer = response.getWriter();
				out.println(session.getAttribute("msg"));
			}
			else{
		%>
			<script type = "text/javascript">
					alert("No users logged in");
					window.location = "login.jsp";
			</script>
		<% 
			}
			
			Statement stmt = connection.createStatement();
			ResultSet getAllResults = stmt.executeQuery("SELECT * FROM shoppingCart, products,  WHERE shoppingUsers = '" + newMsg + "' AND ;");
		%>
	</body>
</html>