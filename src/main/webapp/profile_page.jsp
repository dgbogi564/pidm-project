<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" import="com.cs336.pkg.*" %>
<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page session="true" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login</title>
        <style>
            table, th, td {
                border-collapse: separate;
                border-spacing: 1em 2em;
                border-collapse: collapse;
                border: 1px solid black;
            }

            table {
                width: 100%;
            }

            input {
                margin: 10px;
            }
        </style>
    </head>
    <body>
        <%
            String name = (String) session.getAttribute("name");
            out.print("<h1>Welcome, " + name + ".</h1>");
        %>

        <hr>

        <%
            Integer userId = (Integer) session.getAttribute("userId");
            if (session.getAttribute("userId") == null) {
                response.sendRedirect("login.jsp");
            }
        %>


        <h2>Alerts: </h2>
        <%--		<fieldset>--%>

        <form method="get" action="alert_page.jsp">
            <input type="submit" value="Set up new alert!">
        </form>

        <br>

        <table>
            <tr>
                <th>Item ID</th>
                <th>Title</th>
                <th>Type of Clothes</th>
                <th>Color</th>
                <th>Condition</th>
                <th>Manufacturer</th>
                <th>Highest Bid</th>
            <tr>
                    <%
					Connection con = null;
					try {
						//Get the database connection
						ApplicationDB db = new ApplicationDB();
						con = db.getConnection();

						//Create a SQL statement
						Statement stmt = con.createStatement();
						ResultSet result;

						String getAuctionTable = "SELECT a.itemId, a.title, c.color, c.manufacturer, a.highestBid FROM Auction a, Clothes c, Alert WHERE a.itemId = c.itemId AND Alert.userId = " + userId;
						result = stmt.executeQuery(getAuctionTable);

						ResultSet clothesType;
						String clothesString;

						// Iterate through ResultSet and add to table
						while (result.next()) {
							int id = result.getInt(1);
							String title = result.getString(2);
							String color = result.getString(3);
							String manufacturer = result.getString(4);
							double highestBid = result.getFloat(5);

							out.print("<tr>");
							out.print("<td>" + id + "</td>"); // could just make this an html link
							out.print("<td>" + title + "</td>");


							clothesType = stmt.executeQuery("SELECT COUNT(*) FROM Shirts WHERE itemId = " + id);
							clothesType.next();
							if (result.getInt(1) != 0) clothesString = "Shirts";
							else {
								clothesType = stmt.executeQuery("SELECT COUNT(*) FROM Pants WHERE itemId = " + id);
								clothesType.first();
								if (result.getInt(1) != 0) clothesString = "Pants";
								else clothesString = "Shoes";
							}
							out.print("<td>" + clothesString + "<td>");

							out.print("<td>" + color + "</td>");
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
						out.print("Failed to display alerts.");
						out.print("<form method=\"post\" action=\"profile_page.jsp\">\n\t\t\t<input type=\"submit\" value=\"Go back to profile page\" />\n\t\t</form>");
					}
				%>
        </table>
        <%--		</fieldset>--%>

        <br>
        <hr>
        <form method="get" action="auction_page.jsp">
            <h2>Go to Auction Page</h2>
            <input type="submit" value="Auction Page">
        </form>
        <br>
        <hr>

        <h2>User Details:</h2>
        <form method="get" action="user_info.jsp">
            <input type="hidden" name="userId" value=<%="\"" + (Integer) session.getAttribute("userId") + "\""%>>
            <input type="submit" value="View Your Auction and Bid History">
        </form>
        <br>
        <hr>

        <br><br><br>
        <form method="get" action="delete_account.jsp">
            <input type="submit" value="Delete account">
        </form>
        <br>
        <form method="post" action="logout.jsp">
            <input type="submit" value="Logout"/>
        </form>
    </body>
</html>