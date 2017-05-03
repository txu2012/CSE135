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
		ResultSet getAllResults = stmt.executeQuery("SELECT catName FROM categories;");
		
		
		Statement stmts = connection.createStatement();
	    
		
		if(request.getParameter("linkname") != null){
			if(!request.getParameter("linkname").equals("All")){
				results = stmts.executeQuery("SELECT * FROM products WHERE category_name = '" + request.getParameter("linkname") + "';");
			}
			else{
				results = stmts.executeQuery("SELECT * FROM products;");
			}
		}
		else{
			results = stmts.executeQuery("SELECT * FROM products;");
		}

%>
	
	
	
	
	<ul>
		<li><span><a href="product_browsing.jsp?linkname=All">All</a></span></li>
		
		<% 
      	while(getAllResults.next()){
      	%>
		<li><span><a href="product_browsing.jsp?linkname=<%=getAllResults.getString("catName")%>"><%= getAllResults.getString("catName")%></a></span></li>
      		
      	<%
      	}
		session.setAttribute("prodb", request.getParameter("linkname"));
		
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
			results = stmt.executeQuery("SELECT * FROM products WHERE prodName = '" + search_name +"';");
		}
		%>
		<table border="1">
		<tr>
			<th>Product Name</th>
			<th>Sku number</th>
			<th>category</th>
			<th>price</th>
			
		</tr>
		<% 
			while(results.next()){
				%>
					<tr>
					
					<td><a href="product_order.jsp?productname=<%=results.getString("prodName")%>"><%=results.getString("prodName")%></a></td>
					<td><%=results.getString("SKU_Num")%></td>
					<td><%=results.getString("category_name")%></td>
					<td><%=results.getString("price")%></td>
					</tr>
				<%			
			}
		
		    session.setAttribute("productorder", request.getParameter("productname"));

	%>
	</table>
	</form>		
	
	
			
</body>
		<ul>
			<li><a href="index.jsp">Home</a></li>
			
		</ul>
</html>