public with sharing class AttendeeDAO {

   private static final AttendeeDAO instance = new AttendeeDAO();    

   private AttendeeDAO(){}

   public static AttendeeDAO getInstance() {return instance;}

   public List<Attendee__c> getAttendeeByMeetingId(String pMeetingId) {
      List<Attendee__c> latdReturn;
      try { latdReturn = [Select Id,Name,AgendaId__c,ContactId__c,EmployeeId__c,HasConfirmed__c,InviteeId__c,IsTemplate__c,JoinedBy__c,KeyWords__c,MeetingId__c,SupContactId__c,StatusEmail__c From Attendee__c Where MeetingId__c = :pMeetingId and AgendaId__c = null]; }
      catch (Exception ex) { latdReturn = new List<Attendee__c>(); }
      return latdReturn; 
   }

   public List<Attendee__c> getAttendeeByTemplateId(String pMeetingId) {
      List<Attendee__c> latdReturn;
      try { latdReturn = [Select Id,Name,AgendaId__c,ContactId__c,EmployeeId__c,HasConfirmed__c,InviteeId__c,IsTemplate__c,JoinedBy__c,KeyWords__c,MeetingId__c,SupContactId__c,StatusEmail__c From Attendee__c Where MeetingId__c = :pMeetingId And IsTemplate__c = True]; }
      catch (Exception ex) { latdReturn = new List<Attendee__c>(); }
      return latdReturn; 
   }

   public Attendee__c getAttendeeById(String pAtdId ){
      Attendee__c atd;
      try { atd = [Select Id,Name,ContactId__c,AgendaId__c,EmployeeId__c,HasConfirmed__c,InviteeId__c,IsTemplate__c,JoinedBy__c,KeyWords__c,MeetingId__c,SupContactId__c,StatusEmail__c From Attendee__c Where Id = :pAtdId limit 1]; }
      catch (Exception ex) { atd = new Attendee__c(); } 
      return atd;
   }
   
   public Attendee__c getAttendeeByEmployeeId(String pAgendaId,String pEmployeeId ){
      Attendee__c atd;
      try { atd = [Select Id,Name,ContactId__c,AgendaId__c,EmployeeId__c,HasConfirmed__c,InviteeId__c,IsTemplate__c,JoinedBy__c,KeyWords__c,MeetingId__c,SupContactId__c,StatusEmail__c From Attendee__c Where AgendaId__c = :pAgendaId and EmployeeId__c = :pEmployeeId limit 1]; }
      catch (Exception ex) { atd = new Attendee__c(); } 
      return atd;
   }

   public Attendee__c getAttendeeByInviteeId(String pAgendaId,String pInviteeId ){
      Attendee__c atd;
      try { atd = [Select Id,Name,ContactId__c,AgendaId__c,EmployeeId__c,HasConfirmed__c,InviteeId__c,IsTemplate__c,JoinedBy__c,KeyWords__c,MeetingId__c,SupContactId__c,StatusEmail__c From Attendee__c Where AgendaId__c = :pAgendaId and InviteeId__c = :pInviteeId limit 1]; }
      catch (Exception ex) { atd = new Attendee__c(); } 
      return atd;
   }

   public Attendee__c getAttendeeByContactId(String pAgendaId,String pContactId ){
      Attendee__c atd;
      try { atd = [Select Id,Name,ContactId__c,AgendaId__c,EmployeeId__c,HasConfirmed__c,InviteeId__c,IsTemplate__c,JoinedBy__c,KeyWords__c,MeetingId__c,SupContactId__c,StatusEmail__c From Attendee__c Where AgendaId__c = :pAgendaId and ContactId__c = :pContactId limit 1]; }
      catch (Exception ex) { atd = new Attendee__c(); } 
      return atd;
   }

   public Attendee__c getAttendeeBySupContactId(String pAgendaId,String pSupContactId ){
      Attendee__c atd;
      try { atd = [Select Id,Name,ContactId__c,AgendaId__c,EmployeeId__c,HasConfirmed__c,InviteeId__c,IsTemplate__c,JoinedBy__c,KeyWords__c,MeetingId__c,SupContactId__c,StatusEmail__c From Attendee__c Where AgendaId__c = :pAgendaId and ContactId__c = :pSupContactId limit 1]; }
      catch (Exception ex) { atd = new Attendee__c(); } 
      return atd;
   }

   public List<Attendee__c> getAttendeeByAgenda(String pAgendaId) {
      List<Attendee__c> latdReturn; 
      try { latdReturn = [Select Id,Name,ContactId__c,AgendaId__c,EmployeeId__c,HasConfirmed__c,InviteeId__c,IsTemplate__c,JoinedBy__c,KeyWords__c,MeetingId__c,SupContactId__c,StatusEmail__c From Attendee__c Where AgendaId__c = :pAgendaId]; } 
      catch (Exception ex) { latdReturn = new List<Attendee__c>(); }      
      return latdReturn; 
   }
   
   public String getNewAttendeeIdByAttTptId(String pMtgId, String pAttId ){ //Get New Attendee Id by Attendee Template Id
      String attIdReturn;
      Attendee__c att = new Attendee__c();
      try {
      	 att = [Select Id 
      	          From Attendee__c
      	         Where MeetingId__c = :pMtgid
      	           and CreatedFromAttendeeId__c = :pAttId limit 1];
      	 attIdReturn = att.Id;    
      }
      catch (Exception ex) {attIdReturn = Null;} 
      return attIdReturn;
   }
   
    public List<Attendee__c> getAttendeeWithoutMail(String pMeetingId) {
      List<Attendee__c> latdReturn;
      try { latdReturn = [Select Id,Name,AgendaId__c,ContactId__c,EmployeeId__c,HasConfirmed__c,InviteeId__c,IsTemplate__c,JoinedBy__c,KeyWords__c,MeetingId__c,SupContactId__c,StatusEmail__c From Attendee__c Where MeetingId__c = :pMeetingId and StatusEmail__c != 'Sent']; }
      catch (Exception ex) { latdReturn = new List<Attendee__c>(); }
      return latdReturn; 
   }
}