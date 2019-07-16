public with sharing class InviteeDAO {

   private static final InviteeDAO instance = new InviteeDAO();    

   private InviteeDAO(){}

   public static InviteeDAO getInstance() {return instance;}

   public List<Invitee__c> getInvitee(){
      List<Invitee__c> linvReturn = [Select Id,Name,Expertise__c,KeyWords__c,Title__c,Email__c,MobilePhone__c From Invitee__c]; 
      if(linvReturn.isEmpty()) linvReturn = new List<Invitee__c>();      
      return linvReturn;
   }

   public Invitee__c getInviteeById(String pInviteeId ){
      Invitee__c inv;
      try { inv = [Select Id,Name,Expertise__c,KeyWords__c,Title__c,Email__c,MobilePhone__c From Invitee__c Where Id = :pInviteeId limit 1]; }
      catch (Exception ex) { inv = new Invitee__c(); }
      return inv;
   }
   
   public List<Invitee__c> getInviteeByKeyWord(String pKeyWord ){
      String inv = '%' + pKeyWord + '%';
      List<Invitee__c> lInviteeReturn = [Select Id,Name,Expertise__c,KeyWords__c,Title__c,Email__c,MobilePhone__c From Invitee__c Where KeyWords__c like :inv];   
      if(lInviteeReturn.isEmpty()) lInviteeReturn = new List<Invitee__c>();      
      return lInviteeReturn; 
   }
}