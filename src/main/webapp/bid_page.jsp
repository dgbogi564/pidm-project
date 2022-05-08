<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.text.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page session="true" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="UTF-8">
	<title>bid page</title>
	<style>
		#descript {
			border: 1px solid black;
			width: fit-content;
			padding: 20px;
			margin: 10px;
		}
		#container {
			padding: 10px;
			margin: 10px;
		}
	</style>
</head>
	<body>
		<h1>Place your Bids!</h1>
		<hr>
		
		<!-- Get the hidden value of "dataStored" from auction_page.jsp -->
 		<%
	    	if (request.getParameter("dataStored") != null) {
		    	int auctItemID = Integer.parseInt(request.getParameter("dataStored"));
				session.removeAttribute("auctItemID");
				session.setAttribute("auctItemID", auctItemID); 
	    	}
		%>
		
		<%
			Connection con = null;
			try {
				//Get the database connection
				ApplicationDB db = new ApplicationDB();
				con = db.getConnection();

				//Create a SQL statement
				Statement stmt = con.createStatement();
				ResultSet result;
				
				//ItemId also identical to AuctionId 
				Integer auctItemID = (Integer) session.getAttribute("auctItemID");
				
				/***** Get specific info base on ItemId from Auction *****/
				String getAuctionInfo = "SELECT a.title, a.description, a.quantity, a.expiration, " +
				"a.initialPrice, a.increment, a.highestBid, a.auctionId, a.sellerId, " +
				"c.manufacturer, c.color, c.condition FROM Auction a, Clothes c WHERE a.itemId = c.itemId AND a.itemId = '" + auctItemID + "'";
				result = stmt.executeQuery(getAuctionInfo);

				
				if (result.next()){
					String title = result.getString(1);
					String description = result.getString(2);
					int quantity = result.getInt(3);
					Timestamp expiration =  result.getTimestamp(4);
					int initialPrice = result.getInt(5);
					double increment = result.getFloat(6);
					double highestBid = result.getFloat(7);
					int auctionId = result.getInt(8);
					int sellerId = result.getInt(9);
					String manufacturer = result.getString(10);
					String color = result.getString(11);
					String condition = result.getString(12);
					
					out.println("<h2>" + title + "</h2>"); 
					out.println("<fieldset id='descript'>");
					out.println("<legend> description </legend>");
					out.println(description);
					out.println("</fieldset>");
					
					out.println("<div id ='container'>");
					out.println("<div> Quantity: " + quantity + "</div>");
					out.println("<br>");
					out.println("<div> Initial Price: $" + initialPrice + "(USD)</div>");
					out.println("<br>");
					out.println("<div> Manufacturer: " + manufacturer + "</div>");
					out.println("<br>");
					out.println("<div> Color: " + color + "</div>");
					out.println("</div>");
					
					
					out.println();			
					out.println();
					
					out.println("<ul>");
					out.println("</ul>");
					out.println("<div>" + (highestBid == 0 ? "None" : highestBid) + "</td>");

				}

				
				/***** Get specific info base on ItemId from Clothes *****/

				//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
				con.close();

			} catch (Exception ex) {
				out.print(ex);
				ex.printStackTrace();
				out.print("<br>");
				out.print("<br>");
				out.print("Bid failed to load.");
				out.print("<form method=\"post\" action=\"bid_page.jsp\">\n\t\t\t<input type=\"submit\" value=\"Try Again\" />\n\t\t</form>");
			}					
		%>
		<br>
		<br>
		<form method="post" action="auction_page.jsp">
			<input type="submit" value="Back to Auction" />
		</form>
		
	</body>
</html>