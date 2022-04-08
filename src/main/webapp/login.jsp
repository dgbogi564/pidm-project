<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.util.concurrent.TimeUnit" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Login</title>
</head>
<body>
	<%
		Connection con = null;
		try {

			//Get the database connection
			ApplicationDB db = new ApplicationDB();
			con = db.getConnection();

			//Create a SQL statement
			Statement stmt = con.createStatement();
			
			//Check if session already exists
			if (session.getAttribute("userId") != null) {
				int userId = (Integer) session.getAttribute("userId");
				String getUserInfo = "SELECT * FROM User WHERE userId = " + userId;
				ResultSet result = stmt.executeQuery(getUserInfo);
				if (result.next()) {
					response.sendRedirect("profile_page.jsp");
				} else {
					con.close();
					response.sendRedirect("logout.jsp");
				}
			}
			
			
			//Get parameters from the HTML form at the login-page.jsp
			String username = request.getParameter("username");
			String password = request.getParameter("password");

			//Get userId
			String getUserInfo = "SELECT * FROM User WHERE name = " + "\'" + username + "\'" + " and password = '" + password + "'";
			ResultSet result = stmt.executeQuery(getUserInfo);
			int userId;
			if (result.next()) {
				session.setAttribute("userId", Integer.parseInt(result.getString("userId")));
				session.setAttribute("name", result.getString("name"));
				out.print("Login successful.");
				out.print("<br>");
				out.print("<br>");
				out.print("<form method=\"post\" action=\"login_page.jsp\">\n\t\t\t<input type=\"submit\" value=\"Continue to profile page\" />\n\t\t</form>");
			} else {
				throw new Exception("User does not exist.");
			}
			
			//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
			con.close();
			
		} catch (Exception ex) {
			if (con != null) {
				con.close();
			}
			out.print(ex);
			out.print("<br>");
			out.print("Login failed.");
			out.print("<br>");
			out.print("<br>");
			out.print("<form method=\"post\" action=\"login_page.jsp\">\n\t\t\t<input type=\"submit\" value=\"Return to login page\" />\n\t\t</form>");
		}
	%>
</body>
</html>