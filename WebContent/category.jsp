<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Category</title>
<h3>Category Page</h3>
</head>
<body>

<table border="1">
	<tr>
		<th>Category Name</th>
		<th>Description</th>
	</tr>
	
	<tr>	
		<form action=s"category.jsp" method=s"POST">
		
		<td><input value="" name="name"></td>
		<td><textarea name="description"></textarea></td>
		<td><input type="submit" value="Insert"></td>
		</form>
	</tr>
</table>

</body>
</html>
