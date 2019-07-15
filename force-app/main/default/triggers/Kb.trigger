trigger Kb on Kb__c (before insert, before update) {
   if (Trigger.isInsert && !TriggerKb__c.getOrgDefaults().BeforeInsert__c) return;
   if (Trigger.isUpdate && !TriggerKb__c.getOrgDefaults().BeforeUpdate__c) return;
   Subject__c sub = new Subject__c();
   for (Kb__c lkb : trigger.new) {
      sub = SubjectDAO.getInstance().getSubjectById(lkb.SubjectId__c);
      lkb.SubjectDescription__c = sub.ConcatenatedField__c;
   }
}