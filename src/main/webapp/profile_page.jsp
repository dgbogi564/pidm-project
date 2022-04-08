<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page session="true" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Login</title>
	</head>
	<body>
		<%
			String name = (String) session.getAttribute("name"); 
			out.print("<h1>Welcome, " + name + "</h1>");
		%>
		
		<form method="get" action="deleteAccount.jsp">
			<table> 
				<tr>
					<td><input type="submit" value="Delete account"></td> 
				</tr>				
			</table>
		</form> 
		<br>
		<form method="post" action="logout.jsp">
			<input type="submit" value="Logout" />
		</form>
	</body>
</html>