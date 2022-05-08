<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page session="true" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="UTF-8">
<title>sales report</title>
</head>
<body>
	<h1>Summary Sales Report</h1>
	<!-- Calculate total from Auction's Highest Bid that ended Base on Date(Month or Day)-->
	<table>
		<thead>
			<tr>
				<th class="header">Auction Id</th>
				<th class="header">Highest Bid</th>
				<th class="header">Expiration</th>		
			<tr>
		</thead>
		<tbody>
		  <!-- data goes here -->
			<%
				Connection con = null;
				try {
					//Get the database connection
					ApplicationDB db = new ApplicationDB();
					con = db.getConnection();

					//Create a SQL statement
					Statement stmt = con.createStatement();
					ResultSet result;

					String getAuctionTable = "SELECT a.auctionId, a.title, u.name, a.highestBid, a.initialPrice, a.expiration FROM Auction a, User u WHERE a.sellerId = u.userId AND expiration > NOW()";
					result = stmt.executeQuery(getAuctionTable);
					
					con.close();
				} catch (Exception ex) {
					out.print(ex);
					ex.printStackTrace();
					out.print("<br>");
					out.print("<br>");
					out.print("Failed to display auctions.");
				}
			%>		  
		  
		  
		  
		  
			<tr>
				<td>TOTAL SUMMARY</td>
				<td>
					<!-- Total Amount -->
				</td>
			</tr>
		<tbody>
	</table>
</body>
</html>