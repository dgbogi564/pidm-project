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
	<!-- Filter specific info base on search_page parameters -->
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
			
			
			/***** Get itemIds base on parameters of search *****/
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
			
			//RETURN set(itemIdList) as a session for search_page to populate table
			/* session.setAttribute("itemIdList", itemIdList); */
			session.setAttribute("itemIdList", temp);
			
			//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
			con.close();

			out.print("Filter/Search successful.");
			out.print("<br>");
			out.print("<br>");
			out.print("<form method=\"post\" action=\"search_page.jsp\">\n\t\t\t<input type=\"submit\" value=\"Return to Search page\" />\n\t\t</form>");
			
		} catch (Exception ex) {
			out.print(ex);
			ex.printStackTrace();
			out.print("<br>");
			out.print("<br>");
			out.print("Filter/Search failed.");
			out.print("<form method=\"post\" action=\"search_page.jsp\">\n\t\t\t<input type=\"submit\" value=\"Try Again\" />\n\t\t</form>");
		}	
			
	%>
	<!-- save the itemId and userId for alert -->
</body>
</html>