<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta charset="UTF-8">
		<title>wishlist / alert page</title>
		<style>
			table {
				border-collapse: separate; 
				border-spacing: 1em 2em;
				border: 1px solid black;
			}
			input {
				margin: 10px;
			}

		</style>
	</head>
	<body>
		<h1> Auction of Interest (base on your alerts): </h1>
		<table id="alertTable">
			<thead>
				<tr>
					<td>Auction's Item ID</td>
					<td>Item's Name</td>
					<td>Clothes Type</td>
					<td>Color</td>
					<td>Manufacturer</td>
				<tr>
			</thead>
			<tbody>
			  <!-- data goes here -->
			</tbody>			
		</table>
		
		
		<br><br><br>
		<hr>
		<h1> Create an Alert: </h1>
		<form method="post" action="alert.jsp">
			<!-- Type of clothing -->
			<h3> Set Clothes Type: </h3>
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
		  
		  
		  	<h3> Set Clothes Details: </h3>
			<table>
				<tr>
					<td> Color </td>
					<td><input type="text" name="color"></td>		
				</tr>
				<tr>
					<td> Manufacturer </td>
					<td><input type="text" name="manufacturer"></td>		
				</tr>					
				<tr>
					<td> Specific Keywords? </td>
					<td>
						<textarea name="keywords" rows="5" cols="35">Type in Here</textarea>
					</td>		
				</tr>												
			</table>
			
			
			<h3> Set Amount Limits: </h3>
			<table>
				<tr>
					<td> Set Maximum Amount ($USD) </td>
					<td><input type="text" name="max"></td>		
				</tr>				
			</table>
		  	<br>
		  	<br>
		  	<input type="submit" value="submit" />
		  	<input type="submit" formaction="profile_page.jsp" formmethod="POST" value="Go Back">
		</form>
		
		<!--------------------------TEMPLATES--------------------------->
		<!-- this stays hidden, acts as a template-->
		<template id="tempShirts">
			<table>
				<tr>
					<td>Arm Length (inches): </td>
					<td><input type="text" name="armLength"></td>
					<td>Collar Size (inches): </td>
					<td><input type="text" name="collarSize"></td>
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
