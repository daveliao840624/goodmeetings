public with sharing class MeetingDAO {

   private static final MeetingDAO instance = new MeetingDAO();    

   private MeetingDAO(){}

   public static MeetingDAO getInstance() {return instance;}

   public List<Meeting__c> getMeeting(){
      List<Meeting__c> listMeetingReturn;
      try {listMeetingReturn = [Select DateTime__c,Description__c,Frequency__c,Id,IsTemplate__c,CreatedFromMeetingId__c,MeetingType__c,Name,ProjectId__c,Title__c,Venue__c From Meeting__c];} 
      catch (Exception ex) {listMeetingReturn = new List<Meeting__c>();}      
      return listMeetingReturn; 
   }
 
   public Meeting__c getMeetingById(String pMeeId ){
      Meeting__c meetingReturn;
      try {meetingReturn = [Select DateTime__c,Description__c,Frequency__c,Id,IsTemplate__c,CreatedFromMeetingId__c,MeetingType__c,Name,ProjectId__c,Title__c,Venue__c From Meeting__c Where Id = :pMeeId limit 1];}
      catch (Exception ex) {meetingReturn = new Meeting__c();} 
      return meetingReturn;
   }

   public List<Meeting__c> getMeetingsById(List<Meeting__c> pListMeetId ){
      List<Meeting__c> listMeetingReturn;
      try {listMeetingReturn = [Select DateTime__c,Description__c,Frequency__c,Id,IsTemplate__c,CreatedFromMeetingId__c,MeetingType__c,Name,ProjectId__c,Title__c,Venue__c From Meeting__c Where Id in :pListMeetId];}
      catch (Exception ex) {listMeetingReturn.add(new Meeting__c());} 
      return listMeetingReturn;
   }

}