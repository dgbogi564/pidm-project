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
			out.print("<h1>Welcome, " + name + ".</h1>");
		%>

		<form method="get" action="alert_page.jsp">
			<h2>Wishlist</h2>
			<input type="submit" value="Set up an alert!">
		</form>
		<br> 
		<hr>
		<form method="get" action="auction_page.jsp">
			<h2>Go to Auction Page</h2>
			<input type="submit" value="Auction Page">
		</form> 
		<br> 
		<hr>
		
		<h2>Auction Info:</h2>
		<form method="get" action="">
			<input type="submit" value="Your Bids">
		</form> 
		<br>
		<form method="get" action="">
			<input type="submit" value="Items Sold">
		</form> 					
		<br> 
		<hr>
		
		<br><br><br>				
		<form method="get" action="deleteAccount.jsp">
			<input type="submit" value="Delete account">
		</form> 
		<br>
		<form method="post" action="logout.jsp">
			<input type="submit" value="Logout" />
		</form>
	</body>
</html>