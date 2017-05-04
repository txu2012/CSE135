<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
    import="java.io.PrintWriter" import="java.sql.*" import="java.util.*" import="javax.servlet.annotation.WebServlet" import="CSE135.SQL_Tables"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Category</title>
		<h3>Category Page</h3>
		<%
			Connection connection = SQL_Tables.connect();
		
			Object newMsg = session.getAttribute("msg");
			if(newMsg != null){
		%>
				<a style="float: right" href="buy_shopping_cart.jsp">Buy Shopping Cart</a>		
		<%
				PrintWriter writer = response.getWriter();
				out.println(session.getAttribute("msg"));
			}
			else{
		%>
			<script type="text/javascript"> 
				alert("No users logged in");
				window.location = "login.jsp";
			</script>
	</head>
	<body>
		<%
			}
			
			Object userRole = session.getAttribute("roleType");
			if(userRole != null && userRole.equals("Owner")){
		%>
	
			<% 	
				try{
				
					String getButtonAction = request.getParameter("getAction");
					
					if(getButtonAction != null && getButtonAction.equals("Insert")){
						connection.setAutoCommit(false);
						
						String name = request.getParameter("name");
						String desc = request.getParameter("description");
						
						if(name != "" && desc != ""){
						
							Statement stmt = connection.createStatement();
							ResultSet results = stmt.executeQuery("SELECT catName FROM categories WHERE categories.catName = '" + name + "';");
							
							if(results.next()){
								String msg = "<p>Category already exists</p>";
								response.setContentType("text/html");
								PrintWriter writer = response.getWriter();
								out.println(msg);
							}
							else{
								PreparedStatement pstmt = connection.prepareStatement("INSERT INTO categories (catName, descrip, prodNum) values(?,?,?);");
								pstmt.setString(1, name);
								pstmt.setString(2, desc);
								pstmt.setInt(3, 0);
								pstmt.executeUpdate();
								connection.commit();
								
								connection.setAutoCommit(true);
								pstmt.close();
								stmt.close();
								results.close();
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
						
						String name = request.getParameter("categoryName");
						String desc = request.getParameter("categoryDesc");
						
						
						try{
							PreparedStatement pstmt = connection.prepareStatement("DELETE FROM categories WHERE categories.catName = '" + name + "';");
							pstmt.executeUpdate();
							connection.commit();
							
							connection.setAutoCommit(true);
							pstmt.close();
						}
						catch(SQLException e){
							%>
								<script type="text/javascript"> 
									alert("Category still has 1 or more products connected to it.");
									window.location = "category.jsp";
								</script>
							
							<%
						}
	
					}
					else if(getButtonAction != null && getButtonAction.equals("Update")){
						connection.setAutoCommit(false);
						String name = request.getParameter("categoryName");
						String desc = request.getParameter("categoryDesc");
						
						if(name == ""){
							String msg = "<p>Category Name is missing.</p>";
							response.setContentType("text/html");
							PrintWriter writer = response.getWriter();
							out.println(msg);
						}
						else if(desc == ""){
							String msg = "<p>Category Description is missing.</p>";
							response.setContentType("text/html");
							PrintWriter writer = response.getWriter();
							out.println(msg);
						}
						else{
							PreparedStatement pstmt = null;
							
							pstmt = connection.prepareStatement("UPDATE categories SET descrip = ?, catName = ? WHERE categories.catName = '" + name + "' OR categories.descrip = '" + desc + "';");
							pstmt.setString(1, desc);
							pstmt.setString(2, name);
							pstmt.executeUpdate();
							connection.commit();
							
							connection.setAutoCommit(true);
							pstmt.close();
						}
					}
			
					Statement stmts = connection.createStatement();
					ResultSet getAllResults = stmts.executeQuery("SELECT * FROM categories;");
			%>
		
		<table border="1">
			<tr>
				<th>Category Name</th>
				<th>Description</th>
			</tr>
			
			<tr>	
				<form action="category.jsp" method="POST">
					<td><input value="" name="name"></td>
					<td><textarea name="description"></textarea></td>
					<td><input type="submit" name="getAction" value="Insert"></td>
				</form>
			</tr>
			
			<%
				while(getAllResults.next()) {
			%>
			
			<tr>
				<form action="category.jsp" method="POST">
					<td><input type="text" value="<%= getAllResults.getString("catName")%>" name="categoryName"></td>
					<td><textarea name="categoryDesc"><%= getAllResults.getString("descrip")%></textarea></td>
					<td><input type="submit" name="getAction" value="Update"></td>
					<% 
						if(getAllResults.getInt("prodNum") <= 0){
					%>
						<td><input type="submit" name="getAction" value="Delete"></td>
					<% } %>
				</form>
			</tr>
			
			<% 
				}
			%>
		</table>
		<ul>
			<li><a href="index.jsp">Home</a></li>
			<li><a href="products.jsp">Products</a></li>
			<li><a href="product_browsing.jsp">Product Browsing</a></li>
			<li><a href="product_order.jsp">Product Orders</a></li>		
		</ul>
	<%
				connection.close();
				getAllResults.close();
			}
			catch(SQLException e){
				e.printStackTrace();
			}
		}
		else{
	%>
	<p>This page is for owners only!</p>
	<ul>
			<li><a href="index.jsp">Home</a></li>
			<li><a href="product_browsing.jsp">Product Browsing</a></li>
		</ul>
	<% } %>

	</body>
</html>
