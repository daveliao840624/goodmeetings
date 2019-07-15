public with sharing class KbDAO {

   private static final KbDAO instance = new KbDAO();    

   private KbDAO(){}

   public static KbDAO getInstance() {return instance;}

   public List<Kb__c> getKb(){
      List<Kb__c> lkbaseReturn;
      List<Kb__c> kbaseList = [Select Id,Name,KOut__c,KeyWords__c,LessonLearned__c,MinutesId__c,SubjectDescription__c,SubjectId__c,Title__c From Kb__c]; 
      if(!kbaseList.isEmpty()) lkbaseReturn = kbaseList;
      else                   lkbaseReturn = new List<Kb__c>();      
      return lkbaseReturn; 
   }

   public Kb__c getKbById(String pKbId ){
      Kb__c kbase;
      try { kbase = [Select Id,Name,KOut__c,KeyWords__c,LessonLearned__c,MinutesId__c,SubjectDescription__c,SubjectId__c,Title__c From Kb__c Where Id = :pKbId limit 1]; }
      catch (Exception ex) { kbase = new Kb__c(); } 
      return kbase;
   }

   public Kb__c getKbByMinutesId(String pMinId ){
      Kb__c kbase;
      try { kbase = [Select Id,Name,KOut__c,KeyWords__c,LessonLearned__c,MinutesId__c,SubjectDescription__c,SubjectId__c,Title__c From Kb__c Where MinutesId__c = :pMinId limit 1]; }
      catch (Exception ex) { kbase = new Kb__c(); }
      return kbase;
   }

   public List<Kb__c> getKbByKeyWord(String pKeyWord ){
      String kw = '%' + pKeyWord + '%';
      List<Kb__c> lkbaseReturn;
      List<Kb__c> kbaseList = [Select Id,Name,KOut__c,KeyWords__c,LessonLearned__c,MinutesId__c,SubjectDescription__c,SubjectId__c,Title__c From Kb__c Where KeyWords__c like :kw];   
      if(!kbaseList.isEmpty()) lkbaseReturn = kbaseList;
      else                   lkbaseReturn = new List<Kb__c>();      
      return lkbaseReturn; 
   }
}