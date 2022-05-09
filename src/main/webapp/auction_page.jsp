<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.text.*,java.util.*,java.sql.*"%>
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
	<body onload="showClothesOptions()">
		<h1>Auctions</h1>

		<form method="post" action="profile_page.jsp">
			<h2>Profile Page</h2>
			<input type="submit" value="Return to Profile Page">
		</form>

		<form method="post" action="sell_page.jsp">
			<h2>Add an Item</h2>
			<input type="submit" value="Auction an Item">
		</form>

		<br>
		<hr>

		<form method="get" action="auction_page.jsp">
			<%
				// Formatting
				SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd'T'hh:mm");

				// Get filter values
				String auctionStatus = request.getParameter("auctionStatus");
				String titleKeywordsString = request.getParameter("titleKeywords");
				String titleKeywords[] = {};
				if (titleKeywordsString != null && titleKeywordsString != "") {
					titleKeywords = titleKeywordsString.split(",");
					for (int i = 0; i < titleKeywords.length; i++) {
						titleKeywords[i] = titleKeywords[i].trim();
					}
				}
				String sellerName = request.getParameter("sellerName");
				String descriptionKeywordsString = request.getParameter("descriptionKeywords");
				String descriptionKeywords[] = {};
				if (descriptionKeywordsString != null && descriptionKeywordsString != "") {
					descriptionKeywords = descriptionKeywordsString.split(",");
					for (int i = 0; i < descriptionKeywords.length; i++) {
						descriptionKeywords[i] = descriptionKeywords[i].trim();
					}
				}
				float minPrice = 0, maxPrice = 0;
				if (request.getParameter("minPrice") != null && request.getParameter("minPrice") != "") minPrice = Float.parseFloat(request.getParameter("minPrice"));
				if (request.getParameter("maxPrice") != null && request.getParameter("maxPrice") != "") maxPrice = Float.parseFloat(request.getParameter("maxPrice"));
				long minTime = 0, maxTime = 0;
				if (request.getParameter("minTime") != null && request.getParameter("minTime") != "") minTime =  date.parse(request.getParameter("minTime")).getTime();
				if (request.getParameter("maxTime") != null && request.getParameter("maxTime") != "") maxTime = date.parse(request.getParameter("maxTime")).getTime();
				String clothesType = request.getParameter("clothesType");
				float minArm = 0, maxArm = 0, minCollar = 0, maxCollar = 0, minWaist = 0, maxWaist = 0, minWidth = 0, maxWidth = 0, minLength = 0, maxLength = 0, minSize = 0, maxSize = 0;
				if (clothesType != null && clothesType.equals("shirts")) {
					if (request.getParameter("minArm") != null && request.getParameter("minArm") != "") minArm = Float.parseFloat(request.getParameter("minArm"));
					if (request.getParameter("maxArm") != null && request.getParameter("maxArm") != "") maxArm = Float.parseFloat(request.getParameter("maxArm"));
					if (request.getParameter("minCollar") != null && request.getParameter("minCollar") != "") minCollar = Float.parseFloat(request.getParameter("minCollar"));
					if (request.getParameter("maxCollar") != null && request.getParameter("maxCollar") != "") maxCollar = Float.parseFloat(request.getParameter("maxCollar"));
					if (request.getParameter("minWaist") != null && request.getParameter("minWaist") != "") minWaist = Float.parseFloat(request.getParameter("minWaist"));
					if (request.getParameter("maxWaist") != null && request.getParameter("maxWaist") != "") maxWaist = Float.parseFloat(request.getParameter("maxWaist"));
				} else if (clothesType != null && clothesType.equals("pants")) {
					if (request.getParameter("minWidth") != null && request.getParameter("minWidth") != "") minWidth = Float.parseFloat(request.getParameter("minWidth"));
					if (request.getParameter("maxWidth") != null && request.getParameter("maxWidth") != "") maxWidth = Float.parseFloat(request.getParameter("maxWidth"));
					if (request.getParameter("minLength") != null && request.getParameter("minLength") != "") minLength = Float.parseFloat(request.getParameter("minLength"));
					if (request.getParameter("maxLength") != null && request.getParameter("maxLength") != "") maxLength = Float.parseFloat(request.getParameter("maxLength"));
				} else if (clothesType != null && clothesType.equals("shoes")) {
					if (request.getParameter("minSize") != null && request.getParameter("minSize") != "") minSize = Float.parseFloat(request.getParameter("minSize"));
					if (request.getParameter("maxSize") != null && request.getParameter("maxSize") != "") maxSize = Float.parseFloat(request.getParameter("maxSize"));
				}

				// Get sort values
				String sortType = request.getParameter("sortType");
				String sortOrder = request.getParameter("sortOrder");
			%>
			<table style="border:none;width:auto">
				<tr>
					<td colspan="2" style="border:none"><h2>Filter/Search Auction List</h2></td>
				</tr>
				<tr>
					<td style="border:none">Auction Status:</td>
					<td style="border:none"><select name="auctionStatus">
						<option value="all" <%=auctionStatus == null || auctionStatus.equals("all") ? "selected" : ""%>>Show all auctions</option>
						<option value="open" <%=auctionStatus != null && auctionStatus.equals("open") ? "selected" : ""%>>Show open auctions only</option>
						<option value="closed" <%=auctionStatus != null && auctionStatus.equals("closed") ? "selected" : ""%>>Show closed auctions only</option>
					</select></td>
				</tr>
				<tr>
					<td style="border:none">Keywords/Phrases in Title (separate entries with commas):</td>
					<td style="border:none"><input type="text" name="titleKeywords" value=<%=titleKeywordsString != null ? titleKeywordsString : ""%>></td>
				</tr>
				<tr>
					<td style="border:none">Seller Name:</td>
					<td style="border:none"><input type="text" name="sellerName" value=<%=sellerName != null ? sellerName : ""%>></td>
				</tr>
				<tr>
					<td style="border:none">Keywords/Phrases in Description (separate entries with commas):</td>
					<td style="border:none"><input type="text" name="descriptionKeywords" value=<%=descriptionKeywordsString != null ? descriptionKeywordsString : ""%>></td>
				</tr>
				<tr>
					<td style="border:none">Minimum Price:</td>
					<td style="border:none"><input type="number" name="minPrice" min="0" step="0.01" <%=minPrice == 0 ? "" : "value=\"" + minPrice + "\""%>></td>
				</tr>
				<tr>
					<td style="border:none">Maximum Price:</td>
					<td style="border:none"><input type="number" name="maxPrice" min="0" step="0.01" <%=maxPrice == 0 ? "" : "value=\"" + maxPrice + "\""%>></td>
				</tr>
				<tr>
					<td style="border:none">Clothes Type:</td>
					<td style="border:none"><select id="clothesType" name="clothesType" onChange="showClothesOptions()">
						<option value="all" <%=clothesType == null || clothesType.equals("all") ? "selected" : ""%>>Show all clothes types</option>
						<option value="shirts" <%=clothesType != null && clothesType.equals("shirts") ? "selected" : ""%>>Show shirts only</option>
						<option value="pants" <%=clothesType != null && clothesType.equals("pants") ? "selected" : ""%>>Show pants only</option>
						<option value="shoes" <%=clothesType != null && clothesType.equals("shoes") ? "selected" : ""%>>Show shoes only</option>
					</select></td>
				</tr>
				<tbody id="shirtsOptions">
				<tr>
					<td style="border:none">Minimum Arm Length (in.):</td>
					<td style="border:none"><input type="number" name="minArm" min="0" step="any" <%=minArm == 0 ? "" : "value=\"" + minArm + "\""%>></td>
				</tr>
				<tr>
					<td style="border:none">Maximum Arm Length (in.):</td>
					<td style="border:none"><input type="number" name="maxArm" min="0" step="any" <%=maxArm == 0 ? "" : "value=\"" + maxArm + "\""%>></td>
				</tr>
				<tr>
					<td style="border:none">Minimum Collar Size (in.):</td>
					<td style="border:none"><input type="number" name="minCollar" min="0" step="any" <%=minCollar == 0 ? "" : "value=\"" + minCollar + "\""%>></td>
				</tr>
				<tr>
					<td style="border:none">Maximum Collar Size (in.):</td>
					<td style="border:none"><input type="number" name="maxCollar" min="0" step="any" <%=maxCollar == 0 ? "" : "value=\"" + maxCollar + "\""%>></td>
				</tr>
				<tr>
					<td style="border:none">Minimum Waist Size (in.):</td>
					<td style="border:none"><input type="number" name="minWaist" min="0" step="any" <%=minWaist == 0 ? "" : "value=\"" + minWaist + "\""%>></td>
				</tr>
				<tr>
					<td style="border:none">Maximum Waist Size (in.):</td>
					<td style="border:none"><input type="number" name="maxWaist" min="0" step="any" <%=maxWaist == 0 ? "" : "value=\"" + maxWaist + "\""%>></td>
				</tr>
				</tbody>
				<tbody id="pantsOptions">
				<tr>
					<td style="border:none">Minimum Width (in.):</td>
					<td style="border:none"><input type="number" name="minWidth" min="0" step="any" <%=minWidth == 0 ? "" : "value=\"" + minWidth + "\""%>></td>
				</tr>
				<tr>
					<td style="border:none">Maximum Width (in.):</td>
					<td style="border:none"><input type="number" name="maxWidth" min="0" step="any" <%=maxWidth == 0 ? "" : "value=\"" + maxWidth + "\""%>></td>
				</tr>
				<tr>
					<td style="border:none">Minimum Length (in.):</td>
					<td style="border:none"><input type="number" name="minLength" min="0" step="any" <%=minLength == 0 ? "" : "value=\"" + minLength + "\""%>></td>
				</tr>
				<tr>
					<td style="border:none" colspan="0">Maximum Length (in.):</td>
					<td style="border:none"><input style="align-self:right" type="number" name="maxLength" min="0" step="any" <%=maxLength == 0 ? "" : "value=\"" + maxLength + "\""%>></td>
				</tr>
				</tbody>
				<tbody id="shoesOptions">
				<tr>
					<td style="border:none">Minimum Size:</td>
					<td style="border:none"><input type="number" name="minSize" min="0" step="any" <%=minSize == 0 ? "" : "value=\"" + minSize + "\""%>></td>
				</tr>
				<tr>
					<td style="border:none">Maximum Size:</td>
					<td style="border:none"><input type="number" name="maxSize" min="0" step="any" <%=maxSize == 0 ? "" : "value=\"" + maxSize + "\""%>></td>
				</tr>
				</tbody>
				<tr>
					<td colspan="2" style="border:none"><h2>Sort Auction List</h2></td>
				</tr>
				<tr>
					<td style="border:none">Sort By:</td>
					<td style="border:none"><select name="sortType" id="sortType">
						<option value="timeCreated" <%=sortType == null || sortType.equals("timeCreated") ? "selected" : ""%>>Auction creation time</option>
						<option value="title" <%=sortType != null && sortType.equals("title") ? "selected" : ""%>>Auction title</option>
						<option value="seller" <%=sortType != null && sortType.equals("seller") ? "selected" : ""%>>Seller name</option>
						<option value="price" <%=sortType != null && sortType.equals("price") ? "selected" : ""%>>Current bid</option>
						<option value="expiration" <%=sortType != null && sortType.equals("expiration") ? "selected" : ""%>>Expiration time</option>
					</select></td>
				</tr>
				<tr>
					<td style="border:none">Sort Order:</td>
					<td style="border:none"><select name="sortOrder">
						<option value="ascending" <%=sortOrder == null || sortOrder.equals("ascending") ? "selected" : ""%>>Ascending</option>
						<option value="descending" <%=sortOrder != null && sortOrder.equals("descending") ? "selected" : ""%>>Descending</option>
					</select></td>
				</tr>
			</table>
			<br>
			<input type="submit" value="Apply Filter/Search and Sort Conditions">
		</form>
		<br>
		<br>

		<table>
			<tr>
				<th>Auction ID</th>
				<th>Title</th>
				<th>Seller</th>
				<th>Current Bid</th>
				<th colspan="2">Expiration</th>

				<!-- Should take us to the individual auction page
				 where we can see more info & place bid -->
<%--					<th>See Info Here!</th>--%>
			</tr>
			<%
				Connection con = null;
				try {
					// Get the database connection
					ApplicationDB db = new ApplicationDB();
					con = db.getConnection();

					//Create a SQL statement
					Statement stmt = con.createStatement();
					ResultSet result;

					// Create barebones SQL string
					String select = "SELECT DISTINCT a.auctionId, a.title, u.name, a.highestBid, a.expiration";
					String from = " FROM Auction a, User u";
					String where = " WHERE a.sellerId = u.userId";

					// Apply filter and sort conditions
					String getAuctionTable = select + from + where;
					System.out.println(getAuctionTable);
					if (auctionStatus != null && auctionStatus.equals("open")) where += " AND a.expiration > NOW()";
					else if (auctionStatus != null && auctionStatus.equals("closed")) where += " AND a.expiration <= NOW()";
					if (titleKeywordsString != null && !titleKeywordsString.equals("")) {
						for (int i = 0; i < titleKeywords.length; i++) {
							where += " AND a.title LIKE '%" + titleKeywords[i] + "%'";
						}
					}

					getAuctionTable = select + from + where;
					System.out.println(getAuctionTable);
					if (sellerName != null && !sellerName.equals("")) where += " AND u.name = '" + sellerName + "'";
					if (descriptionKeywordsString != null && !descriptionKeywordsString.equals("")) {
						for (int i = 0; i < descriptionKeywords.length; i++) {
							where += " AND a.title LIKE '%" + descriptionKeywords[i] + "%'";
						}
					}
					if (minPrice > 0) where += " AND a.highestBid >= " + minPrice;
					if (maxPrice > 0) where += " AND a.highestBid <= " + maxPrice;
					getAuctionTable = select + from + where;
					System.out.println(getAuctionTable);
					if (clothesType != null && clothesType.equals("shirts")) {
						from += ", Shirts";
						where += " AND a.itemId IN (SELECT itemId FROM Shirts)";
						if (minArm > 0) where += " AND a.itemId = Shirts.itemId AND Shirts.armLength >= " + minArm;
						if (maxArm > 0) where += " AND a.itemId = Shirts.itemId AND Shirts.armLength <= " + maxArm;
						if (minCollar > 0) where += " AND a.itemId = Shirts.itemId AND Shirts.collarSize >= " + minCollar;
						if (maxCollar > 0) where += " AND a.itemId = Shirts.itemId AND Shirts.collarSize <= " + maxCollar;
						if (minWaist > 0) where += " AND a.itemId = Shirts.itemId AND Shirts.waistSize >= " + minWaist;
						if (maxWaist > 0) where += " AND a.itemId = Shirts.itemId AND Shirts.waistSize <= " + maxWaist;
					} else if (clothesType != null && clothesType.equals("pants")) {
						from += ", Pants";
						where += " AND a.itemId IN (SELECT itemId FROM Pants)";
						if (minWidth > 0) where += " AND a.itemId = Pants.itemId AND Pants.width >= " + minWidth;
						if (maxWidth > 0) where += " AND a.itemId = Pants.itemId AND Pants.width <= " + maxWidth;
						if (minLength > 0) where += " AND a.itemId = Pants.itemId AND Pants.length >= " + minLength;
						if (maxLength > 0) where += " AND a.itemId = Pants.itemId AND Pants.length <= " + maxLength;
					} else if (clothesType != null && clothesType.equals("shoes")) {
						from += ", Shoes";
						where += " AND a.itemId IN (SELECT itemId FROM Shoes)";
						if (minSize > 0) where += " AND a.itemId = Shoes.itemId AND Shoes.width >= " + minSize;
						if (maxSize > 0) where += " AND a.itemId = Shoes.itemId AND Shoes.width <= " + maxSize;
					}
					getAuctionTable = select + from + where;
					System.out.println(getAuctionTable);
					if (sortType == null || sortType.equals("timeCreated")) where += " ORDER BY a.auctionId";
					else if (sortType.equals("title")) where += " ORDER BY a.title";
					else if (sortType.equals("seller")) where += " ORDER BY u.name";
					else if (sortType.equals("price")) where += " ORDER BY a.highestPrice";
					else if (sortType.equals("expiration")) where += " ORDER BY a.expiration";
					if (sortOrder == null || sortOrder.equals("ascending")) where += " ASC";
					else where += " DESC";
					getAuctionTable = select + from + where;
					result = stmt.executeQuery(getAuctionTable);

					// For table
					NumberFormat currency = NumberFormat.getCurrencyInstance();
					date = new SimpleDateFormat("MMM d, yyyy hh:mm");
					long now = (new java.util.Date()).getTime();

					// Iterate through ResultSet and add to table
					while (result.next()) {
						int auctionId = result.getInt(1);
						String title = result.getString(2);
						String seller = result.getString(3);
						double currentPrice = result.getFloat(4);
						long expiration = result.getTimestamp(5).getTime();
						long diffHours = expiration - now;
						diffHours = (diffHours - (diffHours % 3600000)) / 3600000;
						long diffDays = diffHours / 24;
						diffHours = diffHours % 24;

						out.print("<tr>");
						out.print("<td style=\"text-align:center\">" + auctionId + "</td>");
						out.print("<td style=\"text-align:center\"><a href=\"item_page.jsp?auctionId=" + auctionId + "\">" + title + "</a></td>"); // could just make this an html link
						out.print("<td style=\"text-align:center\">" + seller + "</td>");
						out.print("<td style=\"text-align:center\">" + currency.format(currentPrice) + "</td>");
						out.print("<td style=\"text-align:center\">" + ((expiration - now) < 0 ? "Closed" : (diffDays + "d " + diffHours + "h")) + "</td>");
						out.print("<td style=\"text-align:center\">" + date.format(expiration) + "</td>");
						out.print("</tr>");
					}
					con.close();
				} catch (Exception ex) {
					out.print(ex);
					ex.printStackTrace();
					out.print("<br>");
					out.print("<br>");
					out.print("Failed to display auctions.");
				}
			%>
		</table>
		<!-- IMPORTANT: "can't access javascript variables in JSP. But you can store needed
		data in hidden fields, set its value in client and get it on server over GET or POST."  -->
		<!-- <input id=hiddenField type="hidden" name="hiddenData" value="" /> -->

		<input type="hidden" id="hiddenField" name="dataStored" value="">
		<button type="hidden" id="autoClick" value="Login" style="display: none;"></button>
		</form>

	    <script>
			function myFunction(selectRow) {
			let table = document.getElementById("auctionBidder");
			/* column with itemId */
			let columnId = selectRow.cells[1].innerHTML;

			    /* https://stackoverflow.com/questions/3116058/how-can-i-access-javascript-variables-in-jsp#:~:text=JavaScript%20variable%20is%20on%20client,server%20over%20GET%20or%20POST. */
				var getID = document.getElementById("hiddenField");
			    getID.value = columnId;

			    /* ERROR: this is not redirect page with hidden value.... */
			    /* window.location.assign('bid_page.jsp'); */
			    /* window.location.href = 'bid_page.jsp'; */

			    /* a button that is click automatically(using javascript) */
			    document.getElementById("autoClick").click();
		    }
	   	</script>
	   	<!-- Reference: solution4 https://localcoder.org/how-to-pass-a-value-from-one-jsp-to-another-jsp-page#:~:text=Can%20be%20done%20in%20three,getAttribute(%22send%22)%3B -->
	</body>
</html>