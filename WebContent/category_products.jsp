<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
    import="java.io.PrintWriter" import="java.sql.*" import="java.util.*" import="javax.servlet.annotation.WebServlet" import="CSE135.SQL_Tables"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Category Products</title>
		<h3>Category Products</h3>
	</head>
	
	<body>
		<%
			Connection connection = SQL_Tables.connect();
		
			Object newMsg = session.getAttribute("msg");
			if(newMsg != null){
				PrintWriter writer = response.getWriter();
				out.println(session.getAttribute("msg"));
			}
			else{
		%>
			<script type="text/javascript"> 
				alert("No users logged in");
				window.location = "login.jsp";
			</script>
		<%
			}
			Object cate = request.getParameter("linkName");
			out.println("<p> Category " + cate + "</p>");
			Statement stmts = connection.createStatement();
			Object category_products = session.getAttribute("product_category");
			if(category_products instanceof String){
				ResultSet getAllResults = stmts.executeQuery("SELECT * FROM products WHERE category_name = '" + category_products + "';");
		%>
		
		
		<% } %>
	</body>
</html>