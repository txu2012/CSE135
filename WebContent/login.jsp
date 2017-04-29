<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.io.PrintWriter" import="java.sql.*" import="javax.servlet.annotation.WebServlet" import="CSE135.SQL_Tables"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Login in Page</title>
</head>
<body>
		<form name = "loginform" action ="login.jsp" method = "POST">
			<p>
				Name:<input type ="text" name = "username">
			
			</p>
			<p>
				<input type = "submit" value = "login">
			</p>
		</form>
        <%
        	// Code to check for users within database
			String username = null;
			String msg = "";
			try{
				try{
					username = request.getParameter("username");		
				}
				catch(Exception e){
					username = null;
				}
				if(username != null){
					Connection connection = SQL_Tables.connect();
					Statement stmt = connection.createStatement();
					ResultSet results = stmt.executeQuery("SELECT personName FROM users WHERE users.personName = '" + username + "';");
					if(!results.next())
					{
						msg = "The provided name " + username  + " is not known" ;	
						response.setContentType("text/html");
						PrintWriter writer = response.getWriter();
						out.println(msg);
						return;
					}
					else{
						msg = "Hello " + username;
						String category = "<li><a href='category.jsp'>Category</a></li>";
						String products = "<li><a href='products.jsp'>Products</a></li>";
						String browsing = "<li><a href='product_browsing.jsp'>Product Browsing</a></li>";
						String order = "<li><a href='product_order.jsp'>Product Orders</a></li>";
						
						session.setAttribute("msg", msg);
						session.setAttribute("category", category);
						session.setAttribute("products", products);
						session.setAttribute("browsing", browsing);
						session.setAttribute("order", order);
						
						response.sendRedirect("index.jsp");
						
						return;
					}
				}
			}
			catch(SQLException e){	
				System.out.println(e.getMessage());
			}


	 	%>

</body>
</html>
