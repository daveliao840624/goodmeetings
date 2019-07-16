public with sharing class GMContactDAO {

   private static final GMContactDAO instance = new GMContactDAO();    

   private GMContactDAO(){}

   public static GMContactDAO getInstance() {return instance;}

   public Contact getContactById(String pContactId) {
      Contact ctt;
      try { ctt = [Select Id,FirstName,LastName,Email From Contact Where Id = :pContactId limit 1]; }
      catch (Exception ex) { ctt = new Contact(); } 
      return ctt;
   }
}