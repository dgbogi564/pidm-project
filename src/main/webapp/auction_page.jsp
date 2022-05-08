<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page session="true" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>auction page</title>
	<style>
		table, th, td {
			border: 1px solid black;
			border-collapse: collapse;
		}
		table {
			width: 100%;
		}
		.data:hover {
			cursor: pointer;
			background-color: #58C9FF;
		}
	</style>	
	</head>
	<body>
		<%
			String name = (String) session.getAttribute("name"); 
			out.print("<h1>Welcome " + name + ", to the Auction Site.</h1>");
		%>
		
		<form method="post" action="sell_page.jsp">
			<h2>Auction an item</h2>
			<input type="submit" value="Add item">
		</form>
		<br> 
		<hr>
		<form method="post" action="search_page.jsp">
			<h2>Search for item</h2>
			<input type="submit" value="Filter">
		</form>
		<br>
		<hr>
		<form method="post" action="profile_page.jsp">
			<h2>Profile Page</h2>
			<input type="submit" value="Go back" />
		</form>
		<br>		
		<hr>
		
		<fieldset>
			<legend>Auctions</legend>
			<table>
				<tr>
					<th>Title</th>
					<th>Item ID</th>
					<th>Color</th>
					<th>Condition</th>
					<th>Manufacturer</th>
					<th>Highest Bid</th>
					
					<!-- Should take us to the individual auction page
					 where we can see more info & place bid -->
					<th>See Info Here!</th>
				</tr>
				<%
					Connection con = null;
					try {
						//Get the database connection
						ApplicationDB db = new ApplicationDB();
						con = db.getConnection();

						//Create a SQL statement
						Statement stmt = con.createStatement();
						ResultSet result;

						String getAuctionTable = "SELECT a.title, a.itemId, c.color, c.condition, c.manufacturer, a.highestBid FROM Auction a, Clothes c WHERE a.itemId = c.itemId";
						result = stmt.executeQuery(getAuctionTable);

						// Iterate through ResultSet and add to table
						while (result.next()) {
							String title = result.getString(1);
							int id = result.getInt(2);
							String color = result.getString(3);
							String condition = result.getString(4);
							String manufacturer = result.getString(5);
							double highestBid = result.getFloat(6);

							out.print("<tr class='data' onclick=\"location.href='bid_page.jsp'\">");
							out.print("<td>" + title + "</td>"); // could just make this an html link
							out.print("<td>" + id + "</td>");
							out.print("<td>" + color + "</td>");
							out.print("<td>" + condition + "</td>");
							out.print("<td>" + manufacturer + "</td>");
							out.print("<td>" + (highestBid == 0 ? "None" : highestBid) + "</td>");
							out.print("<td>" + "</td>"); // IMPLEMENT SEE INFO HERE
							out.print("</tr>");
						}
					} catch (Exception ex) {
						out.print(ex);
						ex.printStackTrace();
						out.print("<br>");
						out.print("<br>");
						out.print("Failed to display auctions.");
						out.print("<form method=\"post\" action=\"profile_page.jsp\">\n\t\t\t<input type=\"submit\" value=\"Go back to profile page\" />\n\t\t</form>");
					}
				%>
			</table>
		</fieldset>
						
	</body>
</html>