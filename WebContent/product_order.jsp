<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
    import="java.io.PrintWriter" import="java.sql.*" import="java.util.*" import="javax.servlet.annotation.WebServlet" import="CSE135.SQL_Tables"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Product order page</title>
		<h3>Product Order</h3>
		<%
			Connection connection = SQL_Tables.connect();
			String newMsg = (String)session.getAttribute("msg");
			String username = (String)session.getAttribute("user");

			if(newMsg != null){
		%>
				<a style="float: right" href="buy_shopping_cart.jsp">Buy Shopping Cart</a>		
		<%
				PrintWriter writer = response.getWriter();
				out.println(session.getAttribute("msg"));
			}
			else{
		%>
			<script type = "text/javascript">
					alert("No users logged in");
					window.location = "login.jsp";
			</script>
		
	</head>
	<body>
		<%	}
			
				String getProduct = request.getParameter("productname");
				
				String buyButtonAction = request.getParameter("getAction");
	
				if(buyButtonAction != null){
					connection.setAutoCommit(false);
					String getAmount = request.getParameter("prodAmount");
					
					if(getAmount == ""){
						out.println("<p>Invalid number of products, please input the number of products for order.</p>");

					}
					else{
						try{
							int productOrderAmount = Integer.parseInt(getAmount);
							float totalPrice = Float.parseFloat(request.getParameter("getPrice"));
							
							PreparedStatement shoppingCartInsert = connection.prepareStatement("INSERT INTO shoppingCart (shoppingUsers, totalPrice, amount, productItems) " +
												"values(?,?,?,?);");
							
							shoppingCartInsert.setString(1, username);
							shoppingCartInsert.setFloat(2, totalPrice);
							shoppingCartInsert.setInt(3, productOrderAmount);
							shoppingCartInsert.setString(4, request.getParameter("getSKU"));
							
							shoppingCartInsert.executeUpdate();
							connection.commit();
							connection.setAutoCommit(true);
							shoppingCartInsert.close();
							out.println("<p>Ordered successfully.</p>");
						}
						catch(NumberFormatException e){
							out.println("<p>Please input a valid number for order.</p>");
						}
					}
				}
		%>
		
				<table border="1">
					<tr>
						<th>Product Name</th>
						<th>Product Category</th>
						<th>Product SKU</th>
						<th>Product Price</th>
						<th>Product Amount</th>
					</tr>
					<% 
						PreparedStatement pstmt = connection.prepareStatement("SELECT * FROM products WHERE products.prodName = '" + getProduct + "';");
						ResultSet getAllResults = pstmt.executeQuery();
						while(getAllResults.next()) {
					%>
							<tr>
								<form action="product_order.jsp?productname=<%= getProduct %>" method="POST">
									<td><input style="border:0; outline:0; overflow:visible" name="getName" value="<%= getAllResults.getString("prodName") %>" readonly></td>
									<td><input style="border:0; outline:0; overflow:visible" name="getCat" value="<%= getAllResults.getString("category_name") %>" readonly></td>
									<td><input style="border:0; outline:0; overflow:visible" name="getSKU" value="<%= getAllResults.getString("SKU_Num") %>" readonly></td>
									<td><input style="border:0; outline:0; overflow:visible" name="getPrice" value="<%= getAllResults.getFloat("price") %>" readonly></td>
									<td><input type="text" value="" name="prodAmount"></td>
									<td><input type="submit" value="Buy" name="getAction"></td>
								</form>
							</tr>
					<% } %>
				</table>
		
		<% //} %>
		
		<h3>Current Shopping Cart</h3>
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
				}
				catch(SQLException e){
				}
			%>
		</table>
		
		<ul>
			<li><a href="index.jsp">Home</a></li>	
		</ul>
	</body>
</html>