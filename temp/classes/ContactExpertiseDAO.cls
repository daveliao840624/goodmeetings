public with sharing class ContactExpertiseDAO {

   private static final ContactExpertiseDAO instance = new ContactExpertiseDAO();    

   private ContactExpertiseDAO(){}

   public static ContactExpertiseDAO getInstance() {return instance;}

   public ContactExpertise__c getContactExpertiseById(String pCttsId ){
      ContactExpertise__c ctts;
      try { ctts = [Select Id,Name,Expertise__c,KeyWords__c From ContactExpertise__c Where Id = :pCttsId limit 1]; }
      catch (Exception ex) { ctts = new ContactExpertise__c(); } 
      return ctts;
   }
   
   public List<ContactExpertise__c> getContactExpertiseByKeyWord(String pKeyWord ){
      String sct = '%' + pKeyWord + '%';
      List<ContactExpertise__c> lContactExpertiseReturn = [Select Id,ContactId__c,ContactId__r.FirstName,ContactId__r.LastName,Expertise__c,KeyWords__c From ContactExpertise__c Where KeyWords__c like :sct];   
      if(lContactExpertiseReturn.isEmpty()) lContactExpertiseReturn = new List<ContactExpertise__c>();
      return lContactExpertiseReturn; 
   }
}