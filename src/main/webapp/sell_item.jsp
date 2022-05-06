<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page session="true" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>sell item</title>
</head>
<body>
	<%
		Connection con = null;
		try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();
			con = db.getConnection();

			//Create a SQL statement
			Statement stmt = con.createStatement();
			ResultSet result;
			
			/**** Get parameters from the HTML form at the sell_page.jsp ****/
			/* TABLE Clothes */
			String itemName = request.getParameter("itemName");
			String manufacturer = request.getParameter("manufacturer");	
			String color = request.getParameter("color");
			String condition = request.getParameter("condition");	
			
			/* TABLE Shirts/Pants/Shoes */
			String clothesType = request.getParameter("clothesType");	
				
			/* TABLE Auction */
			int quantity = Integer.parseInt(request.getParameter("quantity"));	
			String description = request.getParameter("description");	
			
			//Database accepts only java.sql.Date. So we need to convert java.util.Date into java.sql.Date.
 			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd'T'hh:mm");
 			java.util.Date endDate = format.parse(request.getParameter("expirDate"));
/* 			java.sql.Date sql_EndDate = new java.sql.Date( endDate.getTime() );  */
			java.sql.Timestamp sql_EndTime = new java.sql.Timestamp( endDate.getTime() ); 

	
			float initPrice = Float.parseFloat(request.getParameter("initPrice"));	
			float minPrice = Float.parseFloat(request.getParameter("minPrice"));	
			float increment = Float.parseFloat(request.getParameter("increment"));				

			
			
			/**** Stores item ID, auctionId, sellerId ****/
			/* Get item ID */
			int itemId;
			String GetLastItemId = "SELECT itemId FROM Clothes ORDER BY itemId DESC LIMIT 1";
			result = stmt.executeQuery(GetLastItemId);
			if(result.next()) {
				itemId = Integer.parseInt(result.getString("itemId")) + 1;
			} else {
				itemId = 1;
			}
			/* Get auctionId */
			int auctionId;
			String GetLastAuctId = "SELECT auctionId FROM Auction ORDER BY auctionId DESC LIMIT 1";
			result = stmt.executeQuery(GetLastAuctId);
			if(result.next()) {
				auctionId = Integer.parseInt(result.getString("auctionId")) + 1;
			} else {
				auctionId = 1;
			}
			/* Get sellerId (Current user) */
			Integer sellerId = (Integer) session.getAttribute("userId");
			
			

			// 1) Make an insert statement for the Clothes table:
			String insert = "INSERT INTO Clothes(name, manufacturer, color, `condition`, itemId)"
					+ "VALUES (?, ?, ?, ?, ?)";			
			//Create a Prepared SQL statement allowing you to introduce the parameters of the query
			PreparedStatement ps = con.prepareStatement(insert);		
			//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
			ps.setString(1, itemName);
			ps.setString(2, manufacturer);
			ps.setString(3, color);
			ps.setString(4, condition);
			ps.setInt(5, itemId);
			ps.executeUpdate();

			
			// 2) Insert data into appropriate table base on what clothesType is . . . 
			String insert1 = "INSERT INTO Shirts(armLength, collarSize, waistSize, itemId)"
					+ "VALUES (?, ?, ?, ?)";
			String insert2 = "INSERT INTO Pants(width, length, itemId)" + "VALUES (?, ?, ?)";
			String insert3 = "INSERT INTO Shoes(size, itemId)" + "VALUES (?, ?)";	
			
			System.out.print(clothesType + "\n");
			if(clothesType == "shirts") {
				PreparedStatement ps1 = con.prepareStatement(insert1);
				float armLength = Float.parseFloat(request.getParameter("armLength"));	
				float collarSize = Float.parseFloat(request.getParameter("collarSize"));	
				float waistSize = Float.parseFloat(request.getParameter("waistSize"));	
				ps1.setFloat(1, armLength);
				ps1.setFloat(2, collarSize);
				ps1.setFloat(3, waistSize);
				ps1.setInt(4, itemId);
				ps1.executeUpdate();
			} 
			if (clothesType == "pants") {
				PreparedStatement ps2 = con.prepareStatement(insert2);
				float pantsWidth = Float.parseFloat(request.getParameter("pantsWidth"));	
				float pantsLength = Float.parseFloat(request.getParameter("pantsLength"));	
				ps2.setFloat(1, pantsWidth);
				ps2.setFloat(2, pantsLength);
				ps2.setInt(3, itemId);
				ps2.executeUpdate();
			} 
			if (clothesType == "shoes") {
				PreparedStatement ps3 = con.prepareStatement(insert3);
				float shoeSize = Float.parseFloat(request.getParameter("shoeSize"));
				ps3.setFloat(1, shoeSize);
				ps3.setInt(2, itemId);
				ps3.executeUpdate();
			}
			
			// 3) Make an insert statement for the Auction table:
			insert = "INSERT INTO Auction(title, description, itemId, quantity, "
					+ "expiration, initialPrice, minPrice, increment, highestBid, auctionId, sellerId)"
					+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
			ps = con.prepareStatement(insert);
			ps.setString(1, itemName);
			ps.setString(2, description);
			ps.setInt(3, itemId);
			ps.setInt(4, quantity);
			ps.setTimestamp(5, sql_EndTime);
			ps.setFloat(6, initPrice);
			ps.setFloat(7, minPrice); 
 			ps.setFloat(8, increment); 
		 	ps.setNull(9, Types.NULL); 
			ps.setInt(10, auctionId);
 			ps.setInt(11, sellerId); 
 			
			ps.executeUpdate();

			
			//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
			con.close();

			out.print("Item added successful.");
			out.print("<form method=\"post\" action=\"auction_page.jsp\">\n\t\t\t<input type=\"submit\" value=\"Return to Auction page\" />\n\t\t</form>");
			

		} catch (Exception ex) {
			out.print(ex);
			ex.printStackTrace();
			out.print("<br>");
			out.print("Item added failed.");
			out.print("<form method=\"post\" action=\"sell_page.jsp\">\n\t\t\t<input type=\"submit\" value=\"Try Again\" />\n\t\t</form>");
		}			
			
			/*  
				Note: only regulars can use sell_item. NOT ADMIN (userId = 1)!
				https://stackoverflow.com/questions/45102667/localdatetime-to-java-sql-date-in-java-8 
				https://www.thecrazyprogrammer.com/2016/02/how-to-insert-date-and-time-in-mysql-using-java.html
			*/
	%>
</body>
</html>