<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
    import="java.io.PrintWriter" import="java.sql.*" import="javax.servlet.annotation.WebServlet" import="CSE135.SQL_Tables"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<p name="welcomeUser" value=""></p>
		<%
			Object newMsg = session.getAttribute("msg");
			if(newMsg != null){
				PrintWriter writer = response.getWriter();
				out.println(session.getAttribute("msg"));
			}
		%>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<h3>Home Page </h3>
		<a style="float: right" href="buy_shopping_cart.jsp">Buy Shopping Cart</a>
	</head>
	<body>
		<ul>
			<li><a href="signup.jsp">Sign Up</a></li>
			<li><a href="login.jsp">Login</a></li>
			<%
				Object category = session.getAttribute("category");
				Object products = session.getAttribute("products");
				Object browsing = session.getAttribute("browsing");
				Object order = session.getAttribute("order");
				if(category != null && products != null && browsing != null && order != null){
					PrintWriter writer = response.getWriter();
					out.println(category);
					out.println(products);
					out.println(browsing);
					out.println(order);
				}
			%>
		</ul>
	</body>
</html>