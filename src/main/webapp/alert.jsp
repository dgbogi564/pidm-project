<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.text.*, java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page session="true" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="UTF-8">
<title>alert page</title>
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
		ResultSet result;

		// Check if user is an admin
		Integer userId = (Integer) session.getAttribute("userId");
		result = stmt.executeQuery("SELECT COUNT(*) FROM Admin WHERE userId = " + userId);
		result.next();
		if (result.getInt(1) != 0) throw new Exception("Admins cannot add alerts");

		/* Get item ID */
		int alertId;
		String GetLastItemId = "SELECT alertId FROM Alert ORDER BY alertId DESC LIMIT 1";
		result = stmt.executeQuery(GetLastItemId);
		if (result.next()) {
			alertId = Integer.parseInt(result.getString(1)) + 1;
		} else {
			alertId = 1;
		}

		String titleKeywordsString = request.getParameter("titleKeywords");
		String descriptionKeywordsString = request.getParameter("descriptionKeywords");
		String color = request.getParameter("color");
		String manufacturer = request.getParameter("manufacturer");
		String minBidString = request.getParameter("minBid");
		String maxBidString = request.getParameter("maxBid");
		float minBid = 0, maxBid = 0;
		if (minBidString != null && !minBidString.equals("")) minBid = Float.parseFloat(request.getParameter("minBid"));
		if (maxBidString != null && !maxBidString.equals("")) maxBid = Float.parseFloat(request.getParameter("maxBid"));
		String clothesType = request.getParameter("clothesType");

		String insert = "INSERT INTO Alert(titleKeywords, descriptionKeywords, color, manufacturer, minBid, maxBid, clothesType, alertId, userId) "
				+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
		PreparedStatement ps = con.prepareStatement(insert);
		ps.setString(1, titleKeywordsString);
		ps.setString(2, descriptionKeywordsString);
		ps.setString(3, color);
		ps.setString(4, manufacturer);
		ps.setFloat(5, minBid);
		ps.setFloat(6, maxBid);
		ps.setString(7, clothesType);
		ps.setInt(8, alertId);
		ps.setInt(9, userId);
		ps.executeUpdate();

	} catch (Exception ex) {
		out.print(ex);
		ex.printStackTrace();
		out.print("<br>");
		out.print("<br>");
		out.print("Alert add failed.");
	}
%>
<p>Alert added.</p>
<form method="post" action="alert_page.jsp"><input type="submit" value="Return to Alert Page"></form>

</body>
</html>