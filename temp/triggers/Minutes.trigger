trigger Minutes on Minutes__c (after insert, after update) {
   if (!ProcessControl.ignoredByTrigger) {
      if (Trigger.isInsert && !TriggerMinutes__c.getOrgDefaults().AfterInsert__c) return;
      if (Trigger.isUpdate && !TriggerMinutes__c.getOrgDefaults().AfterUpdate__c) return;
      MinutesBO.getInstance().recordKb( trigger.new );
   }
}