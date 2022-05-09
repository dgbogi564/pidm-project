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
	<p> Total Earnings Report are calculated from the Highest Bid placed from all auction that are over. If bid/price is $0.00, auction had no bids.<p>
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
					<th class="header">Seller ID</th>
					<th class="header">Shirts</th>
					<th class="header">Pants</th>
					<th class="header">Shoes</th>
				</tr>
			</thead>
			<tbody>
			
				<%
					//to be used in table
					double highestBid = 0;
					double totalShirt = 0;
					double totalPants = 0;
					double totalShoes = 0;
					int sellerId;
					
					try {
						//Get the database connection
						ApplicationDB db = new ApplicationDB();
						con = db.getConnection();
		
						//Create a SQL statement
						Statement stmt = con.createStatement();
						ResultSet result;

						//Find expired auction details
 						String getAuctionTable2 = "SELECT a.highestBid, a.itemId, a.sellerId, " +
						"c.name FROM Auction a, Clothes c WHERE a.itemId = c.itemId AND a.highestBid IS NOT NULL " +
						"AND a.expiration < NOW()"; 

						//Arraylist to store the itemIds, sellerIds, and highestBids
						ArrayList <Integer> itemIds = new ArrayList <Integer>();
						ArrayList <Integer> sellerIds = new ArrayList <Integer>();
						ArrayList <Double> highestBids = new ArrayList <Double>();
						
						result = stmt.executeQuery(getAuctionTable2);
						
						// Iterate through ResultSet and add to table
						while (result.next()) {
							highestBid = result.getFloat(1);
							int itemId = result.getInt(2);
							sellerId = result.getInt(3);
							String itemName = result.getString(4);
							itemIds.add(itemId);
							sellerIds.add(sellerId);
							highestBids.add(highestBid);
						}

						// Get the specific type of clothing
						for (int i = 0; i < itemIds.size(); i++) {
							System.out.println("In for loop");
							result = stmt.executeQuery("SELECT COUNT(*) FROM Shirts WHERE itemId = " + itemIds.get(i));
							String clothesString;
							result.next();
							System.out.println("Check here");
							if (result.getInt(1) != 0){
								clothesString = "Shirts";
							}
							else {
								result = stmt.executeQuery("SELECT COUNT(*) FROM Pants WHERE itemId = " + itemIds.get(i));
								result.first();
							    if (result.getInt(1) != 0) {
							    	clothesString = "Pants";
							    }
							    else clothesString = "Shoes";
							}
							
							
							if(clothesString == "Shirts") {
								String typeShirts = "SELECT c.armLength, c.collarSize, c.waistSize FROM Shirts c, Auction a " +
										"WHERE c.itemId = a.itemId AND a.itemId = '" + itemIds.get(i) + "'";
								// Get Shirts info base on itemId
		 						result = stmt.executeQuery(typeShirts);
								if(result.next()) {
									totalShirt += highestBids.get(i);
									out.print("<tr>");
									out.print("<td>" + sellerIds.get(i) + "</td>");
									out.print("<td>" + currency.format(highestBids.get(i)) + "</td>");
									out.print("<td>" + "</td>");
									out.print("<td>" + "</td>");
									out.print("</tr>");
								} 
							} 
							else if(clothesString == "Pants") {
								String typePants = "SELECT p.width, p.length FROM Pants p, Auction a " +
										"WHERE p.itemId = a.itemId AND a.itemId = '" + itemIds.get(i) + "'";
								// Get Pants info
		 						result = stmt.executeQuery(typePants);
								if(result.next()) {
									totalPants += highestBids.get(i);
									out.print("<tr>");
									out.print("<td>" + sellerIds.get(i) + "</td>");
									out.print("<td>" + "</td>");
									out.print("<td>" + currency.format(highestBids.get(i)) + "</td>");
									out.print("<td>" + "</td>");
									out.print("</tr>");
								} 
							} else {
								String typeShoes = "SELECT s.size FROM Shoes s, Auction a " +
										"WHERE s.itemId = a.itemId AND a.itemId = '" + itemIds.get(i) + "'";
								// Get Shoes info
								result = stmt.executeQuery(typeShoes);
								if(result.next()) {
									totalShoes += highestBids.get(i);
									out.print("<tr>");
									out.print("<td>" + sellerIds.get(i) + "</td>");
									out.print("<td>" + "</td>");
									out.print("<td>" + "</td>");
									out.print("<td>" + currency.format(highestBids.get(i)) + "</td>");
									out.print("</tr>");
								} 
							}
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
					<td>TOTAL FOR EACH TYPE</td>
					<td>
						<!-- Total Earning Amount -->
						<%out.print(currency.format(totalShirt));%>
					</td>					
					<td>
						<!-- Total Earning Amount -->
						<%out.print(currency.format(totalPants));%>
					</td>
					<td>
						<!-- Total Earning Amount -->
						<%out.print(currency.format(totalShoes));%>
					</td>					
				</tr>				
			</tbody>			
		</table>
		<h4>Best selling item: </h4>
		<%
			if(totalShirt > totalPants && totalShirt > totalShoes) {
				out.print("<p> Shirts are the best selling with total earnings: " + currency.format(totalShirt) + "</p>");
			} else if (totalPants > totalShirt && totalPants > totalShoes) {
				out.print("<p> Pants are the best selling with total earnings: " + currency.format(totalPants) + "</p>");
			} else if (totalShoes > totalShirt && totalShoes > totalPants) {
				out.print("<p> Shoes are the best selling with total earnings: " + currency.format(totalShoes) + "</p>");
			} else if (totalShirt == totalPants && totalShirt > totalShoes) {
				out.print("<p> Shirts and Pants tie for best earning!</p>");
			} else if (totalShirt > totalPants && totalShirt == totalShoes) {
				out.print("<p> Shirts and Shoes tie for best earning!</p>");
			} else if (totalShoes == totalPants && totalShoes > totalShirt) {
				out.print("<p> Shoes and Pants tie for best earning!</p>");
			} else if (totalShoes == totalShirt && totalShoes == totalPants) {
				out.print("<p> All items are best earning!</p>");
			} 		
		%>
		
		<h4>Best Bidders/Buyers ID: </h4>
		<%
			String bidderName ="";
			int bidderID = 0;
			try {
				//Get the database connection
				ApplicationDB db = new ApplicationDB();
				con = db.getConnection();

				//Create a SQL statement
				Statement stmt = con.createStatement();
				ResultSet result;
				
				String getHighestBidderId = "SELECT u.name, b.bidderId FROM Bid b, User u WHERE b.bidderId = u.userId AND b.amount = (SELECT max(amount) FROM Bid)";
				result = stmt.executeQuery(getHighestBidderId);
				
				if(result.next()) {
					bidderName = result.getString(1);
					bidderID = result.getInt(2);
					out.print("<p> NAME: " + bidderName + "</p>");
					out.print("<p> ID: " + bidderID + "</p>");
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
			
	<br>
	<br>
	<form method="post" action="../admin_page.jsp">
		<input type="submit" value="Back to Admin page" />
	</form>
</body>
</html>