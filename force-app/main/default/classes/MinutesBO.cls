public with sharing class MinutesBO {

   private static final MinutesBO instance = new MinutesBO();    

   private MinutesBO(){}
    
   public static MinutesBO getInstance() { return instance; }

   public void recordKb( List<Minutes__c> pminutes ) { /* Records Kb from Minutes */
      EventLog__c      evtlog = new EventLog__c();
      Minutes__c          min = new Minutes__c();
      List<Minutes__c> updmin = new List<Minutes__c>();  
      Kb__c                kb = new Kb__c();

      try {
         for (Minutes__c lminutes:pminutes) {
            if (lminutes.RecordKb__c == true) { 
               kb  = KbDAO.getInstance().getKbByMinutesId(lminutes.Id);
               if (kb.Id == null) {
                  kb = new Kb__c(
                     KeyWords__c  = lminutes.KeyWords__c,
                     KOut__c      = lminutes.Description__c, LessonLearned__c = Null,
                     MinutesId__c = lminutes.Id,             SubjectId__c     = Null,
                     Title__c     = lminutes.Name);
                  insert kb;   
               }
               min = MinutesDAO.getInstance().getMinutesById(lminutes.Id);
               min.KbRecorded__c = True;
               updmin.add(min); 
            }
         }
         ProcessControl.ignoredByTrigger = True;
         if (updmin.size() > 0) update updmin;
      }
      catch( Exception ex ) {
         evtlog = new EventLog__c(DateTime__c = System.now(), Process__c = 'MinutesBO', Type__c = 'Error',Description__c = '>>> ERROR: ' + ex.getMessage() + ' / ' + ex.getTypeName());
         insert evtlog;
      }          
   }
}