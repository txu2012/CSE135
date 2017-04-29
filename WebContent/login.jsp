<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Login in Page</title>
</head>
<body>
		<form name = "loginform" action ="login.jsp" method = "POST">
			<p>
				Name:<input type ="text" name = "username">
			
			</p>
			<p>
				<input type = "submit" value = "login">
			</p>
		</form>
                <%
			String username = null;
			String msg = null;
			try{
				try{
					username = request.getParameter("username");		
				}
				catch(Exception e){
					username = null;
				}
				if(username != null){
					Connection connection = SQL_Tables.connect();

					Statement stmt = connection.createStatement();
					ResultSet results = stmt.executeQuery("SELECT personName FROM users WHERE users.personName = '" + pname + "';");
					if(!results.next())
					{
						msg = "The provided name <" + username  + "> is not known" ;						
					}
					else{
						msg = "Login Successful";
					}

					
				}
				response.setContentType("text/html");
				PrintWriter out = reponse.getWriter();
				out.println(msg);
				

			}


	 	%>

</body>
</html>
