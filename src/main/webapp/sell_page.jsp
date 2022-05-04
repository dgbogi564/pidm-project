<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page session="true" %>

<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<title>sell item</title>
		<style>
			table {
				border-collapse: separate; 
				border-spacing: 1em 2em;
			}
		</style>
	</head>
	<body>
		<h1> Add Item for Auction </h1>
		<form method="get" action="sell_item.jsp">
			<table>
				<tr>
					<td>Item Name</td>
					<td><input type="text" name="itemName"></td>
				</tr>
				<tr>
					<td>Color</td>
					<td><input type="text" name="color"></td>
				</tr>
				<tr>
					<td>Condition</td>
					<td><input type="text" name="condition"></td>
				</tr>
				<tr>
					<td>Manufacturer</td>
					<td><input type="text" name="manufacturer"></td>
				</tr>						
			</table>
			
			<table>
				<tr>
					<td><input type="submit" value="Submit"></td>
					<td><input type="submit" formaction="auction_page.jsp" formmethod="POST" value="Cancel"></td>
				</tr>
			</table>
				
		</form>
		

	</body>
</html>