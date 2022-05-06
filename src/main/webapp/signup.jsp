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
				int userId;
				String GetLastUserId = "SELECT userId FROM user ORDER BY userId DESC LIMIT 1";
				result = stmt.executeQuery(GetLastUserId);
				if(result.next()) {
					userId = Integer.parseInt(result.getString("userId")) + 1;
				} else {
					userId = 1;
				}

				//Make an insert statement for the User table:
				String insert = "INSERT INTO User(name, password, userId)"
						+ "VALUES (?, ?, ?)";
				//Create a Prepared SQL statement allowing you to introduce the parameters of the query
				PreparedStatement ps = con.prepareStatement(insert);

				//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
				ps.setString(1, username);
				ps.setString(2, password);
				ps.setInt(3, userId);
				//Run the query against the DB
				ps.executeUpdate();
				
				
				
				// Make statement to get userId, to determine if we make an Admin or Regulars
				result = stmt.executeQuery("SELECT userId from User WHERE userId = " + userId);
				result.beforeFirst();
				result.next();
				//Create admin
				if(result.getInt(1) == 1) {
					String str1 = "INSERT INTO Admin(userId)" + "VALUES (?)";
					ps = con.prepareStatement(str1);
					ps.setInt(1, userId);
					ps.executeUpdate();

				} else {
					//Create regulars
					String str2 = "INSERT INTO Regular(userId)" + "VALUES (?)";
					ps = con.prepareStatement(str2);
					ps.setInt(1, userId);
					ps.executeUpdate();
				}
				
				
				
				//Close the connection. Don't forget to do it, otherwise you're keeping the resources of the server allocated.
				con.close();
				
				//Update cookies
				session.setAttribute("userId", userId);
				session.setAttribute("name", username);

				out.print("Signup completed.");
				out.print("<br>");
				out.print("<br>");
				out.print("<form method=\"post\" action=\"profile_page.jsp\">\n\t\t\t<input type=\"submit\" value=\"Go to profile\" />\n\t\t</form>");

			} catch (Exception ex) {
				if (con != null) {
					con.close();
				}
				out.print(ex);
				out.print("<br>");
				out.print("Signup failed.");
				out.print("<br>");
				out.print("<br>");
				out.print("<form method=\"post\" action=\"signup_page.jsp\">\n\t\t\t<input type=\"submit\" value=\"Return to signup page\" />\n\t\t</form>");
			}
		%>
	</body>
</html>