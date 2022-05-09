<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" import="com.cs336.pkg.*" %>
<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page session="true" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Show Users</title>
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

        <h2>User Representatives</h2>

        <br>

        <table>
            <tr>
                <th>UserId</th>
                <th>Username</th>
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

                    String query = "SELECT Representative.userId FROM representative";
                    result = stmt.executeQuery(query);
                    ArrayList<Integer> userIds = new ArrayList<Integer>();
                    while (result.next()) {
                        userIds.add(result.getInt(1));
                    }
                    result.close();
                    for(int id: userIds) {
                        query = "SELECT User.name FROM User WHERE User.userId = " + id;
                        result = stmt.executeQuery(query);
                        if (result.next()) {
                            String user = result.getString(1);

                            out.print("<tr>");
                            out.print("<td>" + id + "</td>");
                            out.print("<td><a href=\"user_info.jsp?userId=" + id + "\">" + user + "</a></td>");
                            out.print("</tr>");
                        }
                    }
                    result.close();
                } catch (Exception ex) {
                    if(con != null) {
                        con.close();
                    }
                    out.print(ex);
                    ex.printStackTrace();
                    out.print("<br>");
                    out.print("<br>");
                    out.print("Failed to display Representatives.");
                }
            %>
        </table>

        <br>

        <h2>Regular Users</h2>

        <br>

        <table>
            <tr>
                <th>UserId</th>
                <th>Username</th>
            <tr>
                <%
                con = null;
                try {
                    //Get the database connection
                    ApplicationDB db = new ApplicationDB();
                    con = db.getConnection();

                    //Create a SQL statement
                    Statement stmt = con.createStatement();
                    ResultSet result;

                    String query = "SELECT Regular.userId FROM Regular";
                    result = stmt.executeQuery(query);
                    ArrayList<Integer> userIds = new ArrayList<Integer>();
                    while (result.next()) {
                        userIds.add(result.getInt(1));
                    }
                    result.close();
                    for(int id: userIds) {
                        query = "SELECT User.name FROM User WHERE User.userId = " + id;
                        result = stmt.executeQuery(query);
                        if (result.next()) {
                            String user = result.getString(1);

                            out.print("<tr>");
                            out.print("<td>" + id + "</td>");
                            out.print("<td><a href=\"user_info.jsp?userId=" + id + "\">" + user + "</a></td>");
                            out.print("</tr>");
                        }
                    }
                    result.close();
                } catch (Exception ex) {
                    if(con != null) {
                        con.close();
                    }
                    out.print(ex);
                    ex.printStackTrace();
                    out.print("<br>");
                    out.print("<br>");
                    out.print("Failed to display Representatives.");
                }
            %>
        </table>

        <br>

        <form method="post" action="../admin_page.jsp">
            <input type="submit" value="Back to Admin page" />
        </form>
    </body>
</html>