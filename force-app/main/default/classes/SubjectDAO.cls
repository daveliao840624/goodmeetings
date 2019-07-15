public with sharing class SubjectDAO {

   private static final SubjectDAO instance = new SubjectDAO();    

   private SubjectDAO(){}

   public static SubjectDAO getInstance() {return instance;}

   public List<Subject__c> getSubject(){
      List<Subject__c> lsbjReturn;
      List<Subject__c> sbjList = [Select Id, Name, KnowledgeArea__c, Skill__c, Description__c, ConcatenatedField__c, SearchString__c From Subject__c]; 
      if(!sbjList.isEmpty()) lsbjReturn = sbjList;
      else                   lsbjReturn = new List<Subject__c>();      
      return lsbjReturn; 
   }

   public Subject__c getSubjectById(String pSbjId ){
      Subject__c sbj;
      try { sbj = [Select Id, Name, KnowledgeArea__c, Skill__c, Description__c, ConcatenatedField__c, SearchString__c From Subject__c Where Id = :pSbjId limit 1]; }
      catch (Exception ex) { sbj = new Subject__c(); } 
      return sbj;
   }
   
   public Subject__c getSubjectByName(String pSbjName ){
      Subject__c sbj;
      try { sbj = [Select Id, Name, KnowledgeArea__c, Skill__c, Description__c, ConcatenatedField__c, SearchString__c From Subject__c Where Name = :pSbjName limit 1]; }
      catch (Exception ex) { sbj = new Subject__c(); } 
      return sbj;
   }
}