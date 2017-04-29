<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

<table border="1">
	<tr>
		<th>Product Name</th>
		<th>SKU</th>
		<th>category</th>
		<th>price</th>

	</tr>
	
	<tr>
		<form action="products.jsp" method= "POST">
		
		<td><input value="" name = "name"></td>
		<td><input value="" name = "SKU"></td>
		<td><select name = "category">
			<option value = ""></option>
		</select></td>
		<td><input value="" name = "price"></td>
	</tr>
</table>

</body>
</html>
