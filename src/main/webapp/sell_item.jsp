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
			
			
			// Get parameters from the HTML form at the sell_page.jsp
			/* TABLE Clothes */
			String itemName = request.getParameter("itemName");
			String manufacturer = request.getParameter("manufacturer");	
			String color = request.getParameter("color");
			String condition = request.getParameter("condition");	
			/* TABLE Shirts/Pants/Shoes */
			String clothesType = request.getParameter("clothesType");	
			float armLength = Float.parseFloat(request.getParameter("armLength"));	
			float collarSize = Float.parseFloat(request.getParameter("collarSize"));	
			float waistSize = Float.parseFloat(request.getParameter("waistSize"));	
			float pantsWidth = Float.parseFloat(request.getParameter("pantsWidth"));	
			float pantsLength = Float.parseFloat(request.getParameter("pantsLength"));	
			float shoeSize = Float.parseFloat(request.getParameter("shoeSize"));
			/* TABLE Auction */
			int quantity = Integer.parseInt(request.getParameter("quantity"));	
			String description = request.getParameter("description");	
			//Database accepts only java.sql.Date. So we need to convert java.util.Date into java.sql.Date.
			SimpleDateFormat expirDate = new SimpleDateFormat("MM/dd/yyyy");
			java.util.Date util_StartDate = expirDate.parse(request.getParameter("expirDate") );
			java.sql.Date sql_StartDate = new java.sql.Date( util_StartDate.getTime() );
		/* 	Date expirTime = request.getParameter("expirTime");	 */
			float initPrice = Float.parseFloat(request.getParameter("initPrice"));	
			float miniPrice = Float.parseFloat(request.getParameter("miniPrice"));	
			float increment = Float.parseFloat(request.getParameter("increment"));
			
			
			// Stores item ID, auctionId, sellerId
			/* Get item ID */
			int itemId;
			String GetLastItemId = "SELECT itemId FROM Clothes ORDER BY userId DESC LIMIT 1";
			result = stmt.executeQuery(GetLastItemId);
			if(result.next()) {
				itemId = Integer.parseInt(result.getString("itemId")) + 1;
			} else {
				itemId = 1;
			}
			/* Get auctionId */
			int auctionId;
			String GetLastAuctId = "SELECT itemId FROM Auction ORDER BY auctionId DESC LIMIT 1";
			result = stmt.executeQuery(GetLastAuctId);
			if(result.next()) {
				auctionId = Integer.parseInt(result.getString("auctionId")) + 1;
			} else {
				auctionId = 1;
			}
			/* Get sellerId (Current user) */
			Integer sellerId = (Integer) session.getAttribute("userId");
			
			
			
			// 1) Make an insert statement for the Clothes table:
			String insert = "INSERT INTO Clothes(name, manufacturer, color, condition, itemId)"
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
			
			if(clothesType == "shirts") {
				ps.setFloat(1, armLength);
				ps.setFloat(2, collarSize);
				ps.setFloat(3, waistSize);
				ps.setInt(4, itemId);
				ps.executeUpdate(insert1);
			} else if (clothesType == "pants") {
				ps.setFloat(1, width);
				ps.setFloat(2, length);
				ps.setInt(3, itemId);
				ps.executeUpdate(insert2);
			} else {
				ps.setFloat(1, shoeSize);
				ps.setInt(2, itemId);
				ps.executeUpdate(insert3);
			}
			
			// 3) Make an insert statement for the Auction table:
			insert = "INSERT INTO Auction(title, description, itemId, "
					+ "quantity, expiration, initialPrice, minPrice, increment, highestBid, auctionId, sellerId)"
					+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
			ps.setString(1, itemName);
			ps.setString(2, description);
			ps.setInt(3, itemId);
			ps.setInt(4, quantity);
			ps.setDate(5, sql_StartDate);
			ps.setFloat(6, initPrice);
			ps.setFloat(7, miniPrice);
			ps.setFloat(8, increment);
		/* 	ps.setFloat(9, highestBid); */
			ps.setInt(10, auctionId);
			ps.setInt(11, sellerId);
			ps.executeUpdate(insert);
			
			//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
			con.close();

			out.print("Item added successful.");
			

		} catch (Exception ex) {
			out.print(ex);
			out.print("<br>");
			out.print("Item added failed.");
		}			
			
			
	%>
</body>
</html>