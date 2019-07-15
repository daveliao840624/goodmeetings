public with sharing class EmployeeDAO {

   private static final EmployeeDAO instance = new EmployeeDAO();    

   private EmployeeDAO(){}

   public static EmployeeDAO getInstance() {return instance;}

   public List<Employee__c> getEmployee(){
      List<Employee__c> lempReturn;
      List<Employee__c> empList = [Select Id,Name,Email__c,EmployeeId__c,Phone__c,Position__c,Role__c From Employee__c]; 
      if(!empList.isEmpty()) lempReturn = empList;
      else                   lempReturn = new List<Employee__c>();      
      return lempReturn;
   }

   public Employee__c getEmployeeById(String pEmployeeId ){
      Employee__c emp;
      try { emp = [Select Id,Name,Email__c,EmployeeId__c,Phone__c,Position__c,Role__c From Employee__c Where Id = :pEmployeeId limit 1]; }
      catch (Exception ex) { emp = new Employee__c(); }
      return emp;
   }
}