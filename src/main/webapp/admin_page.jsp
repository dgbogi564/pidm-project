<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page session="true" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="UTF-8">
<title>admin page</title>
</head>
<body>
	<h1><u>ADMIN PANEL</u></h1>
	<form method="get" action="Admin-Info/showUsers.jsp">
		<h2>Create Customer Representatives</h2>
		<input type="submit" value="See Users">
	</form>
	<br>
	<hr>
	<form method="get" action="Admin-Info/salesReport.jsp">
		<h2>Summary Sales Report</h2>
		<input type="submit" value="Sales Report">
	</form>
	<br>
	<hr>
	<br>
	<br>
	<form method="post" action="logout.jsp">
		<input type="submit" value="Logout" />
	</form>				
</body>
</html>