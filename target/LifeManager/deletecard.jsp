<%@ page import="java.sql.*" %>

<%

String cardId = request.getParameter("card_id");

Connection con = null;
PreparedStatement ps = null;

try{

Class.forName("com.mysql.cj.jdbc.Driver");

con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/lifemanager",
"root",
"april"
);

String sql="DELETE FROM cards WHERE cards_id=?";

ps = con.prepareStatement(sql);

ps.setInt(1,Integer.parseInt(cardId));

ps.executeUpdate();

response.sendRedirect("cards.jsp");

}catch(Exception e){
e.printStackTrace();
}

%>