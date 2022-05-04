<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page session="true" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>auction page</title>
	</head>
	<body>
		<%
			String name = (String) session.getAttribute("name"); 
			out.print("<h1>Welcome, " + name + " to the Auction Site.</h1>");
		%>
		
		<form method="get" action="sell_item.jsp">
			<h2>Auction an item</h2>
			<input type="submit" value="Add item">
		</form>
		<br> 
		<hr>
		<form method="get" action="">
			<h2>Search for item</h2>
			<input type="submit" value="Filter">
		</form>
		<br>
		<hr>
		<form method="post" action="profile_page.jsp">
			<h2>Profile Page</h2>
			<input type="submit" value="Go back" />
		</form>
		<br>		
		<hr>
		
		<fieldset>
			<legend>Auctions</legend>
			<table>
				<tr>
					<td>Item Name</td>
					<td>Owner</td>
					<td>Highest Bid</td>
					<td>ID</td>
				</tr>
			</table>
		</fieldset>
						
	</body>
</html>