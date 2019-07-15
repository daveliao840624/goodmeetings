public with sharing class DecisionDAO {

   private static final DecisionDAO instance = new DecisionDAO();    

   private DecisionDAO(){}

   public static DecisionDAO getInstance() {return instance;}

   public List<Decision__c> getDecision(){
      List<Decision__c> ldecReturn;
      List<Decision__c> decList = [Select Id,Name,Action__c,ActionStatus__c,AttendeeId__c,Description__c,DueDate__c,MeetingId__c,MinutesId__c,LinkName__c,Url__c,ConnectedField__c,OpportunityId__c From Decision__c]; 
      if(!decList.isEmpty()) ldecReturn = decList;
      else                   ldecReturn = new List<Decision__c>();      
      return ldecReturn; 
   }

   public Decision__c getDecisionById(String pDecId ){
      Decision__c dec;
      try { dec = [Select Id,Name,Action__c,ActionStatus__c,AttendeeId__c,Description__c,DueDate__c,MeetingId__c,MinutesId__c,LinkName__c,Url__c,ConnectedField__c,OpportunityId__c From Decision__c Where Id = :pDecId limit 1]; }
      catch (Exception ex) { dec =  new Decision__c(); } 
      return dec;
   }
}