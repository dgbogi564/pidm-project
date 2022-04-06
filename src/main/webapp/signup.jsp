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
	<title>Signup</title>
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

				//Get parameters from the HTML form at the login.jsp
				String username = request.getParameter("username");
				String password = request.getParameter("password");


				//Check if user already exists
				String FindDuplicate = "SELECT COUNT(*) FROM User WHERE name = " + "\'" + username + "\'";
				ResultSet result = stmt.executeQuery(FindDuplicate);
				result.next();
				if (Integer.parseInt(result.getString("COUNT(*)")) > 0) {
					throw new Exception("User already exists.");
				}

				//Get userId
				String GetUserCount = "SELECT COUNT(*) FROM user";
				result = stmt.executeQuery(GetUserCount);
				result.next();
				int userId = Integer.parseInt(result.getString("COUNT(*)")) + 1;

				//Make an insert statement for the User table:
				String insert = "INSERT INTO User(name, password, userId)"
						+ "VALUES (?, ?, ?)";
				//Create a Prepared SQL statement allowing you to introduce the parameters of the query
				PreparedStatement ps = con.prepareStatement(insert);

				//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
				ps.setString(1, username);
				ps.setString(2, password);
				ps.setFloat(3, userId);
				//Run the query against the DB
				ps.executeUpdate();

				//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
				con.close();

				out.print("Signup completed.");
				//TimeUnit.SECONDS.sleep(3);
				//response.sendRedirect("login.jsp");

			} catch (Exception ex) {
				if (con != null) {
					con.close();
				}
				out.print(ex);
				out.print("<br>");
				out.print("Signup failed.");
				//TimeUnit.SECONDS.sleep(3);
				//response.sendRedirect("signup.jsp");
			}
		%>
	</body>
</html>