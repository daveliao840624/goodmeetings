public with sharing class ConnectionDAO {

   private static final ConnectionDAO instance = new ConnectionDAO();    

   private ConnectionDAO(){}

   public static ConnectionDAO getInstance() {return instance;}

   public List<Connection__c> getConnectionOfPerson(String pAgendaId){
      List<Connection__c> lconnReturn;
      List<Connection__c> connList = [Select Id,Name,AgendaId__c,ConnectedField__c,ContactId__c,EmployeeId__c,InviteeId__c,KeyWords__c,LinkName__c,SupContactId__c,Url__c
                                        From Connection__c
                                       Where AgendaId__c = :pAgendaId
                                         and (EmployeeId__c   != null or EmployeeId__c   != '' or
                                              InviteeId__c    != Null or InviteeId__c    != '' or
                                              ContactId__c    != Null or ContactId__c    != '' or
                                              SupContactId__c != Null or SupContactId__c != '')];
      if(!connList.isEmpty()) lconnReturn = connList;
      else                    lconnReturn = new List<Connection__c>();      
      return lconnReturn; 
   }
}