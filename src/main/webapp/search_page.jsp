<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="UTF-8">
<title>search</title>
	<style>
		#filterTable, thead, .header, .data {
			border: 1px solid black;
			border-collapse: collapse;
			text-align: center;
		}
		#filterTable {
			width: 100%;
		}
	</style>	
</head>
	<body>
		<h1> Search/Filter for Specific Auction </h1>
		<table id="filterTable">
			<thead>
				<tr>
					<th class="header">Title</th>
					<th class="header">Item ID</th>
					<th class="header">Color</th>
					<th class="header">Condition</th>
					<th class="header">Manufacturer</th>
					<th class="header">Highest Bid</th>			
				<tr>
			</thead>
			<tbody>
			  <!-- data goes here -->
			  <%
				Connection con = null;
				try {
					//Get the database connection
					ApplicationDB db = new ApplicationDB();
					con = db.getConnection();
				
					//Create a SQL statement
					Statement stmt = con.createStatement();
					ResultSet result;
					
					
					//This retrieve the set(itemIdList) from session search.jsp IF session EXISTS...
					if(session.getAttribute("itemIdList") != null) {
						ArrayList<Integer> itemIdList = (ArrayList<Integer>) session.getAttribute("itemIdList");
						
						//remove duplicates from arrayList(itemId) 
						Set<Integer> itemIdSet = new LinkedHashSet<Integer>(itemIdList);  
						String getAuctionTable = "";
						
						for(int itemIds : itemIdSet) {
							getAuctionTable = "SELECT a.title, a.itemId, c.color, c.condition, c.manufacturer,"
									+ "a.highestBid FROM Auction a, Clothes c WHERE a.itemId = c.itemId"
									+ " and a.itemId = '" + itemIds + "'";
							result = stmt.executeQuery(getAuctionTable);
							// Iterate through ResultSet and add to table
							while (result.next()) {
								String title = result.getString(1);
								int id = result.getInt(2);
								String color = result.getString(3);
								String condition = result.getString(4);
								String manufacturer = result.getString(5);
								double highestBid = result.getFloat(6);
						
								out.print("<tr>");
								out.print("<td class='data'>" + title + "</td>"); // could just make this an html link
								out.print("<td class='data'>" + id + "</td>");
								out.print("<td class='data'>" + color + "</td>");
								out.print("<td class='data'>" + condition + "</td>");
								out.print("<td class='data'>" + manufacturer + "</td>");
								out.print("<td class='data'>" + (highestBid == 0 ? "None" : highestBid) + "</td>");
								out.print("<td>" + "</td>"); // IMPLEMENT SEE INFO HERE
								out.print("</tr>");
							}
						}
					}
					
				} catch (Exception ex) {
					out.print(ex);
					ex.printStackTrace();
					out.print("<br>");
					out.print("<br>");
					out.print("Failed to display search/filter.");
					out.print("<br>");
					out.print("<br>");
					out.print("<form method=\"post\" action=\"auction_page.jsp\">\n\t\t\t<input type=\"submit\" value=\"Go back to Auction page\" />\n\t\t</form>");
				}			  
			  %>
			</tbody>			
		</table>
		
		
		
		
		<br><br><br>
		<hr>
		<h1> Filter: </h1>
		<form method="post" action="search.jsp">
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
		  
		  	<hr>
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
					<td> Specific Keywords </td>
					<td>
						<textarea name="keywords" rows="5" cols="35">Type in Here</textarea>
					</td>		
				</tr>												
			</table>
			
			<hr>
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
		  	<input type="submit" formaction="auction_page.jsp" formmethod="POST" value="Go Back">
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