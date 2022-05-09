<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.text.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page session="true" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>View User</title>
    <style>
        table, th, td {
            border: 1px solid black;
            border-collapse: collapse;
        }
        table {
            width: 100%;
        }
        td {
            text-align: center;
        }
        .data:hover {
            cursor: pointer;
            background-color: #58C9FF;
        }
    </style>
</head>
<body>
<%
    Connection con = null;

    int userId = 0;
    String name = null;

    try {
        userId = Integer.parseInt(request.getParameter("userId"));

        // Get the database connection
        ApplicationDB db = new ApplicationDB();
        con = db.getConnection();

        //Create a SQL statement
        Statement stmt = con.createStatement();
        ResultSet result = stmt.executeQuery("SELECT name FROM User WHERE userId = " + userId);

        // Get user name
        result.next();
        if ((name = result.getString(1)) == null) throw new Exception("User does not exist");
    } catch (Exception ex) {
        out.print(ex);
        ex.printStackTrace();
        out.print("<br>");
        out.print("<br>");
        out.print("Failed to find user.");
    }
%>
<h1>Viewing <%=name%>'s Bid and Auction History</h1>
<button onclick="history.back()">Return to Previous Page</button>
<h3>Auction History</h3>
<table>
    <tr>
        <th>Auction ID</th>
        <th>Title</th>
        <th>Current Bid</th>
        <th colspan="2">Expiration</th>
    </tr>
    <%
        try {
            // Get the database connection
            ApplicationDB db = new ApplicationDB();
            con = db.getConnection();

            //Create a SQL statement
            Statement stmt = con.createStatement();
            ResultSet result;

            // Create SQL query
            String getAuctionTable = "SELECT DISTINCT a.auctionId, a.title, a.highestBid, a.expiration " +
                    "FROM Auction a, User u WHERE a.sellerId = u.userId AND u.userId = " + userId;
            result = stmt.executeQuery(getAuctionTable);

            // For table
            NumberFormat currency = NumberFormat.getCurrencyInstance();
            SimpleDateFormat date = new SimpleDateFormat("MMM d, yyyy hh:mm");
            long now = (new java.util.Date()).getTime();

            // Iterate through ResultSet and add to table
            while (result.next()) {
                int auctionId = result.getInt(1);
                String title = result.getString(2);
                double currentPrice = result.getFloat(3);
                long expiration = result.getTimestamp(4).getTime();
                long diffHours = expiration - now;
                diffHours = (diffHours - (diffHours % 3600000)) / 3600000;
                long diffDays = diffHours / 24;
                diffHours = diffHours % 24;

                out.print("<tr>");
                out.print("<td style=\"text-align:center\">" + auctionId + "</td>");
                out.print("<td style=\"text-align:center\"><a href=\"item_page.jsp?auctionId=" + auctionId + "\">" + title + "</a></td>");
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
            out.print("Failed to display user's auctions.");
        }
    %>
</table>
<h3>Bid History</h3>
<table>
    <tr>
        <th>Auction ID</th>
        <th>Title</th>
        <th>Amount</th>
        <th>Time</th>
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
            result = stmt.executeQuery("SELECT a.auctionId, a.title, b.amount, b.time, b.anonymous FROM Auction a, Bid b WHERE a.auctionId = b.auctionId AND b.bidderId = " + userId);
            if ((Integer) session.getAttribute("userId") == userId) {
                while (result.next()) {
                    int auctionId = result.getInt(1);
                    String title = result.getString(2);
                    String amount = currency.format(result.getFloat(3));
                    String time = date.format(result.getTimestamp(4).getTime());

                    out.print("<tr>");
                    out.print("<td>" + auctionId + "</td>");
                    out.print("<td><a href=\"auction_page.jsp?auctionId=" + auctionId + "\">" + title + "</a></td>");
                    out.print("<td>" + amount + "</td>");
                    out.print("<td>" + time + "</td>");
                    out.print("</tr>");
                }
            } else {
                while (result.next()) {
                    if (result.getBoolean(5)) continue;

                    int auctionId = result.getInt(1);
                    String title = result.getString(2);
                    String amount = currency.format(result.getFloat(3));
                    String time = date.format(result.getTimestamp(4).getTime());

                    out.print("<tr>");
                    out.print("<td>" + auctionId + "</td>");
                    out.print("<td><a href=\"item_page.jsp?auctionId=" + auctionId + "\">" + title + "</a></td>");
                    out.print("<td>" + amount + "</td>");
                    out.print("<td>" + time + "</td>");
                    out.print("</tr>");
                }
            }
        } catch (Exception ex) {
            out.print(ex);
            ex.printStackTrace();
            out.print("<br>");
            out.print("<br>");
            out.print("Failed to display user's bid history.");
        }
    %>
</table>
</body>
</html>