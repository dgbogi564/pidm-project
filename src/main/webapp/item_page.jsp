<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.text.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page session="true" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>View Item</title>
</head>
<body>
<%
    Connection con = null;

    // Create variables
    String title = null;
    String sellerName = null;
    int auctionId = 0;
    int itemId = 0;
    String description = null;
    String manufacturer = null;
    String color = null;
    String condition = null;
    int quantity = 0;
    String currentBid = null;
    double startingBidFloat = 0;
    String startingBid = null;
    long expirationLong = 0;
    long now = (new java.util.Date()).getTime();
    String expiration = null;
    String timeLeft = null;
    String currentBidder = null;
    int sellerId = 0;
    int currentBidderId = 0;

    try {
        // Get the database connection
        ApplicationDB db = new ApplicationDB();
        con = db.getConnection();

        // Create a SQL statement
        Statement stmt = con.createStatement();
        ResultSet result;

        // Get item information
        String getInfo = "SELECT a.title, u.name, a.itemId, a.description, c.manufacturer, c.color, " +
                "c.condition, a.quantity, a.highestBid, a.initialPrice, a.increment, a.expiration, a.sellerId FROM " +
                "Auction a, User u, Clothes c WHERE a.sellerId = u.userId AND a.itemId = c.itemId AND " +
                "a.auctionId = " + request.getParameter("auctionId");
        result = stmt.executeQuery(getInfo);
        if (!result.next()) throw new Exception("Auction/item not found");

        // Formatting
        NumberFormat currency = NumberFormat.getCurrencyInstance();
        SimpleDateFormat date = new SimpleDateFormat("MMM d, yyyy hh:mm");

        // Store to variables
        title = result.getString(1);
        sellerName = result.getString(2);
        auctionId = Integer.parseInt(request.getParameter("auctionId"));
        itemId = result.getInt(3);
        description = result.getString(4);
        manufacturer = result.getString(5);
        color = result.getString(6);
        condition = result.getString(7);
        quantity = result.getInt(8);
        sellerId = result.getInt(13);
        double currentPriceFloat;
        Statement bidStmt = con.createStatement();
        ResultSet bidResult = bidStmt.executeQuery("SELECT COUNT(*) FROM Bid WHERE auctionId = " + auctionId);
        bidResult.next();
        if (bidResult.getInt(1) != 0) {
            currentPriceFloat = result.getFloat(9);
            bidResult = bidStmt.executeQuery("SELECT u.name, b.anonymous, b.bidderId FROM User u, Auction a, Bid b WHERE a.auctionId = "
                    + auctionId + " AND a.auctionId = b.auctionId AND a.highestBid = b.amount AND b.bidderId = u.userId");
            bidResult.next();
            currentBidder = bidResult.getBoolean(2) ? "[anonymous]" : bidResult.getString(1);
            currentBidderId = bidResult.getBoolean(2) ? 0 : bidResult.getInt(3);
        } else {
            currentPriceFloat = result.getFloat(10);
            currentBidder = "[none]";
        }
        currentBid = currency.format(currentPriceFloat);
        startingBidFloat = currentPriceFloat + result.getFloat(11);
        startingBid = currency.format(startingBidFloat);
        expirationLong = result.getTimestamp(12).getTime();
        expiration = date.format(expirationLong);
        long diff = ((expirationLong - now) - ((expirationLong - now) % 3600000)) / 3600000;
        timeLeft = (diff / 24) + "d " + (diff % 24) + "h";
    } catch (Exception ex) {
        out.print(ex);
        ex.printStackTrace();
        out.print("<br>");
        out.print("<br>");
        out.print("Failed to display auction/item information.");
        out.print("<form method=\"post\" action=\"auction_page.jsp\">\n\t\t\t<input type=\"submit\" value=\"Go back to auction page\" />\n\t\t</form>");
    }
%>
<h1><%=title%></h1>
<h3>Item Details</h3>
<table>
    <tr>
        <td>Description:</td>
        <td><%=description%></td>
    </tr>
    <tr>
        <td>Manufacturer:</td>
        <td><%=manufacturer%></td>
    </tr>
    <tr>
        <td>Color:</td>
        <td><%=color%></td>
    </tr>
    <%
        String clothesType = "";
        try {
            // Get the database connection
            ApplicationDB db = new ApplicationDB();
            con = db.getConnection();

            // Create a SQL statement
            Statement stmt = con.createStatement();
            ResultSet result;

            // Get item type
            result = stmt.executeQuery("SELECT COUNT(*) FROM Shirts WHERE itemId = " + itemId);
            result.next();
            if (result.getInt(1) != 0) {
                clothesType = "Shirts";
                result = stmt.executeQuery("SELECT armLength, collarSize, waistSize FROM Shirts WHERE itemId = " + itemId);
                result.first();
                out.print("<tr>");
                out.print("<td>Clothes Type:</td>");
                out.print("<td>Shirts</td>");
                out.print("</tr>");
                out.print("<tr>");
                out.print("<td>Arm Length (in.):</td>");
                out.print("<td>" + result.getFloat(1) + "</td>");
                out.print("</tr>");
                out.print("<tr>");
                out.print("<td>Collar Size (in.):</td>");
                out.print("<td>" + result.getFloat(2) + "</td>");
                out.print("</tr>");
                out.print("<tr>");
                out.print("<td>Waist Size (in.):</td>");
                out.print("<td>" + result.getFloat(3) + "</td>");
                out.print("</tr>");
            } else {
                clothesType = "Pants";
                result = stmt.executeQuery("SELECT COUNT(*) FROM Pants WHERE itemId = " + itemId);
                result.first();
                if (result.getInt(1) != 0) {
                    result = stmt.executeQuery("SELECT width, length FROM Pants WHERE itemId = " + itemId);
                    result.first();
                    out.print("<tr>");
                    out.print("<td>Clothes Type:</td>");
                    out.print("<td>Pants</td>");
                    out.print("</tr>");
                    out.print("<tr>");
                    out.print("<td>Width (in.):</td>");
                    out.print("<td>" + result.getFloat(1) + "</td>");
                    out.print("</tr>");
                    out.print("<tr>");
                    out.print("<td>Length (in.):</td>");
                    out.print("<td>" + result.getFloat(2) + "</td>");
                    out.print("</tr>");
                } else {
                    clothesType = "Shoes";
                    result = stmt.executeQuery("SELECT size FROM Shoes WHERE itemId = " + itemId);
                    result.first();
                    out.print("<tr>");
                    out.print("<td>Clothes Type:</td>");
                    out.print("<td>Shoes</td>");
                    out.print("</tr>");
                    out.print("<tr>");
                    out.print("<td>Size:</td>");
                    out.print("<td>" + result.getFloat(1) + "</td>");
                    out.print("</tr>");
                }
            }
        } catch (Exception ex) {
            out.print(ex);
            ex.printStackTrace();
            out.print("<br>");
            out.print("<br>");
            out.print("Failed to display auction/item information.");
            out.print("<form method=\"post\" action=\"auction_page.jsp\">\n\t\t\t<input type=\"submit\" value=\"Go back to auction page\" />\n\t\t</form>");
        }
    %>
    <tr>
        <td>Condition:</td>
        <td><%=condition%></td>
    </tr>
    <tr>
        <td>Quantity:</td>
        <td><%=quantity%></td>
    </tr>
    <tr>
        <td>Item ID:</td>
        <td><%=itemId%></td>
    </tr>
</table>
<h3>Make a Bid</h3>
<form method="get" action="bid.jsp">
    <table>
        <tr>
            <td>Expiration:</td>
            <td><%=expiration%></td>
        </tr>
        <tr>
            <td>Time Left:</td>
            <td><%=timeLeft.charAt(0) == '-' ? "Closed" : timeLeft%></td>
        </tr>
        <tr>
            <td>Current Bid:</td>
            <td><%=currentBid%></td>
        </tr>
        <tr>
            <td>Bidder:</td>
            <td><%=currentBidderId == 0 ? "" : "<a href=\"user_info.jsp?userId=" + currentBidderId + "\">"%><%=currentBidder%><%=currentBidderId == 0 ? "" : "</a>"%></td>
        </tr>
        <tr>
            <td>Starting Bid:</td>
            <td><%=startingBid%></td>
        </tr>
        <tr>
            <td><label for="bid">Bid:</label></td>
            <td><input type="number" id="bid" name="bid" min="<%=startingBidFloat%>" step="0.01" <%=expirationLong - now < 0 || (Integer) session.getAttribute("userId") == 1 ? "disabled" : ""%>></td>
        </tr>
        <tr>
            <td><label for="anonymous">Anonymous?</label></td>
            <td><input type="checkbox" id="anonymous" name="anonymous" <%=expirationLong - now < 0 || (Integer) session.getAttribute("userId") == 1 ? "disabled" : ""%>></td>
        </tr>
    </table>
    <input type="hidden" name="auctionId" value=<%=auctionId%>>
    <input type="submit" value="Make Bid" <%=expirationLong - now < 0 || (Integer) session.getAttribute("userId") == 1 ? "disabled" : ""%>>
</form>
<hr>
<h3>Auction Details</h3>
<table>
    <tr>
        <td>Seller:</td>
        <td><a href="user_info.jsp?userId=<%=sellerId%>"><%=sellerName%></a></td>
    </tr>
    <tr>
        <td>Auction ID:</td>
        <td><%=auctionId%></td>
    </tr>
</table>
<br>
<form action="auction_page.jsp">
    <input type="submit" value="Return to Auction Page">
</form>
<hr>
<h3>Bid History</h3>
<table style="border:1px solid black;border-collapse:collapse;width:100%">
    <tr>
        <th style="border:1px solid black">Bidder</th>
        <th style="border:1px solid black">Amount</th>
        <th style="border:1px solid black">Time</th>
    </tr>
    <%
        try {
            // Get the database connection
            ApplicationDB db = new ApplicationDB();
            con = db.getConnection();

            // Create a SQL statement
            Statement stmt = con.createStatement();
            ResultSet result;

            // Formatting
            NumberFormat currency = NumberFormat.getCurrencyInstance();
            SimpleDateFormat date = new SimpleDateFormat("MMM d, yyyy hh:mm");

            // Get bid history
            result = stmt.executeQuery("SELECT b.anonymous, u.name, b.amount, b.time, b.bidderId FROM User u, Bid b WHERE u.userId = b.bidderId AND b.auctionId = " + auctionId);
            while (result.next()) {
                String name = result.getString(2);
                String amount = currency.format(result.getFloat(3));
                String time = date.format(result.getTimestamp(4).getTime());
                int bidderId = result.getInt(5);

                out.print("<tr>");
                out.print("<td style=\"border:1px solid black;text-align:center\">");
                if (result.getBoolean(1)) out.print("[anonymous]");
                else out.print("<a href=\"user_info.jsp?userId=" + bidderId + "\">" + name + "</a>");
                out.print("</td>");
                out.print("<td style=\"border:1px solid black;text-align:center\">" + amount + "</td>");
                out.print("<td style=\"border:1px solid black;text-align:center\">" + time + "</td>");
                out.print("</tr>");
            }
        } catch (Exception ex) {
            out.print(ex);
            ex.printStackTrace();
            out.print("<br>");
            out.print("<br>");
            out.print("Failed to display bid history.");
            out.print("<form method=\"post\" action=\"auction_page.jsp\">\n\t\t\t<input type=\"submit\" value=\"Go back to auction page\" />\n\t\t</form>");
        }
    %>
</table>
<hr>
<h3>Similar Auctions From the Last Month</h3>
<table style="border:1px solid black;border-collapse:collapse;width:100%">
    <tr>
        <th style="border:1px solid black">Auction ID</th>
        <th style="border:1px solid black">Title</th>
        <th style="border:1px solid black">Seller</th>
        <th style="border:1px solid black">Final Bid</th>
        <th style="border:1px solid black">Expiration</th>
    </tr>
    <%
        try {
            // Get the database connection
            ApplicationDB db = new ApplicationDB();
            con = db.getConnection();

            // Create a SQL statement
            Statement stmt = con.createStatement();
            ResultSet result;

            // Formatting
            NumberFormat currency = NumberFormat.getCurrencyInstance();
            SimpleDateFormat date = new SimpleDateFormat("MMM d, yyyy hh:mm");

            // Get auction table
            String query = "SELECT DISTINCT a.auctionId, a.title, u.name, a.highestBid, a.expiration, a.sellerId FROM Auction a, " +
                    "User u WHERE a.sellerId = u.userId AND a.itemId IN (SELECT itemId FROM " + clothesType + ") " +
                    "AND a.expiration > NOW() - INTERVAL 1 MONTH AND a.expiration < NOW()";
            result = stmt.executeQuery(query);

            while (result.next()) {
                int queryAuctionId = result.getInt(1);
                String queryTitle = result.getString(2);
                String queryName = result.getString(3);
                String queryFinalBid = currency.format(result.getFloat(4));
                String queryExpiration = date.format(result.getTimestamp(5).getTime());
                int querySellerId = result.getInt(6);

                out.print("<tr>");
                out.print("<td style=\"border:1px solid black;text-align:center\">" + queryAuctionId + "</td>");
                out.print("<td style=\"border:1px solid black;text-align:center\">" + queryTitle + "</td>");
                out.print("<td style=\"border:1px solid black;text-align:center\"><a href=\"user_info.jsp?userId=" + querySellerId + "\">" + queryName + "</a></td>");
                out.print("<td style=\"border:1px solid black;text-align:center\">" + queryFinalBid + "</td>");
                out.print("<td style=\"border:1px solid black;text-align:center\">" + queryExpiration + "</td>");
                out.print("</tr>");
            }
        } catch (Exception ex) {
            out.print(ex);
            ex.printStackTrace();
            out.print("<br>");
            out.print("<br>");
            out.print("Failed to display similar auctions.");
            out.print("<form method=\"post\" action=\"auction_page.jsp\">\n\t\t\t<input type=\"submit\" value=\"Go back to auction page\" />\n\t\t</form>");
        }
    %>
</table>
</body>
</html>