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
	<style>
		table, th, td {
			border: 1px solid black;
			border-collapse: collapse;
		}
		table {
			width: 100%;
		}
	</style>	
	</head>
	<body>
		<%
			String name = (String) session.getAttribute("name"); 
			out.print("<h1>Welcome " + name + ", to the Auction Site.</h1>");
		%>
		
		<form method="post" action="sell_page.jsp">
			<h2>Auction an item</h2>
			<input type="submit" value="Add item">
		</form>
		<br> 
		<hr>
		<form method="post" action="">
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
					<th>Title</th>
					<th>Item ID</th>
					<th>Color</th>
					<th>Condition</th>
					<th>Manufacturer</th>
					<th>Highest Bid</th>
					
					<!-- Should take us to the individual auction page
					 where we can see more info & place bid -->
					<th>See Info Here!</th>
				</tr>
			</table>
		</fieldset>
						
	</body>
</html>