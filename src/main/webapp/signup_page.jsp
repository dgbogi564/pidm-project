<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page session="true" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Signup</title>
	</head>
	<body>
		<%		
			if (session.getAttribute("userId") != null) {
				response.sendRedirect("login.jsp");	
			}
		%>
		<h1>Signup</h1>
		<form method="get" action="signup.jsp">
			<table>
				<tr>
					<td>Username</td>
					<td><input type="text" name="username"></td>
				</tr>
				<tr>
					<td>Password</td>
					<td><input type="text" name="password"></td>
				</tr>
			</table>
			<input type="submit" value="Submit">
		</form>
		<br>
		<br>
		<form method="post" action="login_page.jsp">
			<input type="submit" value="Login instead" />
		</form>
	</body>
</html>