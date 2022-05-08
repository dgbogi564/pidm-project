<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.text.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page session="true" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="UTF-8">
	<title>sales report</title>
	<style>
		table, th, td {
			border: 1px solid black;
			border-collapse: collapse;
			text-align: center;
		}
		table {
			height: 35px;
			width: 65%;
		}
	</style>
</head>
<body>
	<h1>Summary Sales Report</h1>
	<!-- Calculate total from Auction's Highest Bid that ended Base on Date(Month or Day)-->
	<table>
		<thead>
			<tr>
				<th class="header">Auction Id</th>
				<th class="header">Highest Bid/Price</th>
				<th class="header">Expiration</th>		
			<tr>
		</thead>
		<tbody>
		  <!-- data goes here -->
			<%
				Connection con = null;
			
				// For table
				NumberFormat currency = NumberFormat.getCurrencyInstance();
				double currentPrice;
				double totalPrice = 0;
				
				try {
					//Get the database connection
					ApplicationDB db = new ApplicationDB();
					con = db.getConnection();

					//Create a SQL statement
					Statement stmt = con.createStatement();
					ResultSet result;

					String getAuctionTable = "SELECT auctionId, highestBid, initialPrice, expiration FROM Auction "
							+ "WHERE expiration < NOW()";
					result = stmt.executeQuery(getAuctionTable);
					
					// For table
					SimpleDateFormat date = new SimpleDateFormat("MMM d, yyyy hh:mm");
					
					// Iterate through ResultSet and add to table
					while (result.next()) {
						int auctionId = result.getInt(1);
						// currentPrice either initial price if no bids
						if ((currentPrice = result.getFloat(2)) == 0) {
							result.getFloat(3);
						}
						long expiration = result.getTimestamp(4).getTime();
						totalPrice += currentPrice;
			
						out.print("<tr>");
						out.print("<td>" + auctionId + "</td>");
						out.print("<td>" + currency.format(currentPrice) + "</td>");
						out.print("<td>" + date.format(expiration) + "</td>");
						out.print("</tr>");
					}
					
					con.close();
				} catch (Exception ex) {
					out.print(ex);
					ex.printStackTrace();
					out.print("<br>");
					out.print("<br>");
					out.print("Failed to display summary.");
					out.print("<form method=\"post\" action=\"../admin_page.jsp\">\n\t\t\t<input type=\"submit\" value=\"Go Back\" />\n\t\t</form>");
				}
			%>		  
				<tr>
					<td>TOTAL SUMMARY</td>
					<td colspan="2">
						<!-- Total Amount -->
						<%out.print(currency.format(totalPrice));%>
					</td>
				</tr>
			<tbody>
		</table>
	<br>
	<br>
	<form method="post" action="../admin_page.jsp">
		<input type="submit" value="Back to Admin page" />
	</form>
</body>
</html>