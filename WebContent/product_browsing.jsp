<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
        import="java.io.PrintWriter" import="java.sql.*" import="java.util.*" import="javax.servlet.annotation.WebServlet" import="CSE135.SQL_Tables"%>
   
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Product Browsing Page</title>
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
		<script type = "text/javascript">
				alert("No users logged in");
				window.location = "login.jsp";
		</script>
	<% 
		}
		Statement stmt = connection.createStatement();
		ResultSet getAllResults = stmt.executeQuery("SELECT * FROM categories;");
	
	%>
	
	
	<ul>
	
	
		<% 
      	while(getAllResults.next()){
      	%>
      		<li><a href="category_products.jsp">"<%= getAllResults.getString("catName")%>"</a></li>
      		
      	<%
      		session.setAttribute("category", getAllResults.getString("catName"));
		}
		%>
		
		
	
	
	
	</ul>
		
	<form name = "product browsing" action = product_browsing.jsp method = "POST">
	<p>	Product Search: <input type = text name= "name">
	</p>
	<%
		String search_name = null;
	
		try{
			if(request.getParameter("name") != ""){
				search_name = request.getParameter("name");
			}
		}
		catch(Exception e){
			search_name = null;
		}
		if(search_name != null){
			Statement stmtt = connection.createStatement();
			ResultSet result = stmt.executeQuery("SELECT * FROM products WHERE prodName = '" + search_name +"';");
		%>
		<table border="1">
		<tr>
			<th>Product Name</th>
			<th>Sku number</th>
			<th>category</th>
			<th>price</th>
			
		</tr>
		<% 
			while(result.next()){
				%>
					<tr>
					<td>"<%=result.getString("prodName")%>"</td>
					<td>"<%=result.getString("SKU_Num")%>"</td>
					<td>"<%=result.getString("category_name")%>"</td>
					<td>"<%=result.getString("price")%>"</td>
					</tr>
				<%			
			}
		
		}
	%>
	</table>
	</form>		
	
	
			
</body>
</html>