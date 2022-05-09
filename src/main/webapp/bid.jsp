<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.text.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.util.Date" %>
<%@ page session="true" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Make Bid</title>
</head>
<body>
    <%
        Connection con = null;

        // Formatting
        NumberFormat currency = NumberFormat.getCurrencyInstance();
        SimpleDateFormat date = new SimpleDateFormat("MMM d, yyyy HH:mm");

        // Create variables
        Float currentBid = Float.parseFloat(request.getParameter("bid"));
        int auctionId = Integer.parseInt(request.getParameter("auctionId"));
        long now = (new Date()).getTime();
        boolean anonymous = false;
        if (request.getParameter("anonymous") != null) anonymous = true;

        try {
            // Get the database connection
            ApplicationDB db = new ApplicationDB();
            con = db.getConnection();

            // Create a SQL statement
            Statement stmt = con.createStatement();
            ResultSet result;

            // Check for valid parameters
            result = stmt.executeQuery("SELECT COUNT(*) FROM Auction WHERE auctionId = " + auctionId + " AND sellerId" +
                    " = " + session.getAttribute("userId"));
            result.next();
            if (result.getInt(1) != 0) throw new Exception("Cannot bid in your own auction.");

            con.setAutoCommit(false);
            PreparedStatement ps;

            // Alert other bidders
            String GetBidderIds = "SELECT bidderId FROM Bid WHERE auctionId = " + auctionId;
            result = stmt.executeQuery(GetBidderIds);
            while(result.next()) {
                int bidderId = Integer.parseInt(result.getString("bidderId"));
                int auctItemID = Integer.parseInt(session.getAttribute("auctItemID"));

                ps = con.prepareStatement("SELECT alertId FROM Alert WHERE Alert.userId = " + bidderId + " Alert.itemId = " + auctItemID);
                ResultSet result2 = stmt.executeQuery(GetBidderIds);

                if(!result2.next()) {
                    ps = con.prepareStatement("INSERT INTO Alert(userId, alertId, itemId) VALUES(?, ?, ?)");
                    ps.setInt(1, bidderId);
                    ps.setInt(2, auctionId);
                    ps.setInt(3, auctItemID);
                    ps.executeUpdate();
                }
            }

            ps = con.prepareStatement("INSERT INTO Bid (amount, time, anonymous, auctionId, bidderId) VALUES (?, ?, ?, ?, ?)");
            ps.setFloat(1, currentBid);
            ps.setTimestamp(2, new Timestamp(now));
            ps.setBoolean(3, anonymous);
            ps.setInt(4, auctionId);
            ps.setInt(5, (Integer) session.getAttribute("userId"));
            ps.executeUpdate();

            ps = con.prepareStatement("UPDATE Auction SET highestBid = ? WHERE auctionId = ?");
            ps.setFloat(1, currentBid);
            ps.setInt(2, auctionId);
            ps.executeUpdate();

            con.commit();
            con.setAutoCommit(true);

            out.print("<p>Successfully made a bid of " + currency.format(currentBid) + " for Auction #"+ auctionId
                    + " at " + date.format(now) + ".<p>");
            out.print("<p>Bid was " + (anonymous ? "" : "not") + " made anonymously.");
        } catch (Exception ex) {
            out.print(ex);
            ex.printStackTrace();
            out.print("<br>");
            out.print("<br>");
            out.print("Failed to submit bid.");
        }
    %>
    <br>
    <form method="get" action="item_page.jsp">
        <input type="hidden" name="auctionId" value=<%=auctionId%>>
        <input type="submit" value="Return to Item Page">
    </form>
</body>
</html>
