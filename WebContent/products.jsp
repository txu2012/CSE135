<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
    import="java.io.PrintWriter" import="java.sql.*" import="java.util.*" import="javax.servlet.annotation.WebServlet" import="CSE135.SQL_Tables"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Products</title>
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
			
			Object userRole = session.getAttribute("roleType");
			if(userRole != null && userRole.equals("Owner")){
				
				String getButtonAction = request.getParameter("getAction");
				
				if(getButtonAction != null && getButtonAction.equals("Insert")){
					connection.setAutoCommit(false);
					
					String name = request.getParameter("name");
					String price = request.getParameter("price");
					String SKU = request.getParameter("SKU");
					String category = request.getParameter("category");
					
					if(name == ""){
						String msg = "<p>Product name is missing.</p>";
						response.setContentType("text/html");
						PrintWriter writer = response.getWriter();
						out.println(msg);
					}
					else if(SKU == ""){
						String msg = "<p>Product SKU is missing.</p>";
						response.setContentType("text/html");
						PrintWriter writer = response.getWriter();
						out.println(msg);
					}
					else if(price == ""){
						String msg = "<p>Product price is missing.</p>";
						response.setContentType("text/html");
						PrintWriter writer = response.getWriter();
						out.println(msg);
					}
					else if(name != "" && price != "" && SKU != ""){
					
						Statement stmt = connection.createStatement();
						ResultSet results = stmt.executeQuery("SELECT sku_num FROM products WHERE products.SKU_Num = '" + SKU + "';");
						
						if(results.next()){
							String msg = "<p>Product already exists</p>";
							response.setContentType("text/html");
							PrintWriter writer = response.getWriter();
							out.println(msg);
						}
						else{
							//results = stmt.executeQuery("SELECT * FROM categories;");
							//int i = results.last().getRow();
							try{
								Float priceNum = Float.parseFloat(price);
								PreparedStatement pstmt = connection.prepareStatement("INSERT INTO products (prodName, SKU_Num, price, category_name) values(?,?,?,(SELECT catName FROM categories where catName = '" + category + "'));");
								pstmt.setString(1, name);
								pstmt.setString(2, SKU);
								//pstmt.setString(3, category);
								pstmt.setFloat(3, priceNum);
								pstmt.executeUpdate();
								connection.commit();
								
								connection.setAutoCommit(true);
								pstmt.close();
								stmt.close();
								results.close();
							}
							catch(NumberFormatException e){
								String msg = "<p>Product price is not a number.</p>";
								response.setContentType("text/html");
								PrintWriter writer = response.getWriter();
								out.println(msg);	
							}
						}
					}
					else{
						String msg = "<p>Category Name and Description required.</p>";
						response.setContentType("text/html");
						PrintWriter writer = response.getWriter();
						out.println(msg);
					}
				}
				else if(getButtonAction != null && getButtonAction.equals("Delete")){
					connection.setAutoCommit(false);
					
					String SKU = request.getParameter("productSKU");		
					
					PreparedStatement pstmt = connection.prepareStatement("DELETE FROM products WHERE SKU_Num = '" + SKU + "';");
					pstmt.executeUpdate();
					connection.commit();
					
					connection.setAutoCommit(true);
					pstmt.close();

				}
				else if(getButtonAction != null && getButtonAction.equals("Update")){
					connection.setAutoCommit(false);
					
					String name = request.getParameter("productName");
					String price = request.getParameter("productPrice");
					String SKU = request.getParameter("productSKU");
					String category = request.getParameter("newCategory");
					
					if(name == ""){
						String msg = "<p>Product name is missing.</p>";
						response.setContentType("text/html");
						PrintWriter writer = response.getWriter();
						out.println(msg);
					}
					else if(SKU == ""){
						String msg = "<p>Product SKU is missing.</p>";
						response.setContentType("text/html");
						PrintWriter writer = response.getWriter();
						out.println(msg);
					}
					else if(price == ""){
						String msg = "<p>Product price is missing.</p>";
						response.setContentType("text/html");
						PrintWriter writer = response.getWriter();
						out.println(msg);
					}
					else if(name != "" && SKU != "" && price != ""){
						try{
							Float newPrice = Float.parseFloat(price);
							Statement stmts = connection.createStatement();
							ResultSet checkProd = stmts.executeQuery("SELECT * FROM products WHERE SKU_Num = '" + SKU + "';");
							PreparedStatement pstmt = null;
							
							pstmt = connection.prepareStatement("UPDATE products SET prodName = ?, category_name = ?, price = ?, SKU_num = ? WHERE SKU_Num = '" + SKU + "' OR prodName = '" + name + "' OR price = '" + price + "';");
							pstmt.setString(1, name);
							pstmt.setString(2, category);
							pstmt.setFloat(3, newPrice);
							pstmt.setString(4, SKU);
							pstmt.executeUpdate();
							connection.commit();
							
							connection.setAutoCommit(true);
							pstmt.close();
						}
						catch(NumberFormatException e){
							String msg = "<p>Product price is not a number.</p>";
							response.setContentType("text/html");
							PrintWriter writer = response.getWriter();
							out.println(msg);	
						}
					}
				}
				
				Statement stmts = connection.createStatement();
				ResultSet getAllResults = stmts.executeQuery("SELECT * FROM products;");
		%>

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
			
			<% while(getAllResults.next()) { %>
			</tr>
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
			<tr>
			<% } %>
			</tr>
		</table>
	 	<% } %>
	</body>
</html>
