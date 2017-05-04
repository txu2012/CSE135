<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
    import="java.io.PrintWriter" import="java.sql.*" import="java.util.*" import="javax.servlet.annotation.WebServlet" import="CSE135.SQL_Tables" import="java.io.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Shopping Cart</title>
		<h3>Shopping Cart</h3>
		<%
			Connection connection = SQL_Tables.connect();
			ResultSet results = null;
			float totalPrice = 0;
			
			String username = (String)session.getAttribute("user");
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
			
		<% } %>
	</head>
	<%
		String purchaseButton = request.getParameter("purchaseButton");
		
		if(purchaseButton != null){
			String ccInfo = request.getParameter("creditInfo");
			
			if(ccInfo != ""){
				connection.setAutoCommit(false);
				PreparedStatement cartQuery = connection.prepareStatement("SELECT shoppingCart.*, products.prodName, products.category_name " + 
						"FROM shoppingCart INNER JOIN products ON shoppingCart.productItems = products.SKU_Num WHERE shoppingCart.shoppingUsers = '" + username + "';");
							
				ResultSet cartResult = cartQuery.executeQuery();
				java.util.Date date = new java.util.Date();
				
				PreparedStatement purchaseQuery = connection.prepareStatement("INSERT INTO purchased (purchasedUser, purchasedDate, purchasedItem, purchasedAmount, purchasedName, purchasedPrice)" +
						"values(?,?,?,?,?,?)");
				while(cartResult.next()){
					purchaseQuery.setString(1, username);
					purchaseQuery.setString(2, date.toString());
					purchaseQuery.setString(3, cartResult.getString("productItems"));
					purchaseQuery.setInt(4, cartResult.getInt("amount"));
					purchaseQuery.setString(5, cartResult.getString("prodName"));
					purchaseQuery.setFloat(6, cartResult.getFloat("totalPrice"));
					purchaseQuery.executeUpdate();
				}
				
				PreparedStatement deleteShopping = connection.prepareStatement("DELETE FROM shoppingCart WHERE shoppingUsers = '" + username + "';");
				deleteShopping.executeUpdate();
				
				connection.commit();
				connection.setAutoCommit(true);
				
				session.setAttribute("purchaseDate", date.toString());
				response.sendRedirect("confirmation.jsp");
			}
			else{
				out.println("<p>Credit Card Information was not inputted</p>");
			}
		}
	%>
	<body>
		
			<table border="1">
				<tr>
					<th>Product Name</th>
					<th>Product Category</th>
					<th>Product SKU</th>
					<th>Product Price</th>
					<th>Product Amount</th>
				</tr>
				<%
				try{
					
					PreparedStatement shoppingCartQuery = connection.prepareStatement("SELECT shoppingCart.*, products.prodName, products.category_name " + 
							"FROM shoppingCart INNER JOIN products ON shoppingCart.productItems = products.SKU_Num WHERE shoppingCart.shoppingUsers = '" + username + "';");
								
					ResultSet cartResult = shoppingCartQuery.executeQuery();
					while(cartResult.next()){
						int amount = cartResult.getInt("amount");
						float currentPrice = cartResult.getFloat("totalPrice");
						totalPrice = totalPrice + (currentPrice * (float)amount);
				%>
						<tr>
							<td><%= cartResult.getString("prodName") %></td>
							<td><%= cartResult.getString("category_name") %></td>
							<td><%= cartResult.getString("productItems") %></td>
							<td><%= cartResult.getFloat("totalPrice") %></td>
							<td><%= cartResult.getInt("amount") %></td>
						</tr>
				
			<% 
					} 
					shoppingCartQuery.close();
					cartResult.close();
				}
				catch(SQLException e){
				}
			%>
			</table>
			<p>Total Price: <%= totalPrice %></p>
			<form action="buy_shopping_cart.jsp" method"POST">
				<p>Credit Card Information: </p>
				<input type="text" name="creditInfo" value="">
				<input type="submit" name="purchaseButton" value="Purchase">
			</form>
		<%			
			connection.close();
			Object userRole = session.getAttribute("roleType");
			if(userRole != null && userRole.equals("Owner")){
		%>		
				<ul>
					<li><a href="index.jsp">Home</a></li>
					<li><a href="category.jsp">Category</a></li>
					<li><a href="product_browsing.jsp">Product Browsing</a></li>
					<li><a href="product_order.jsp">Product Orders</a></li>		
				</ul>
		<%	
			}
			else{
		%>
				<ul>
					<li><a href="index.jsp">Home</a></li>		
				</ul>
		<%
			}
		%>
	</body>
</html>