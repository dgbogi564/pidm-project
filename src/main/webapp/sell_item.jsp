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
			/* TABLE Clothes */
			String itemName = request.getParameter("itemName");
			String color = request.getParameter("color");
			String condition = request.getParameter("condition");	
			String manufacturer = request.getParameter("manufacturer");	
			/* TABLE Shirts/Pants/Shoes */
			String clothType = request.getParameter("clothesType");	
			/* TABLE Auction */
			String clothType = request.getParameter("expirDate");	
			String clothType = request.getParameter("expirTime");	
			String clothType = request.getParameter("initPrice");	
			String clothType = request.getParameter("miniPrice");	
			String clothType = request.getParameter("clothesType");	
			String clothType = request.getParameter("increment");	
			String clothType = request.getParameter("clothesType");	
			String clothType = request.getParameter("clothesType");	
			
			
			/*  TO DO: get info and store it into clothes and isA tables....info to be used for auction */
			
	%>
</body>
</html>