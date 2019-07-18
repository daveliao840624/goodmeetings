trigger Decision on Decision__c (after insert, after update, before delete) {
   if (!ProcessControl.ignoredByTrigger) {
      if (Trigger.isInsert && !TriggerDecision__c.getOrgDefaults().AfterInsert__c) return;
      if (Trigger.isUpdate && !TriggerDecision__c.getOrgDefaults().AfterUpdate__c) return;
      if (Trigger.isDelete && !TriggerDecision__c.getOrgDefaults().BeforeDelete__c) return;

      System.debug('Inicio');
      
      if (!Trigger.isDelete) {
         Id OppId;
         Decision__c updDec = new Decision__c();   
         for (Decision__c ldec : trigger.new) {
            updDec = DecisionDAO.getInstance().getDecisionById(ldec.Id);
            if(ldec.Action__c.contains('Business Development - Opportunity') && ldec.OpportunityId__c == Null) {
               OppId = DecisionBO.getInstance().createOpportunityFromDecision(updDec);
               updDec.OpportunityId__c = OppId;
               updDec.LinkName__c = 'Business Development - Opportunity ===> ' + ldec.Name; 
               updDec.Url__c = System.URL.getSalesforceBaseURL().toExternalForm() + '/' + OppId;
               
               ProcessControl.ignoredByTrigger = True;
               update updDec;
            }
            if(!ldec.Action__c.contains('Business Development - Opportunity') && ldec.OpportunityId__c != Null) {
               Delete[Select Id from Opportunity Where Id = :ldec.OpportunityId__c Limit 1];
               updDec.OpportunityId__c = Null;
               updDec.LinkName__c = Null; 
               updDec.Url__c = Null;
               update updDec;
            }
         }
      }
      else {
         for (Decision__c ldec : trigger.old) {
            if(!ldec.Action__c.contains('Business Development - Opportunity') && ldec.OpportunityId__c != Null) {
               Delete[Select Id from Opportunity Where Id = :ldec.OpportunityId__c Limit 1];
            }
         }
      }
   }
}