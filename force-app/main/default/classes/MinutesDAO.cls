public with sharing class MinutesDAO {

   private static final MinutesDAO instance = new MinutesDAO();    

   private MinutesDAO(){}

   public static MinutesDAO getInstance() {return instance;}

   public List<Minutes__c> getMinutes(){
      List<Minutes__c> lminReturn;
      List<Minutes__c> minList = [Select Id,Name,AgendaItemId__c,AttendeeId__c,Description__c,KeyWords__c,MeetingId__c From Minutes__c]; 
      if(!minList.isEmpty()) lminReturn = minList;
      else                   lminReturn = new List<Minutes__c>();      
      return lminReturn; 
   }

   public Minutes__c getMinutesById(String pMinId ){
      Minutes__c min;
      try { min = [Select Id,Name,AgendaItemId__c,AttendeeId__c,Description__c,KeyWords__c,MeetingId__c From Minutes__c Where Id = :pMinId limit 1]; }
      catch (Exception ex) { min = new Minutes__c(); }
      return min;
   }

   public List<Minutes__c> getMinutesByKeyWord(String pKeyWord ){
      String kw = '%' + pKeyWord + '%';
      List<Minutes__c> lminReturn;
      List<Minutes__c> minList = [Select Id,Name,AgendaItemId__c,AttendeeId__c,Description__c,KeyWords__c,MeetingId__c From Minutes__c Where KeyWords__c like :kw];   
      if(!minList.isEmpty()) lminReturn = minList;
      else                   lminReturn = new List<Minutes__c>();      
      return lminReturn; 
   }
}