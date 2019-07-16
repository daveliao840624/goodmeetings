trigger Agenda on Agenda__c (before insert, before update, after insert, after update) {
   if (!ProcessControl.ignoredByTrigger) {
      if (Trigger.isInsert && !TriggerAgenda__c.getOrgDefaults().AfterInsert__c) return;
      if (Trigger.isUpdate && !TriggerAgenda__c.getOrgDefaults().AfterUpdate__c) return;

      if (Trigger.isBefore) {
         Subject__c sbj;
         for (Agenda__c lagd : trigger.new) {
            sbj = SubjectDAO.getInstance().getSubjectById(lagd.SubjectId__c);
            lagd.SubjectDescription__c = sbj.ConcatenatedField__c;
         }
      }
   }
}