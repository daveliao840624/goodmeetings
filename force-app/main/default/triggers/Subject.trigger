trigger Subject on Subject__c (before insert, before update) {
   if (Trigger.isInsert && !TriggerSubject__c.getOrgDefaults().BeforeInsert__c) return;
   if (Trigger.isUpdate && !TriggerSubject__c.getOrgDefaults().BeforeUpdate__c) return;
   for (Subject__c lsub : trigger.new) {lsub.ConcatenatedField__c = lsub.KnowledgeArea__c + '=>' + lsub.Skill__c + '=>' + lsub.Description__c;}
}