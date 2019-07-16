trigger Meeting on Meeting__c (after insert, after update) {
   if (!ProcessControl.ignoredByTrigger) {
      if (Trigger.isInsert && !TriggerMeeting__c.getOrgDefaults().AfterInsert__c) return;
      if (Trigger.isUpdate && !TriggerMeeting__c.getOrgDefaults().AfterUpdate__c) return;

      Meeting__c newMeeting = new Meeting__c();
      for (Meeting__c lme : trigger.new) {
         if (lme.IsTemplate__c == true && String.IsNotEmpty(lme.CreatedFromMeetingId__c)) {lme.Name.addError('A meeting record can not be a Template and reference a Meeting Template at the same time!');}
         else {
            newMeeting = MeetingDAO.getInstance().getMeetingById(lme.Id);
            MeetingBO.getInstance().createMeetingFromTemplate(newMeeting);
         }
      }
   }
}