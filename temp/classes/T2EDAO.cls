public with sharing class T2EDAO {

   private static final T2EDAO instance = new T2EDAO();    

   private T2EDAO(){}

   public static T2EDAO getInstance() {return instance;}

   public List<T2E__c> getT2E(){
      List<T2E__c> lt2eReturn;
      List<T2E__c> t2eList = [Select Id,Name,Description__c,EmployeeId__c,KeyWords__c,KnowledgeArea__c,Title__c From T2E__c]; 
      if(!t2eList.isEmpty()) lt2eReturn = t2eList;
      else                   lt2eReturn = new List<T2E__c>();      
      return lt2eReturn;
   }

   public T2E__c getT2EById(String pT2EId ){
      T2E__c t2e;
      try { t2e = [Select Id,Name,Description__c,EmployeeId__c,KeyWords__c,KnowledgeArea__c,Title__c From T2E__c Where Id = :pT2EId limit 1]; }
      catch (Exception ex) { t2e = new T2E__c(); }
      return t2e;
   }

   public List<T2E__c> getT2EByKeyWord(String pKeyWord ){
      String kw = '%' + pKeyWord + '%';
      List<T2E__c> lt2eReturn;
      List<T2E__c> t2eList = [Select Id,Name,Description__c,EmployeeId__c,KeyWords__c,KnowledgeArea__c,Title__c From T2E__c Where KeyWords__c like :kw];   
      if(!t2eList.isEmpty()) lt2eReturn = t2eList;
      else                   lt2eReturn = new List<T2E__c>();      
      return lt2eReturn; 
   }
}