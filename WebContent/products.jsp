<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
    import="java.io.PrintWriter" import="java.sql.*" import="java.util.*" import="javax.servlet.annotation.WebServlet" import="CSE135.SQL_Tables"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Products</title>
		<h3>Products Page</h3>
	</head>
	<body>
		<%
			Connection connection = SQL_Tables.connect();
		
			Object newMsg = session.getAttribute("msg");
			if(newMsg != null){
				String position = "<section style='display: inline-block; vertical-align: top'>" + newMsg.toString() + "</section>";
				PrintWriter writer = response.getWriter();
				out.println(position);
			}
			else{
		%>
			<script type="text/javascript"> 
				alert("No users logged in");
				window.location = "login.jsp";
			</script>
		<%
			}
			String msg = "";
			String name = "";
			String price = "";
			String SKU = "";
			String category = "";
			
			Object userRole = session.getAttribute("roleType");
			if(userRole != null && userRole.equals("Owner")){
				
				String getButtonAction = request.getParameter("getAction");
				
				if(getButtonAction != null && getButtonAction.equals("Insert")){
					connection.setAutoCommit(false);
					
					name = request.getParameter("name");
					price = request.getParameter("price");
					SKU = request.getParameter("SKU");
					category = request.getParameter("category");
					
					if(name == "" && SKU == "" && price == ""){
						msg = "<p>Insert failed. Product name, SKU and price is missing.</p>";
						out.println(msg);
					}
					else if(name == ""){
						msg = "<p>Product name is missing.</p>";
						out.println(msg);
					}
					else if(SKU == ""){
						msg = "<p>Insert failed. Product SKU is missing.</p>";
						out.println(msg);
					}
					else if(price == ""){
						msg = "<p>Insert failed. Product price is missing.</p>";
						out.println(msg);
					}
					else if(name != "" && price != "" && SKU != ""){
					
						Statement stmt = connection.createStatement();
						ResultSet results = stmt.executeQuery("SELECT sku_num FROM products WHERE products.SKU_Num = '" + SKU + "';");
						
						if(results.next()){
							msg = "<p>Insert failed. Product already exists</p>";
							out.println(msg);
						}
						else{
							try{
								Float priceNum = Float.parseFloat(price);
								PreparedStatement pstmt = connection.prepareStatement("INSERT INTO products (prodName, SKU_Num, price, category_name)"+
																			" values(?,?,?,(SELECT catName FROM categories WHERE catName = '" + category + "'));");
								pstmt.setString(1, name);
								pstmt.setString(2, SKU);
								pstmt.setFloat(3, priceNum);
								pstmt.executeUpdate();
								connection.commit();
								
								msg = "<p>" + name + " has been successfully inserted. </p>";
								out.println(msg);
								
								connection.setAutoCommit(true);
								pstmt.close();
								stmt.close();
								results.close();
							}
							catch(NumberFormatException e){
								msg = "<p>Product price is not a number.</p>";
								out.println(msg);	
							}
						}
					}
				}
				else if(getButtonAction != null && getButtonAction.equals("Delete")){
					connection.setAutoCommit(false);
					
					SKU = request.getParameter("productSKU");	
					name = request.getParameter("productName");
					
					PreparedStatement pstmt = connection.prepareStatement("DELETE FROM products WHERE SKU_Num = '" + SKU + "';");
					pstmt.executeUpdate();
					connection.commit();
					
					msg = "<p>" + name + " has been successfully deleted. </p>";
					out.println(msg);
					
					connection.setAutoCommit(true);
					pstmt.close();

				}
				else if(getButtonAction != null && getButtonAction.equals("Update")){
					connection.setAutoCommit(false);
					
					name = request.getParameter("productName");
					price = request.getParameter("productPrice");
					SKU = request.getParameter("productSKU");
					category = request.getParameter("newCategory");
					
					if(name == "" && SKU == "" && price == ""){
						msg = "<p>Update failed. Product name, SKU and price is missing.</p>";
						out.println(msg);
					}
					else if(name == ""){
						msg = "<p>Update failed. Product name is missing.</p>";
						out.println(msg);
					}
					else if(SKU == ""){
						msg = "<p>Update failed. Product SKU is missing.</p>";
						out.println(msg);
					}
					else if(price == ""){
						msg = "<p>Update failed. Product price is missing.</p>";
						out.println(msg);
					}
					else if(name != "" && SKU != "" && price != ""){
						try{
							Float newPrice = Float.parseFloat(price);
							Statement stmts = connection.createStatement();
							ResultSet checkProd = stmts.executeQuery("SELECT * FROM products WHERE SKU_Num = '" + SKU + "';");
							PreparedStatement pstmt = null;
							
							pstmt = connection.prepareStatement("UPDATE products SET prodName = ?, category_name = ?, price = ?, SKU_num = ? WHERE SKU_Num = '" 
																		+ SKU + "' OR prodName = '" + name + "' OR price = '" + price + "';");
							pstmt.setString(1, name);
							pstmt.setString(2, category);
							pstmt.setFloat(3, newPrice);
							pstmt.setString(4, SKU);
							pstmt.executeUpdate();
							connection.commit();
							
							msg = "<p>" + name + " has been successfully updated. </p>";
							out.println(msg);
							
							connection.setAutoCommit(true);
							pstmt.close();
						}
						catch(NumberFormatException e){
							msg = "<p>Update failed. Product price is not a number.</p>";
							out.println(msg);	
						}
					}
				}
				
				Statement stmts = connection.createStatement();
				ResultSet getAllResults = null;
				String searchButton = request.getParameter("searchSubmit");
				
				if(request.getParameter("linkName") != null){
					if(!request.getParameter("linkName").equals("All")){
						if(request.getParameter("prodSearch") != null && searchButton != null){
							getAllResults = stmts.executeQuery("SELECT * FROM products WHERE category_name = '" + request.getParameter("linkName") + "' AND prodName = '" + request.getParameter("prodSearch") + "';");
						}
						else{
							getAllResults = stmts.executeQuery("SELECT * FROM products WHERE category_name = '" + request.getParameter("linkName") + "';");
						}
					}
					else{
						getAllResults = stmts.executeQuery("SELECT * FROM products;");
					}
				}
				else if(request.getParameter("prodSearch") != null && searchButton != null){
					getAllResults = stmts.executeQuery("SELECT * FROM products WHERE prodName = '" + request.getParameter("prodSearch") + "';");
				}
				else{
					getAllResults = stmts.executeQuery("SELECT * FROM products;");
				}
		%>
		<div style="float:right">
			<form action="products.jsp" method="POST">
				<p>Product Search</p>
				<input type="text" value="" name="prodSearch">
				<input type="submit" value="Search" name="searchSubmit">
			</form>
		</div>
		<section style="margin-top: 50px; display:inline-block">
			<ul>
				<li><span><a href="products.jsp?linkName=All">All</a></span></li>
			<%
				Statement stmtLinks = connection.createStatement();
				ResultSet categoryResults = stmtLinks.executeQuery("SELECT catName FROM categories");
				while(categoryResults.next()){
			%>
					<li><span><a href="products.jsp?linkName=<%=categoryResults.getString("catName")%>"><%= categoryResults.getString("catName")%></a></span></li>
			<% } 
				session.setAttribute("cate", request.getParameter("linkName"));
			%>
			</ul>
		</section>
		<section style="margin-top: 50px; display:inline-block">
			<table border="1">
				<tr>
					<th>Product Name</th>
					<th>SKU</th>
					<th>Category</th>
					<th>Current Category</th>
					<th>Price</th>
			
				</tr>
				
				<tr>
					<form action="products.jsp" method= "POST">
						<td><input type="text" value="" name="name"></td>
						<td><input type="text" value="" name="SKU"></td>
						<td><select name="category">
							<%
								Statement stmt = connection.createStatement();
								ResultSet catResults = stmt.executeQuery("SELECT catName FROM categories;");
								
								while(catResults.next()){
							%>
								<option value="<%= catResults.getString("catName")%>"> <%= catResults.getString("catName")%></option>
							<% } %>
						</select></td>
						<td>Current Category</td>
						<td><input type="text" value="" name ="price"></td>
						<td><input type="submit" name="getAction" value="Insert"></td>
					</form>
				</tr>
				<%
					while(getAllResults.next()) { 
				%>
				<tr>
					<form action="products.jsp" method="POST">
						<td><input type="text" value="<%= getAllResults.getString("prodName")%>" name="productName"></td>
						<td><input type="text" value="<%= getAllResults.getString("SKU_Num")%>" name="productSKU"></td>
						<td><select name="newCategory">
							<%
								//Statement stmtCat = connection.createStatement();
								catResults = stmt.executeQuery("SELECT catName FROM categories;");
								
								while(catResults.next()){
							%>
								<option value="<%= catResults.getString("catName")%>"> <%= catResults.getString("catName")%></option>
							<% } %>
							</select>
						</td>
						<td><%= getAllResults.getString("category_name")%></td>
						<td><input type="text" value="<%= getAllResults.getString("price")%>" name="productPrice"></td>
						<td><input type="submit" name="getAction" value="Update"></td>
						<td><input type="submit" name="getAction" value="Delete"></td>
						
					</form>
				</tr>
				<% } %>
			
			</table>
		</section>
		<ul>
			<li><a href="index.jsp">Home</a></li>
			<li><a href="category.jsp">Category</a></li>
			<li><a href="product_browsing.jsp">Product Browsing</a></li>
			<li><a href="product_order.jsp">Product Orders</a></li>		
		</ul>
	 	<% } 
			else{
				%>
		<p>This page is for owners only!</p>
		<ul>
			<li><a href="index.jsp">Home</a></li>
			<li><a href="product_browsing.jsp">Product Browsing</a></li>
		</ul>
		<% 
			}
	 	%>
	 	
	</body>
</html>
