<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="UTF-8">
<title>Delete Account</title>
</head>
<body>
	<%
		try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();

			//Create a SQL statement
			Statement stmt = con.createStatement();

			//Get attribute userId from session that we set in login.jsp
			Integer userId = (Integer) session.getAttribute("userId");
				
			
			//Delete Clothes & its "isA relations" base on Auction itemId
			String getItemId = "SELECT itemId FROM Auction WHERE sellerId = " + userId;
			ResultSet result = stmt.executeQuery(getItemId);
			
			//Store the resultSet data into array(itemId) to be used for executeUpdate
			ArrayList<Integer> itemIdList = new ArrayList<Integer>();
			while (result.next()) {
				itemIdList.add(result.getInt("itemId"));
			}
			for(int i = 0; i < itemIdList.size(); i++) {
				String getItemInfo = "DELETE FROM Shirts WHERE itemId = " + itemIdList.get(i);
				stmt.executeUpdate(getItemInfo);
				getItemInfo = "DELETE FROM Pants WHERE itemId = " + itemIdList.get(i);
				stmt.executeUpdate(getItemInfo);
				getItemInfo = "DELETE FROM Shoes WHERE itemId = " + itemIdList.get(i);
				stmt.executeUpdate(getItemInfo);
				getItemInfo = "DELETE FROM Clothes WHERE itemId = " + itemIdList.get(i);
				stmt.executeUpdate(getItemInfo);
			}

			
			//Get userId & execute query (Auction Info)
			String getUserInfo = "DELETE FROM Auction WHERE sellerId = '" + userId + "'";
			stmt.executeUpdate(getUserInfo);

			//Get userId & execute query (Regular)
			getUserInfo = "DELETE FROM Regular WHERE userId = '" + userId + "'";
			stmt.executeUpdate(getUserInfo);
			
			//Get userId & execute query (User)
			getUserInfo = "DELETE FROM User WHERE userId = '" + userId + "'";
			stmt.executeUpdate(getUserInfo);
 

			//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
			con.close();

			out.print("Delete successful.");
			
			out.print("<br>");
			out.print("<br>");
			out.print("<form method=\"post\" action=\"login_page.jsp\">\n\t\t\t<input type=\"submit\" value=\"Return to login page\" />\n\t\t</form>");
			

		} catch (Exception ex) {
			out.print(ex);
			out.print("<br>");
			out.print("Delete failed.");
			out.print("<br>");
			out.print("<br>");
			out.print("<form method=\"post\" action=\"profile_page.jsp\">\n\t\t\t<input type=\"submit\" value=\"Return to profile page\" />\n\t\t</form>");
		}
	
	%>
</body>
</html>