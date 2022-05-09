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
            <input type="submit" value="Go to Alerts Page">
        </form>

        <br>

        <br>
        <hr>
        <form method="get" action="auction_page.jsp">
            <h2>Go to Auction Page</h2>
            <input type="submit" value="Go to Auction Page">
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