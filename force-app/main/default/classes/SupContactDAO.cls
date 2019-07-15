public with sharing class SupContactDAO {

   private static final SupContactDAO instance = new SupContactDAO();    

   private SupContactDAO(){}

   public static SupContactDAO getInstance() {return instance;}

   public SupContact__c getSupContactById(String pSCttId ){
      SupContact__c sCtt;
      try { sCtt = [Select Id,Name,Email__c,Expertise__c,KeyWords__c,Phone__c,Position__c,Role__c,SupplierId__c From SupContact__c Where Id = :pSCttId limit 1]; }
      catch (Exception ex) { sCtt = new SupContact__c(); } 
      return sCtt;
   }
   
   public List<SupContact__c> getSupContactByKeyWord(String pKeyWord ){
      String sct = '%' + pKeyWord + '%';
      List<SupContact__c> lSupContactReturn = [Select Id,Name,Email__c,Expertise__c,KeyWords__c,Phone__c,Position__c,Role__c,SupplierId__c From SupContact__c Where KeyWords__c like :sct];   
      if(lSupContactReturn.isEmpty()) lSupContactReturn = new List<SupContact__c>();
      return lSupContactReturn; 
   }
   
}