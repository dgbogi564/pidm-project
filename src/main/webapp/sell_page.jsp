<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
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
				border: 1px solid black;
			}
			#submit {
				border: none;
			}
			input {
				margin: 10px;
			}
			textarea {
				margin: 20px 0
			}
		</style>
	</head>
	<body>
		<%
		String name = (String) session.getAttribute("name"); 
		out.print("<h1>User: " + name);
		%>
		<h1> Add Item for Auction </h1>
		<form method="get" action="sell_item.jsp">
			<table>
				<tr>
					<td>Item Name</td>
					<td><input type="text" name="itemName" required></td>
				</tr>
				<tr>
					<td>Manufacturer</td>
					<td><input type="text" name="manufacturer" required></td>
				</tr>					
				<tr>
					<td>Color</td>
					<td><input type="text" name="color" required></td>
				</tr>
				<tr>
					<td>Condition</td>
					<td><input type="text" name="condition" required></td>
				</tr>					
			</table>

			<br>
			<label>Description:</label>
			<br>
			<textarea name="description" rows="5" cols="35">Please enter your item's description here! (Max 128 characters)</textarea>
			
			<br>
			<label>Quantity: </label>
			<input type="text" name="quantity" required>
			
			<h3>Type of Clothing:</h3>
			<select name="clothesType" id= "mySelect" onchange="clothType()">
		        <option value="none" selected disabled hidden>
		          Select an Option
		      	</option>			
				<option value="shirts">Shirts</option>
				<option value="pants">Pants</option>
				<option value="shoes">Shoes</option>
			</select>	
			
			<!-- we will use template to put info here (Set start to show Shirt info) -->
			<table id="templateHolder">
			</table>			
			
			<hr>
			<table>
				<h3>Duration of Auction:</h3>
				<tr>
					<td>Expiration Date & Time: </td>
					<%
						// Get current datetime
						SimpleDateFormat date = new SimpleDateFormat("YYYY-MM-dd'T'hh:mm");
						String now = date.format((new Date()).getTime());
						System.out.println(now);
					%>
					<td><input type="datetime-local" name="expirDate" min=<%=now%> required></td>
				</tr>								
			</table>
			
			<table>
				<h3>Set Price:</h3>
				<tr>
					<td> Initial Price ($USD) </td>
					<td><input type="number" name="initPrice" min="0" step="0.01" required></td>
				</tr>
				<tr>
					<td> Hidden Minimum Price ($USD) </td>
					<td><input type="number" name="minPrice" min="0" step="0.01" required></td>
				</tr>										
			</table>
			
			<table>
				<h3>Auction Increment:</h3>
				<tr>
					<td> Increment Amount ($USD): </td>
					<td><input type="number" name="increment" min="0.01" step="0.01" required></td>
				</tr>				
			</table>
			<input type="submit" value="Add Item">
		</form>
		<form action="auction_page.jsp" method="post">
			<input type="submit" value="Return to Auction Page">
		</form>
		
		<!-- this stays hidden, acts as a template-->
		<template id="tempShirts">
			<table>
				<tr>
					<td>Arm Length (inches): </td>
					<td><input type="text" name="armLength"></td>
				</tr>
				<tr>
					<td>Collar Size (inches): </td>
					<td><input type="text" name="collarSize"></td>
				</tr>
				<tr>
					<td>Waist Size (inches): </td>
					<td><input type="text" name="waistSize"></td>
				</tr>
			</table>
		</template>	
		
		<!-- this stays hidden, acts as a template -->
		<template id="tempPants">
			<table>
				<tr>
					<td>Width (inches): </td>
					<td><input type="text" name="pantsWidth"></td>
				</tr>
				<tr>
					<td>Length (inches): </td>
					<td><input type="text" name="pantsLength"></td>
				</tr>					
			</table>
		</template>	
					
		<!-- this stays hidden, acts as a template -->			
		<template id="tempShoes">
			<table>
				<tr>
					<td>Size: </td>
					<td><input type="text" name="shoeSize"></td>
				</tr>
			</table>
		</template>	
		
		<!-- Javascript: calls on template & append the respective info  -->
		<script>			
			function clothType() {
				/* gets the selected value from the id = "mySelect" */
				let x = document.getElementById("mySelect").value;
				let placeholder = document.getElementById('templateHolder');
				/* reset placeholder inside to blank */
				placeholder.innerHTML = '';
				placeholder.setAttribute('style', 'border: none');
				
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