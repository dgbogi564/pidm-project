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
    String expiration = null;
    String timeLeft = null;

    try {
        // Get the database connection
        ApplicationDB db = new ApplicationDB();
        con = db.getConnection();

        // Create a SQL statement
        Statement stmt = con.createStatement();
        ResultSet result;

        // Get item information
        String getInfo = "SELECT a.title, u.name, a.itemId, a.description, c.manufacturer, c.color, " +
                "c.condition, a.quantity, a.initialPrice, a.highestBid, a.increment, a.expiration FROM " +
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
        if ((currentPriceFloat = result.getFloat(9)) == 0) currentPriceFloat = result.getFloat(10);
        currentBid = currency.format(currentPriceFloat);
        minimumBidFloat = currentPriceFloat + result.getFloat(11);
        minimumBid = currency.format(minimumBidFloat);
        long expirationLong = result.getTimestamp(12).getTime();
        expiration = date.format(expirationLong);
        long now = (new java.util.Date()).getTime();
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
    <tr>
        <td>Condition:</td>
        <td><%=condition%></td>
    </tr>
    <tr>
        <td>Quantity:</td>
        <td><%=quantity%></td>
    </tr>
</table>
<h3>Make a Bid</h3>
<form method="get" action="make_bid.jsp">
    <table>
        <tr>
            <td>Expiration:</td>
            <td><%=expiration%></td>
        </tr>
        <tr>
            <td>Time Left:</td>
            <td><%=timeLeft%></td>
        </tr>
        <tr>
            <td>Current Bid:</td>
            <td><%=currentBid%></td>
        </tr>
        <tr>
            <td>Minimum Bid:</td>
            <td><%=minimumBid%></td>
        </tr>
        <tr>
            <td><label>Bid:</label></td>
            <td><input type="number" min="<%=minimumBidFloat%>" step="0.01"></td>
        </tr>
    </table>
    <input type="submit" formaction="make_bid.jsp" value="Make Bid" formmethod="get">
</form>
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
    <tr>
        <td>Item ID:</td>
        <td><%=itemId%></td>
    </tr>
</table>
</body>
</html>