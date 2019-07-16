global with sharing class DecisionBO {
   /********************************************************************************************************************
   ** Author......: Dave Liao (DL)                                                                                    **
   ** Initial Date: 06/07/2018                                                                                        **
   ** Application.: Good Meetings                                                                                     **
   ** Changes                                                                                                         **
   ** Version  When       Who  What-for                                                                               **
   ** ======== ========== ==== ====================================================================================== **
   ** V.01.001 06/07/2018 DL   Create Opportunity as Business Development Decision.                                   **
   **                                                                                                                 **
   ********************************************************************************************************************/
   private static final DecisionBO instance = new DecisionBO();    

   private DecisionBO(){}
    
   public static DecisionBO getInstance() {return instance;}
   
   public Id createOpportunityFromDecision(Decision__c pDecision) {
      Opportunity opp;
      opp = new Opportunity (Description = 'Automatically created by a Meeting Decision',
                             CloseDate = System.today(),
                             StageName = 'Prospecting',
                             Name = 'Business Development - Opportunity ===> ' + pDecision.Name,
                             IsPrivate = false,
                             Probability = 50,
                             NextStep = 'Create a work group and new project',                  
                             Type = 'New Customer');
      insert opp;                      
      return opp.Id;                    
   }
}