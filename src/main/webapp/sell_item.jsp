<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page session="true" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>sell item</title>
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

			//Get parameters from the HTML form at the sell_page.jsp
			String username = request.getParameter("itemName");
			String password = request.getParameter("color");
			String password = request.getParameter("condition");	
			String password = request.getParameter("manufacturer");	
			
			/*  TO DO: get info and store it into clothes and isA tables....info to be used for auction */
			
	%>
</body>
</html>