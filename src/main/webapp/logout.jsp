<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Logout</title>
	</head>
	<body>
		<%
			session.invalidate();
			response.sendRedirect("login_page.jsp");
		%>
	</body>
</html>