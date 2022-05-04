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
		<style>
			table {
				border-collapse: separate; 
				border-spacing: 1em 2em;
			}
			input {
				margin: 10px;
			}
		</style>
	</head>
	<body>
		<h1> Add Item for Auction </h1>
		<form method="get" action="sell_item.jsp">
			<table>
				<tr>
					<td>Item Name</td>
					<td><input type="text" name="itemName"></td>
				</tr>
				<tr>
					<td>Color</td>
					<td><input type="text" name="color"></td>
				</tr>
				<tr>
					<td>Condition</td>
					<td><input type="text" name="condition"></td>
				</tr>
				<tr>
					<td>Manufacturer</td>
					<td><input type="text" name="manufacturer"></td>
				</tr>						
			</table>
			
			<h3>Type of Clothing:</h3>
			<select name="clothesType" id= "mySelect" onchange="clothType()">
				<option value="shirts">Shirts</option>
				<option value="pants">Pants</option>
				<option value="shoes">Shoes</option>
			</select>	
			
			<!-- we will use template to put info here -->
			<p id="templateHolder">
			</p>
						
			
			<table>
				<tr>
					<td><input type="submit" value="Submit"></td>
					<td><input type="submit" formaction="auction_page.jsp" formmethod="POST" value="Cancel"></td>
				</tr>
			</table>
		</form>
		
		
		<!-- this stays hidden, acts as a template-->
		<template id="tempShirts">
			<table>
				<tr>
					<td>Arm Length: </td>
					<td><input type="text" name="itemName"></td>
					<td>Collar Size: </td>
					<td><input type="text" name="itemName"></td>
					<td>Waist Size: </td>
					<td><input type="text" name="itemName"></td>																	
				</tr>
			</table>
		</template>	
		
		<!-- this stays hidden, acts as a template -->
		<template id="tempPants">
			<table>
				<tr>
					<td>width: </td>
					<td><input type="text" name="itemName"></td>
				</tr>
				<tr>
					<td>Length: </td>
					<td><input type="text" name="itemName"></td>
				</tr>					
			</table>
		</template>	
					
		<!-- this stays hidden, acts as a template -->			
		<template id="tempShoes">
			<table>
				<tr>
					<td>Size: </td>
					<td><input type="text" name="itemName"></td>
				</tr>
			</table>
		</template>	
		
		<!-- Javascript: calls on template & append the respective info  -->
		<script>			
			function clothType() {
				let x = document.getElementById("mySelect").value;
				let placeholder = document.getElementById('templateHolder');
				
				if (x == "shirts") {
					let temp = document.getElementsByTagName("template")[0]
					let clon = temp.content.cloneNode(true);
					placeholder.appendChild(clon);
				} else if (x == "pants") {
					let temp = document.getElementsByTagName("template")[1]
					let clon = temp.content.cloneNode(true);
					placeholder.appendChild(clon);
				} else {
					let temp = document.getElementsByTagName("template")[2]
					let clon = temp.content.cloneNode(true);
					placeholder.appendChild(clon);
				}
			}
			
		</script>

	</body>
</html>