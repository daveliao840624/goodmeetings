trigger Attendee on Attendee__c (before insert, before update) {
   for (Attendee__c lat : trigger.new) {
      if ((lat.EmployeeId__c   == Null && lat.SupContactId__c == Null && lat.ContactId__c == Null && lat.InviteeId__c == Null) ||
          (lat.EmployeeId__c   != Null && lat.SupContactId__c != Null) ||
          (lat.EmployeeId__c   != Null && lat.ContactId__c    != Null) ||
          (lat.EmployeeId__c   != Null && lat.InviteeId__c    != Null) ||
          (lat.SupContactId__c != Null && lat.ContactId__c    != Null) ||
          (lat.SupContactId__c != Null && lat.InviteeId__c    != Null) ||
          (lat.ContactId__c    != Null && lat.InviteeId__c    != Null)) {
         lat.Name.addError('You should provide One and only One Id (Employee or Supplier Contact or Customer or Invitee)');
      } 
   }
}