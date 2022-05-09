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
			width: 65%;
		}
	</style>
</head>
<body>
	<h1>Summary Sales Report</h1>
	
	<h3>Total Earnings</h3>
	<p> Total Earnings Report are calculated from the Highest Bid placed from all auction that are over. <p>
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
				double currentPrice = 0;
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
			
						// NOTE WE DON'T COUNT initial price into total, but we list the highest bid/price as zero 
						if ((currentPrice = result.getFloat(2)) == 0.0) {
							/* result.getFloat(3); */
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
					out.print("Failed to display summary report.");
					out.print("<form method=\"post\" action=\"../admin_page.jsp\">\n\t\t\t<input type=\"submit\" value=\"Go Back\" />\n\t\t</form>");
				}
			%>		  
				<tr>
					<td>TOTAL SUMMARY</td>
					<td colspan="2">
						<!-- Total Earning Amount -->
						<%out.print(currency.format(totalPrice));%>
					</td>
				</tr>
			<tbody>
		</table>
		
		<br>
		<hr>
		<h3>Earnings per Item</h3>
		<p>Displays the total earnings per specific category of item type clothing.</p>
		<table>
			<thead>
				<tr>
					<th class="header">Shirts</th>
					<th class="header">Pants</th>
					<th class="header">Shoes</th>	
					<th class="header">Top Seller ID</th>
				</tr>
			</thead>
			<tbody>
			
				<%
					try {
						//Get the database connection
						ApplicationDB db = new ApplicationDB();
						con = db.getConnection();
		
						//Create a SQL statement
						Statement stmt = con.createStatement();
						ResultSet result;

						//USE THIS ONCE BID IS SET UP!!
/* 						String getAuctionTable2 = "SELECT a.highestBid, a.itemId, a.sellerId, " +
						"c.name FROM Auction a, Clothes c WHERE a.itemId = c.itemId AND a.highestBid IS NOT NULL " +
						"AND a.expiration < NOW()"; */
						
						//TESTING..delete later
						String getAuctionTable2 = "SELECT a.highestBid, a.itemId, a.sellerId, " +
						"c.name FROM Auction a, Clothes c WHERE a.itemId = c.itemId " +
						"AND a.expiration < NOW()";

						// Get the specific type of clothing
/* 						String typeShirts = "SELECT c.armLength, c.collarSize, c.waistSize FROM Shirts c, Auction a " +
							"WHERE c.itemId = a.itemId AND a.itemId = '" + itemId + "'";
						String typePants = "SELECT p.width, p.length FROM Pants p, Auction a " +
								"WHERE p.itemId = a.itemId AND a.itemId = '" + itemId + "'";
						String typeShoes = "SELECT s.size FROM Shoes s, Auction a " +
								"WHERE s.itemId = a.itemId AND a.itemId = '" + itemId + "'"; */
						// Shirts
/* 						result = stmt.executeQuery(typeShirts);
						if(result.next()) {
							System.out.println("1");
							out.print("<tr>");
							out.print("<td>" + currency.format(highestBid) + "</td>");
							out.print("<td>" + "</td>");
							out.print("<td>" + "</td>");
							out.print("</tr>");
						} */
						// Pants
/* 						result = stmt.executeQuery(typePants);
						if(result.next()) {
							System.out.println("2");
							out.print("<tr>");
							out.print("<td>" + "</td>");
							out.print("<td>" + currency.format(highestBid) + "</td>");
							out.print("<td>" + "</td>");
							out.print("</tr>");
						} */
						// Shoes
/* 						result = stmt.executeQuery(typeShoes);
						if(result.next()) {
							System.out.println("3");
							out.print("<tr>");
							out.print("<td>" + "</td>");
							out.print("<td>" + "</td>");
							out.print("<td>" + currency.format(highestBid) + "</td>");
							out.print("</tr>");
						} */
					
						result = stmt.executeQuery(getAuctionTable2);
						
						// Iterate through ResultSet and add to table
						while (result.next()) {
							System.out.println("HOW MANY TIMES?");
							double highestBid = result.getFloat(1);
							int itemId = result.getInt(2);
							int sellerId = result.getInt(3);
							String itemName = result.getString(4);

						}
						
						con.close();
					
					} catch (Exception ex) {
						out.print(ex);
						ex.printStackTrace();
						out.print("<br>");
						out.print("<br>");
						out.print("Failed to display summary report.");
						out.print("<form method=\"post\" action=\"../admin_page.jsp\">\n\t\t\t<input type=\"submit\" value=\"Go Back\" />\n\t\t</form>");
					}
				%>
			</tbody>			
		</table>
		
	<br>
	<br>
	<form method="post" action="../admin_page.jsp">
		<input type="submit" value="Back to Admin page" />
	</form>
</body>
</html>