global with sharing class AgendaBO {
   /********************************************************************************************************************
   ** Author......: Dave Liao (DL)                                                                                    **
   ** Initial Date: 26/09/2017                                                                                        **
   ** Application.: Good Meetings                                                                                     **
   ** Changes                                                                                                         **
   ** Version  When       Who  What-for                                                                               **
   ** ======== ========== ==== ====================================================================================== **
   ** V.01.001 26/09/2017 DL   Connects Agenda items to Employees (T2E), Minutes items, Kbase.                        **
   ** V.02.001 ??/10/2017 DL   Generates participants automatically from connections.                                 **
   ** V.02.002 04/04/2018 DL   Review code and insert Invitees as connection.                                         **
   ** V.02.003 28/05/2018 DL   Remove Singleton mode                                                                  **
   ** V.02.004 31/05/2018 DL   Insert Supplier Contact and Customer(CRM) as connections and participants (Attendees). **
   **                                                                                                                 **
   ********************************************************************************************************************/
   // Identifing if person account is enabled in a sfdc org ===> Schema.sObjectType.Account.fields.getMap().containsKey( 'isPersonAccount' )         
   webservice static String connAgd( String pAgendaId ) {
      String                lReturn = ''; 
      Agenda__c                 agd = AgendaDAO.getInstance().getAgendaById(pAgendaId); 
      List<String>              lkw = new List<String>();  // List Key-Word
      List<Minutes__c>          min = new List<Minutes__c>();
      List<Kb__c>                kb = new List<Kb__c>();
      List<T2E__c>              t2e = new List<T2E__c>();
      List<Invitee__c>          inv = new List<Invitee__c>();
      List<SupContact__c>       sct = new List<SupContact__c>();
      List<ContactExpertise__c> cex = new List<ContactExpertise__c>();
      List<Connection__c>      conn = new List<Connection__c>();
      Map<Id,Integer>        connId = new Map<Id,Integer>();
      Connection__c        connWork = new Connection__c();
      Employee__c               emp = new Employee__c();
      String                  title = '';
      Integer             connCount = 0;
      Integer             connIndex = 0;
      
      if (String.isEmpty(agd.keywords__c)) { lReturn = 'It is not possible to create connections because Key-Words field is empty!';}
      else {
         try {
            Delete [Select Id from Connection__c Where AgendaId__c = :pAgendaId];
            lkw.clear();
            lkw = getToken(agd.KeyWords__c);

            for (String ls:lkw){
               t2e = T2EDAO.getInstance().getT2EByKeyWord(ls);
               if (t2e.size() > 0) {
                  for (T2E__c lt2e:t2e) {
                     if(!connId.containsKey(lt2e.EmployeeId__c)) {
                     	connId.put(lt2e.EmployeeId__c,conn.size());
                        emp = EmployeeDAO.getInstance().getEmployeeById(lt2e.EmployeeId__c);
                        conn.add(new Connection__c(Name = 'Tacit2Explicit', AgendaId__c = agd.Id, EmployeeId__c = lt2e.EmployeeId__c, KeyWords__c = ls, Url__c = System.URL.getSalesforceBaseURL().toExternalForm() + '/' + lt2e.Id, LinkName__c = emp.Name + '-' + lt2e.KnowledgeArea__c + '-' + lt2e.Title__c));
                        connCount += 1;
                     }
                     else {
                     	connIndex = connId.get(lt2e.EmployeeId__c);
                        connWork = conn.get(connIndex);
                        connWork.KeyWords__c += ';'+ls;
                        conn.set(connIndex,connWork);
                     }
               }  }
               min = MinutesDAO.getInstance().getMinutesByKeyWord(ls);
               if (min.size() > 0) {
                  for (Minutes__c lmin:min) {
                     ProcessControl.ignoredByTrigger = true;
                     title = MeetingDAO.getInstance().getMeetingById(lmin.MeetingId__c).Title__c;
                     conn.add(new Connection__c(Name = 'Minutes', AgendaId__c = agd.Id, KeyWords__c = ls, Url__c = System.URL.getSalesforceBaseURL().toExternalForm() + '/' + lmin.Id, LinkName__c = title + '-' + lmin.Name ));
                     connCount += 1;
               }  }
               kb = KbDAO.getInstance().getKbByKeyWord(ls);
               if (kb.size() > 0) {
                  for (Kb__c lkb:kb) {
                     ProcessControl.ignoredByTrigger = true;
                     conn.add(new Connection__c(Name = 'Knowledge Base', AgendaId__c = agd.Id, KeyWords__c = ls, Url__c = System.URL.getSalesforceBaseURL().toExternalForm() + '/' + lkb.Id, LinkName__c = lkb.SubjectDescription__c + '-' + lkb.Title__c ));
                     connCount += 1;
               }  }
               inv = InviteeDAO.getInstance().getInviteeByKeyWord(ls);
               if (inv.size() > 0) {
                  for (Invitee__c linv:inv) {
                     if(!connId.containsKey(linv.Id)) {
                     	connId.put(linv.Id,conn.size());
                        conn.add(new Connection__c(Name = 'Invitee', AgendaId__c = agd.Id, InviteeId__c = linv.Id, KeyWords__c = ls, Url__c = System.URL.getSalesforceBaseURL().toExternalForm() + '/' + linv.Id, LinkName__c = linv.Title__c  + ' ' + linv.Name + ' - ' + linv.Expertise__c));
                        connCount += 1;
                     }
                     else {
                     	connIndex = connId.get(linv.Id);
                        connWork = conn.get(connIndex);
                        connWork.KeyWords__c += ';'+ls;
                        conn.set(connIndex,connWork);
                     }
               }  }               
               sct = SupContactDAO.getInstance().getSupContactByKeyWord(ls);
               if (sct.size() > 0) {
                  for (SupContact__c lsct:sct) {
                     if(!connId.containsKey(lsct.Id)) {
                     	connId.put(lsct.Id,conn.size());
                        conn.add(new Connection__c(Name = 'SupContact', AgendaId__c = agd.Id, SupContactId__c = lsct.Id, KeyWords__c = ls, Url__c = System.URL.getSalesforceBaseURL().toExternalForm() + '/' + lsct.Id, LinkName__c = lsct.Name + ' - ' + lsct.Expertise__c));
                        connCount += 1;
                        System.debug('Insert SupContact ==> Index: ' + connId.get(lsct.Id) + ' Id: ' + lsct.Id + ' Name: ' + lsct.Name + ' KeyWords: ' + ls );
                     }
                     else {
                     	connIndex = connId.get(lsct.Id);
                        connWork = conn.get(connIndex);
                        connWork.KeyWords__c += ';'+ls;
                        conn.set(connIndex,connWork);
                        System.debug('Update SupContact ==> Index: ' + connIndex + ' Id: ' + lsct.Id + ' Name: ' + lsct.Name + ' KeyWords: ' + connWork.KeyWords__c);
                     }
               }  }
               cex = ContactExpertiseDAO.getInstance().getContactExpertiseByKeyWord(ls);
               if (cex.size() > 0) {
                  for (ContactExpertise__c lcex:cex) {
                     if(!connId.containsKey(lcex.ContactId__c)) {
                     	connId.put(lcex.ContactId__c,conn.size());
                        conn.add(new Connection__c(Name = 'Contact', AgendaId__c = agd.Id, ContactId__c = lcex.ContactId__c, KeyWords__c = ls, Url__c = System.URL.getSalesforceBaseURL().toExternalForm() + '/' + lcex.Id, LinkName__c = lcex.ContactId__r.FirstName + lcex.ContactId__r.LastName + ' ===> ' + lcex.Expertise__c));
                        connCount += 1;
                     }
                     else {
                     	connIndex = connId.get(lcex.ContactId__c);
                        connWork = conn.get(connIndex);
                        connWork.KeyWords__c += ';'+ls;
                        conn.set(connIndex,connWork);
                     }
            }  }  }

            insert conn;

            if (connCount < 2) { lReturn = connCount.format() + ' Connection created!'; }
            else { lReturn = connCount.format() + ' Connection(s) created!'; }
         }
         catch( Exception ex ) {insert new EventLog__c(DateTime__c = System.now(), Process__c = 'AgendaBO.connAgd()', Type__c = 'Error',Description__c = '>>> ERROR: ' + ex.getMessage() + ' / ' + ex.getStackTraceString());}
      }          
      return lReturn;
   }

   public static List<String> getToken (String pString) {
      List <String> ls = new List<String>();
      String s1 = '';
      for (Integer i = 0; i < pString.length(); i++) {
         if (pString.substring(i,i+1) == ';') {
            s1 = s1.toLowerCase().trim();
            ls.add(s1);
            s1 = '';
            continue;
         }
         s1 = s1 + pString.substring(i,i+1);
      }
      if (s1.length() > 0) ls.add(s1.toLowerCase().trim());
      return ls;
   }
   
   webservice static String joinAtendee(String pAgendaId) {
      Agenda__c            agd = AgendaDAO.getInstance().getAgendaById(pAgendaId);
      List<Attendee__c>    att = AttendeeDAO.getInstance().getAttendeeByAgenda(pAgendaId);
      List<Attendee__c>    atd = AttendeeDAO.getInstance().getAttendeeByMeetingId(agd.MeetingId__c);
      List<Attendee__c> delAtt = new List<Attendee__c>();
      List<Attendee__c> updAtt = new List<Attendee__c>();
      List<Attendee__c> insAtt = new List<Attendee__c>();
      List<Connection__c>  con = ConnectionDAO.getInstance().getConnectionOfPerson(pAgendaId);
      Invitee__c           inv;
      SupContact__c        sct;
      Contact              ctt;
      String          joinedBy = '';
      String          keywords = '';  
      String         resultado = '';
      Boolean        createAtd;
      
      try {
         // delete automatic Attendee for this meeting
         System.debug('Antes delete  ===> ' + pAgendaId + ' att.size ===> ' + att.size());
         for (Attendee__c latt:att) {
            System.debug('Joined By ===> ' + latt.JoinedBy__c);
            if (latt.JoinedBy__c == 'Both') {
               latt.JoinedBy__c = 'Organizer';
               System.debug('Update ===> '+latt.EmployeeId__c + ' x ' + latt.InviteeId__c + ' x ' + latt.ContactId__c + ' x ' + latt.SupContactId__c);
               updAtt.add(latt);
            }
            else {
               System.debug('Delete ===> '+latt.EmployeeId__c + ' x ' + latt.InviteeId__c + ' x ' + latt.ContactId__c + ' x ' + latt.SupContactId__c);
               delAtt.add(latt);
            }        
         }
         
         if (updAtt.size() > 0) {update updAtt; updAtt.clear();}
         if (delAtt.size() > 0) {delete delAtt; delAtt.clear();}
       
         for (Connection__c lcon:con) {
            System.debug('updAtt.size() ===> ' + updAtt.size());
            if (String.isNotEmpty(lcon.EmployeeId__c)) { // Employee
               createAtd = true;
               for (Attendee__c latd:atd){
                  if(latd.EmployeeId__c != null && latd.EmployeeId__c == lcon.EmployeeId__c) {
                     latd.JoinedBy__c = 'Both';
                     latd.KeyWords__c = lcon.KeyWords__c;
                     updAtt.add(latd);
                     createAtd = false;
                     System.debug('Connection Employee ===> '+lcon.EmployeeId__c+' ===> Updated to Both');
                  }
               }
               if(createAtd == true) {
                  insAtt.add(new Attendee__c(AgendaId__c = pAgendaId,  
                     EmployeeId__c   = lcon.EmployeeId__c, InviteeId__c    = Null,              
                     SupContactId__c = Null,               ContactId__c    = Null,  
                     HasConfirmed__c = false,              JoinedBy__c     = 'Key Word',         
                     KeyWords__c     = lcon.KeyWords__c,   MeetingId__c    = agd.MeetingId__c,
                     StatusEmail__c  = 'Not Sent'));
                  System.debug('Connection Employee ==> Created new Attendee');
               }
            }
            else {
               if (String.isNotEmpty(lcon.ContactId__c)) { // Customer
                  createAtd = true;
                  for (Attendee__c latd:atd){
                     if(latd.ContactId__c != Null && latd.ContactId__c == lcon.ContactId__c) {
                        latd.JoinedBy__c = 'Both';
                        latd.KeyWords__c = lcon.KeyWords__c;
                        updAtt.add(latd);
                        createAtd = false;
                        System.debug('Connection Customer ===> '+lcon.ContactId__c+' ===> Updated to Both');
                     }
                  }
                  if(createAtd == true) {
                     insAtt.add(new Attendee__c(AgendaId__c = pAgendaId,
                        EmployeeId__c   = Null,                InviteeId__c    = Null,
                        SupContactId__c = Null,                ContactId__c    = lcon.ContactId__c,
                        HasConfirmed__c = false,               JoinedBy__c     = 'Key Word',
                        KeyWords__c     = lcon.KeyWords__c,    MeetingId__c    = agd.MeetingId__c,
                        StatusEmail__c  = 'Not Sent'));
                     System.debug('Connection Customer ==> Created new Attendee');
                  }
               }
               else {
                  if (String.isNotEmpty(lcon.SupContactId__c)) { // Supplier Contact
                     createAtd = true;
                     for (Attendee__c latd:atd){
                        if(latd.SupContactId__c != Null && latd.SupContactId__c == lcon.SupContactId__c) {
                           latd.JoinedBy__c = 'Both';
                           latd.KeyWords__c = lcon.KeyWords__c;
                           updAtt.add(latd);
                           createAtd = false;
                           System.debug('Connection Supplier Contact ===> '+lcon.SupContactId__c+' ===> Updated to Both');
                        }
                     }
                     if(createAtd == true) {
                        insAtt.add(new Attendee__c(AgendaId__c = pAgendaId,
                           EmployeeId__c   = Null,                InviteeId__c    = Null,
                           SupContactId__c = lcon.SupContactId__c,ContactId__c    = Null,
                           HasConfirmed__c = false,               JoinedBy__c     = 'Key Word',
                           KeyWords__c     = lcon.KeyWords__c,    MeetingId__c    = agd.MeetingId__c,
                           StatusEmail__c  = 'Not Sent'));
                        System.debug('Connection Supplier Contact ==> Created new Attendee');
                     }
                  }  
                  else {
                     if (String.isNotEmpty(lcon.InviteeId__c)) { // Invitee
                        createAtd = true;
                        for (Attendee__c latd:atd){
                           if(latd.InviteeId__c != Null && latd.InviteeId__c == lcon.InviteeId__c) {
                              latd.JoinedBy__c = 'Both';
                              latd.KeyWords__c = lcon.KeyWords__c;
                              updAtt.add(latd);
                              createAtd = false;
                              System.debug('Connection Invitee ===> '+lcon.InviteeId__c+' ===> Updated to Both');
                           }
                        }
                        if(createAtd == true) {
                           insAtt.add(new Attendee__c(AgendaId__c = pAgendaId,
                              EmployeeId__c   = Null,             InviteeId__c    = lcon.InviteeId__c,
                              SupContactId__c = Null,             ContactId__c    = Null,
                              HasConfirmed__c = false,            JoinedBy__c     = 'Key Word',
                              KeyWords__c     = lcon.KeyWords__c, MeetingId__c    = agd.MeetingId__c,
                              StatusEmail__c  = 'Not Sent'));
                           System.debug('Connection Invitee ==> Created new Attendee');
                        }  
                     }
                  }  
               }
            }
         }
         if (insAtt.size() > 0) { 
            if (insAtt.size() == 1) resultado = resultado + ' ' + insAtt.size().format() + ' Attendee created ';
            else                    resultado = resultado + ' ' + insAtt.size().format() + ' Attendees created '; 
            insert insAtt; insAtt.clear();
         }
         if (updAtt.size() > 0) {
            if (updAtt.size() == 1) resultado = resultado + ' ' + updAtt.size().format() + ' Attendee updated ';
            else                    resultado = resultado + ' ' + updAtt.size().format() + ' Attendees updated '; 
            update updAtt;
            updAtt.clear();
         }
      }
      catch( Exception ex ) {
         insert new EventLog__c(DateTime__c = System.now(), Process__c = 'AgendaBO.joinAtendee()', Type__c = 'Error',Description__c = '>>> ERROR: ' + ex.getMessage() + ' / ' + ex.getStackTraceString());
         System.debug('Event Log ==> ' + ex.getMessage());
      }
      return resultado + 'for Agenda ==> ' + pAgendaId; 
   }
}