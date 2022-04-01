
<%-- <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
     --%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.myprojectshop.servlet.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Login Page</title>
	</head>
	
	<body>
		<h1> HELLO WORLD </h1>
		<form action="">
			<table>
				<tr>
					<td><label>Username</label></td> <td><input type = "text" name = "username"></td>
				</tr>

				<tr>
					<td><label>Password</label></td> <td><input type = "text" name = "password"></td>
				</tr>
			</table>
			<input type="submit" value="Submit">
		</form>
	</body>
</html>