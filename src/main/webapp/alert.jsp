<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="UTF-8">
<title>alert page</title>
</head>
<body>
	<!-- find similar info based on alert_page, insert into Alert{itemId, userId} -->
	<%
		Connection con = null;
		try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();
			con = db.getConnection();

			//Create a SQL statement
			Statement stmt = con.createStatement();
			ResultSet result;
			
			/**** Get parameters from the HTML form at the alert_page.jsp ****/
			/* Clothes TYPE */
			String clothesType = request.getParameter("clothesType");
			
			/* Clothes Detail */
			String color = request.getParameter("color");
			String manufacturer = request.getParameter("manufacturer");
			String keywords = request.getParameter("keywords");	
			keywords.toLowerCase();
			
			/* Amount Limits */
			float max = Float.parseFloat(request.getParameter("max"));	
			
			/* Specific Clothes Type */
			float armLength = 0, collarSize = 0, waistSize = 0;
			float pantsWidth = 0, pantsLength = 0;
			float shoeSize = 0;
			String specificClothes = "";
			if(clothesType.equals("shirts")) {
				armLength = Float.parseFloat(request.getParameter("armLength"));	
				collarSize = Float.parseFloat(request.getParameter("collarSize"));	
				waistSize = Float.parseFloat(request.getParameter("waistSize"));
				specificClothes += "SELECT itemId FROM Shirts WHERE armLength = '" + armLength + 
						"'and collarSize = '" + collarSize + "'and waistSize = " + waistSize;
			} 
			if (clothesType.equals("pants")) {
				pantsWidth = Float.parseFloat(request.getParameter("pantsWidth"));	
				pantsLength = Float.parseFloat(request.getParameter("pantsLength"));
				specificClothes += "SELECT itemId FROM Pants WHERE width = '" + pantsWidth + 
						"'and length = " + pantsLength;
			} 
			if (clothesType.equals("shoes")) {
				shoeSize = Float.parseFloat(request.getParameter("shoeSize"));
				specificClothes += "SELECT itemId FROM Shoes WHERE size = " + shoeSize;
			}
			
			
			/***** Get current userId *****/
			Integer userId = (Integer) session.getAttribute("userId");
			
			/***** Get itemIds base on parameters of alert *****/
 			String getIdClothes = "SELECT itemId FROM Clothes WHERE color = '" + color + 
			"' and manufacturer IS NOT NULL and manufacturer = '" + manufacturer + 
			"' UNION SELECT itemId from Clothes WHERE color = '" + color + "'"; 
			
			String getIdAuction = "SELECT itemId, description FROM Auction WHERE initialPrice <= '" + max + 
					"' and highestBid IS NOT NULL and highestBid <= '" + max + "' and description IS NOT NULL " +
					"UNION SELECT itemId, description FROM Auction WHERE description IS NOT NULL";

			//Store the resultSet data into arrayList(itemId) to be used for executeUpdate
			ArrayList<Integer> temp = new ArrayList<Integer>();	
			//ID from Clothes
			result = stmt.executeQuery(getIdClothes);
			while(result.next()) {
				temp.add(result.getInt("itemId"));
			}

			//ID from Auction (See if keywords is in description)
			result = stmt.executeQuery(getIdAuction);
			while(result.next()) {
				String descript1 = result.getString("description");
				//case insensitive
				descript1 = descript1.toLowerCase();
				if(descript1.contains(keywords)) {
					temp.add(result.getInt("itemId"));
				}
			}

			//ID from isA relationship of Clothes
			result = stmt.executeQuery(specificClothes);
			while(result.next()) {
				temp.add(result.getInt("itemId"));
			}
			
			//remove duplicates from arrayList
			Set<Integer> itemIdList = new LinkedHashSet<Integer>(temp);  
			System.out.println(itemIdList);
			
			/***** Update alert *****/
			//Create a Prepared SQL statement allowing you to introduce the parameters of the query
			String insert = "INSERT INTO Alert(userId, itemId)"
					+ "VALUES (?, ?)";
			PreparedStatement ps = con.prepareStatement(insert);	
			for(int itemIds : itemIdList) {
				ps.setInt(1, userId);
				ps.setInt(2, itemIds);
				ps.executeUpdate();
			}
			
			//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
			con.close();

			out.print("Alert created successful.");
			out.print("<br>");
			out.print("<br>");
			out.print("<form method=\"post\" action=\"alert_page.jsp\">\n\t\t\t<input type=\"submit\" value=\"Return to Alert page\" />\n\t\t</form>");
			
		} catch (Exception ex) {
			out.print(ex);
			ex.printStackTrace();
			out.print("<br>");
			out.print("<br>");
			out.print("Alert creation failed.");
			out.print("<form method=\"post\" action=\"alert_page.jsp\">\n\t\t\t<input type=\"submit\" value=\"Try Again\" />\n\t\t</form>");
		}	
			
	%>
	<!-- save the itemId and userId for alert -->
</body>
</html>