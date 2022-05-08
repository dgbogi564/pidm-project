<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page session="true" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="UTF-8">
<title>bid page</title>
</head>
	<body>
		<h1>Place your Bids!</h1>
		
		<!-- Get the hidden value of "dataStored" from auction_page.jsp -->
 		<%
	    	if (request.getParameter("dataStored") != null) {
		    	int auctItemID = Integer.parseInt(request.getParameter("dataStored"));
				session.removeAttribute("auctItemID");
				session.setAttribute("auctItemID", auctItemID); 
				System.out.println("WAIT");
				System.out.println(auctItemID);
	    	}
		%>
		<table>
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
					String getAuctionInfo = "SELECT title, description, quantity, expiration, " +
					"initialPrice, increment, highestBid, auctionId, sellerId FROM Auction WHERE itemId = '" + auctItemID + "'";
					result = stmt.executeQuery(getAuctionInfo);
					System.out.println("inside");
					System.out.println(auctItemID);
					if (result.next()){
						System.out.print("what");
						String title = result.getString(1);
						String description = result.getString(2);
						int quantity = result.getInt(3);
						Timestamp expiration =  result.getTimestamp(4);
						int initialPrice = result.getInt(5);
						double increment = result.getFloat(6);
						double highestBid = result.getFloat(7);
						int auctionId = result.getInt(8);
						int sellerId = result.getInt(9);
						
						out.println("<tr class='data'>");
						out.println("<td>" + title + "</td>"); 
						out.println("<td>" + description + "</td>");
						out.println("<td>" + quantity + "</td>");
						out.println("<td>" + initialPrice + "</td>");
						out.println("<td>" + highestBid + "</td>");
						out.println("<td>" + (highestBid == 0 ? "None" : highestBid) + "</td>");
						out.println("<td>" + "</td>"); // IMPLEMENT SEE INFO HERE
						out.println("</tr>");
					}
					
					/***** Get specific info base on ItemId from Clothes *****/
					
					
					
					
					
					
					//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
					con.close();
	
					out.print("Bid added successful.");
					out.print("<br>");
					out.print("<br>");
					out.print("<form method=\"post\" action=\"auction_page.jsp\">\n\t\t\t<input type=\"submit\" value=\"Return to Auction page\" />\n\t\t</form>");
					
	
				} catch (Exception ex) {
					out.print(ex);
					ex.printStackTrace();
					out.print("<br>");
					out.print("<br>");
					out.print("Bid failed to load.");
					out.print("<form method=\"post\" action=\"sell_page.jsp\">\n\t\t\t<input type=\"submit\" value=\"Try Again\" />\n\t\t</form>");
				}					
			%>
		</table>
	</body>
</html>