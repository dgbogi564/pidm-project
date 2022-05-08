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
    double minimumBidFloat = 0;
    String minimumBid = null;
    long expirationLong = 0;
    long now = (new java.util.Date()).getTime();
    String expiration = null;
    String timeLeft = null;
    String currentBidder = null;

    try {
        // Get the database connection
        ApplicationDB db = new ApplicationDB();
        con = db.getConnection();

        // Create a SQL statement
        Statement stmt = con.createStatement();
        ResultSet result;

        // Get item information
        String getInfo = "SELECT a.title, u.name, a.itemId, a.description, c.manufacturer, c.color, " +
                "c.condition, a.quantity, a.highestBid, a.initialPrice, a.increment, a.expiration FROM " +
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
        double currentPriceFloat;
        Statement bidStmt = con.createStatement();
        ResultSet bidResult = bidStmt.executeQuery("SELECT COUNT(*) FROM Bid WHERE auctionId = " + auctionId);
        bidResult.next();
        if (bidResult.getInt(1) != 0) {
            currentPriceFloat = result.getFloat(9);
            bidResult = bidStmt.executeQuery("SELECT u.name, b.anonymous FROM User u, Auction a, Bid b WHERE a.auctionId = "
                    + auctionId + " AND a.auctionId = b.auctionId AND a.highestBid = b.amount AND b.bidderId = u.userId");
            bidResult.next();
            currentBidder = bidResult.getBoolean(2) ? "[anonymous]" : bidResult.getString(1);
        } else {
            currentPriceFloat = result.getFloat(10);
            currentBidder = "[none]";
        }
        currentBid = currency.format(currentPriceFloat);
        minimumBidFloat = currentPriceFloat + result.getFloat(11);
        minimumBid = currency.format(minimumBidFloat);
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
            <td><%=currentBidder%></td>
        </tr>
        <tr>
            <td>Minimum Bid:</td>
            <td><%=minimumBid%></td>
        </tr>
        <tr>
            <td><label for="bid">Bid:</label></td>
            <td><input type="number" id="bid" name="bid" min="<%=minimumBidFloat%>" step="0.01" <%=expirationLong - now < 0 ? "disabled" : ""%>></td>
        </tr>
        <tr>
            <td><label for="anonymous">Anonymous?</label></td>
            <td><input type="checkbox" id="anonymous" name="anonymous" <%=expirationLong - now < 0 ? "disabled" : ""%>></td>
        </tr>
    </table>
    <input type="hidden" name="auctionId" value=<%=auctionId%>>
    <input type="submit" value="Make Bid" <%=expirationLong - now < 0 ? "disabled" : ""%>>
</form>
<hr>
<h3>Auction Details</h3>
<table>
    <tr>
        <td>Seller:</td>
        <td><%=sellerName%></td>
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
</body>
</html>