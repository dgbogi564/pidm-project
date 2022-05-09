<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.text.*, java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page session="true" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="UTF-8">
	<title>wishlist / alert page</title>
	<style>
		table, th, td {
			border: 1px solid black;
			border-collapse: collapse;
		}
		td {
			text-align: center;
		}
		table {
			width: 100%;
		}
		.data:hover {
			cursor: pointer;
			background-color: #58C9FF;
		}
	</style>
	<script>
		function showClothesOptions() {
			let x = document.getElementById("clothesType").value;
			document.getElementById("shirtsOptions").style.display = 'none';
			document.getElementById("pantsOptions").style.display = 'none';
			document.getElementById("shoesOptions").style.display = 'none';
			if (x == "shirts") {
				document.getElementById("shirtsOptions").style.display = 'block';
			} else if (x == "pants") {
				document.getElementById("pantsOptions").style.display = 'block';
			} else if (x == "shoes") {
				document.getElementById("shoesOptions").style.display = 'block';
			}
		}
	</script>
</head>
<body>
<%
	Connection con = null;

	int userId = (Integer) session.getAttribute("userId");
%>
<h1>Alerts</h1>
<form method="post" action="profile_page.jsp">
	<input type="submit" value="Return to Profile Page">
</form>
<h2>Bid Alerts</h2>
<p>This table shows any auctions you've participated in where another user has submitted a higher bid than you have.</p>
<table>
	<tr>
		<th>Auction ID</th>
		<th>Title</th>
		<th>Seller</th>
		<th>Your Bid</th>
		<th>Current Bid</th>
		<th colspan=2>Expiration</th>
	</tr>
	<%
		try {
			// Get the database connection
			ApplicationDB db = new ApplicationDB();
			con = db.getConnection();

			// Create a SQL statement
			Statement stmt = con.createStatement();
			ResultSet result;

			// Get highest bids for each auction
			String query = "SELECT b.auctionId, b.amount FROM Auction a, Bid b WHERE " +
					"a.auctionId = b.auctionId AND b.bidderId = " + userId + " AND a.expiration" +
					" > NOW() ORDER BY b.amount DESC LIMIT 1";
			result = stmt.executeQuery(query);

			Statement compareStmt = con.createStatement();
			ResultSet compareResult;

			// For table
			NumberFormat currency = NumberFormat.getCurrencyInstance();
			SimpleDateFormat date = new SimpleDateFormat("MMM d, yyyy HH:mm");
			long now = (new java.util.Date()).getTime();

			while (result.next()) {
				int auctionId = result.getInt(1);
				float highestBid = result.getFloat(2);

				compareResult = compareStmt.executeQuery("SELECT a.highestBid, a.title, a.sellerId, u.name, a.expiration FROM Auction a, User u WHERE a.auctionId = " + auctionId);
				compareResult.next();
				float currentBid = compareResult.getFloat(1);

				if (highestBid < currentBid) {
					String title = compareResult.getString(2);
					int sellerId = compareResult.getInt(3);
					String name = compareResult.getString(4);
					long expiration = compareResult.getTimestamp(5).getTime();
					long diffHours = expiration - (new java.util.Date()).getTime();
					if (diffHours < 0) continue;
					diffHours = (diffHours - (diffHours % 3600000)) / 3600000;
					long diffDays = diffHours / 24;
					diffHours = diffHours % 24;

					out.print("<tr>");
					out.print("<td>" + auctionId + "</td>");
					out.print("<td><a href=\"item_page.jsp?auctionId=" + auctionId + "\">" + title + "</a></td>");
					out.print("<td><a href=\"user_info.jsp?userId=" + sellerId + "\">" + name + "</a></td>");
					out.print("<td>" + currency.format(highestBid) + "</td>");
					out.print("<td>" + currency.format(currentBid) + "</td>");
					out.print("<td>" + ((expiration - now) < 0 ? "Closed" : (diffDays + "d " + diffHours + "h")) + "</td>");
					out.print("<td>" + date.format(expiration) + "</td>");
					out.print("</tr>");
				}
			}
		} catch (Exception ex) {
			out.print(ex);
			ex.printStackTrace();
			out.print("<br>");
			out.print("<br>");
			out.print("Failed to display auctions.");
		}
	%>
</table>
<h2>Auction Alerts</h2>
<h3>Add Alert</h3>
<form method="get" action="alert.jsp">
	<table style="border:none;width:auto">
		<tr>
			<td style="border:none;text-align:left">Keywords/Phrases in Title (separate entries with commas):</td>
			<td style="border:none;text-align:left"><input type="text" name="titleKeywords"></td>
		</tr>
		<tr>
			<td style="border:none;text-align:left">Keywords/Phrases in Description (separate entries with commas):</td>
			<td style="border:none;text-align:left"><input type="text" name="descriptionKeywords"></td>
		</tr>
		<tr>
			<td style="border:none;text-align:left">Color:</td>
			<td style="border:none;text-align:left"><input type="text" name="color"></td>
		</tr>
		<tr>
			<td style="border:none;text-align:left">Manufacturer:</td>
			<td style="border:none;text-align:left"><input type="text" name="manufacturer"></td>
		</tr>
		<tr>
			<td style="border:none;text-align:left">Minimum Price:</td>
			<td style="border:none;text-align:left"><input type="number" name="minBid" min="0" step="0.01"></td>
		</tr>
		<tr>
			<td style="border:none;text-align:left">Maximum Price:</td>
			<td style="border:none;text-align:left"><input type="number" name="maxBid" min="0" step="0.01"></td>
		</tr>
		<tr>
			<td style="border:none;text-align:left">Clothes Type:</td>
			<td style="border:none;text-align:left"><select name="clothesType">
				<option value="all" selected>Show all clothes types</option>
				<option value="Shirts">Show shirts only</option>
				<option value="Pants">Show pants only</option>
				<option value="Shoes">Show shoes only</option>
			</select></td>
		</tr>
	</table>
	<br>
	<input type="submit" value="Add New Alert">
</form>
<h3>Alert List</h3>
<p>This table shows your alerts as well as any active auctions that fulfill any of your alert criteria.</p>
<table>
	<tr>
		<th>Title Keywords/Phrases</th>
		<th>Description Keywords/Phrases</th>
		<th>Color</th>
		<th>Manufacturer</th>
		<th>Minimum Price</th>
		<th>Maximum Price</th>
		<th>Clothes Type</th>
		<th colspan="2">Auctions (ID and Title)</th>
	</tr>
	<%
		try {
			// Get the database connection
			ApplicationDB db = new ApplicationDB();
			con = db.getConnection();

			NumberFormat currency = NumberFormat.getCurrencyInstance();

			// Create a SQL statement
			Statement stmt = con.createStatement();
			ResultSet result;
			result = stmt.executeQuery("SELECT titleKeywords, descriptionkeywords, color, manufacturer, minBid," +
					" maxBid, clothesType FROM Alert WHERE userId = " + userId);
			while (result.next()) {
				// Create SQL query
				String querySF = "SELECT DISTINCT a.auctionId, a.title FROM" +
						" Auction a, User u, Clothes c";
				String queryW = " WHERE a.sellerId = u.userId AND c.itemId = a.itemId AND a.expiration > NOW()";

				String titleKeywordsString = result.getString(1);
				String descriptionKeywordsString = result.getString(2);
				String color = result.getString(3);
				String manufacturer = result.getString(4);
				String clothesType = result.getString(7);
				float minBid, maxBid;

				if (titleKeywordsString != null && !titleKeywordsString.equals("")) {
					String titleKeywords[] = titleKeywordsString.split(",");
					for (int i = 0; i < titleKeywords.length; i++) {
						queryW += " AND UPPER(a.title) LIKE UPPER('%" + titleKeywords[i].trim() + "%')";
					}
				}
				if (descriptionKeywordsString != null && !descriptionKeywordsString.equals("")) {
					String descriptionKeywords[] = descriptionKeywordsString.split(",");
					for (int i = 0; i < descriptionKeywords.length; i++) {
						queryW += " AND UPPER(a.description) LIKE UPPER('%" + descriptionKeywords[i].trim() + "%')";
					}
				}
				if (color != null && !color.equals("")) {
					queryW += " AND UPPER(c.color) = UPPER('" + color + "')";
				}
				if (manufacturer != null && !manufacturer.equals("")) {
					queryW += " AND UPPER(c.manufacturer) = UPPER('" + manufacturer + "')";
				}
				if (clothesType != null && !clothesType.equals("")) {
					if (clothesType.equals("Shirts")) {
						querySF += ", Shirts";
						queryW += " AND a.itemId IN (SELECT itemId FROM Shirts)";
					} else if (clothesType.equals("Pants")) {
						querySF += ", Pants";
						queryW += " AND a.itemId IN (SELECT itemId FROM Pants)";
					} else if (clothesType.equals("Shoes")) {
						querySF += ", Shoes";
						queryW += " AND a.itemId IN (SELECT itemId FROM Shoes)";
					}
				}
				minBid = result.getFloat(5);
				if (!result.wasNull() && minBid != 0) {
					queryW += " AND a.highestBid >= " + minBid;
				}
				maxBid = result.getFloat(6);
				if (!result.wasNull() && maxBid != 0) {
					queryW += " AND a.highestBid <= " + maxBid;
				}

				out.print("<tr>");
				out.print("<td style=>" + titleKeywordsString + "</td>");
				out.print("<td>" + descriptionKeywordsString + "</td>");
				out.print("<td>" + color + "</td>");
				out.print("<td>" + manufacturer + "</td>");
				out.print("<td>" + (minBid == 0 ? "" : currency.format(minBid)) + "</td>");
				out.print("<td>" + (maxBid == 0 ? "" : currency.format(maxBid)) + "</td>");
				out.print("<td>" + clothesType + "</td>");

				Statement findAuctionsStmt = con.createStatement();
				ResultSet findAuctions = findAuctionsStmt.executeQuery(querySF + queryW);

				boolean used = false;
				while (findAuctions.next()) {
					int auctionId = findAuctions.getInt(1);
					String auctionTitle = findAuctions.getString(2);
					if (!used) {
						out.print("<td>" + auctionId + "</td>");
						out.print("<td><a href=\"item_page.jsp?auctionId=" + auctionId + "\">" + auctionTitle + "</a></td>");
						used = true;
					} else {
						out.print("<td colspan=7></td>");
						out.print("<td>" + auctionId + "</td>");
						out.print("<td><a href=\"item_page.jsp?auctionId=" + auctionId + "\">" + auctionTitle + "</a></td>");
					}
					out.print("</tr>");
				}
				if (!used) out.print("<td></td><td></td>");
				out.print("</tr>");
			}
		} catch (Exception ex) {
			out.print(ex);
			ex.printStackTrace();
			out.print("<br>");
			out.print("<br>");
			out.print("Failed to display auctions.");
		}
	%>
</table>
</body>
</html>
