public with sharing class AgendaDAO {

   private static final AgendaDAO instance = new AgendaDAO();    

   private AgendaDAO(){}

   public static AgendaDAO getInstance() {return instance;}

   public List<Agenda__c> getAgenda(){
      List<Agenda__c> lagdReturn;
      List<Agenda__c> agdList = [Select Id,IsTemplate__c,KInId__c,KeyWords__c,MeetingId__c,Name,SubjectDescription__c,SubjectId__c From Agenda__c]; 
      if(!agdList.isEmpty()) lagdReturn = agdList;
      else                   lagdReturn = new List<Agenda__c>();      
      return lagdReturn; 
   }

   public List<Agenda__c> getAgendaByTemplateId(String pMeetingId){
      List<Agenda__c> lagdReturn;
      List<Agenda__c> agdList = [Select Id,IsTemplate__c,KInId__c,KeyWords__c,MeetingId__c,Name,SubjectDescription__c,SubjectId__c From Agenda__c Where MeetingId__c = :pMeetingId And IsTemplate__c = True]; 
      if(!agdList.isEmpty()) lagdReturn = agdList;
      else                   lagdReturn = new List<Agenda__c>();      
      return lagdReturn; 
   }

   public Agenda__c getAgendaById(String pAgdId ){
      Agenda__c agd;
      try { agd = [Select Id,IsTemplate__c,KInId__c,KeyWords__c,MeetingId__c,Name,SubjectDescription__c,SubjectId__c From Agenda__c Where Id = :pAgdId limit 1]; }
      catch (Exception ex) { agd = new Agenda__c(); } 
      return agd;
   }

   public String getNewAgendaIdByAgdTptId(String pMtgId, String pAgdId ){ //Get New Agenda Id by Agenda Template Id
      String agdIdReturn;
      Agenda__c agd = new Agenda__c();
      try {
      	 agd = [Select Id 
      	          From Agenda__c
      	         Where MeetingId__c = :pMtgId 
      	           and CreatedFromAgendaId__c = :pAgdId limit 1];
      	 agdIdReturn = agd.Id;    
      }
      catch (Exception ex) {agdIdReturn = Null;} 
      return agdIdReturn;
   }
}