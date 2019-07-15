global with sharing class MeetingBO {
   /**********************************************************************************************************************
   ** @Author: Dave Liao                                                                                                **
   ** Data...: 18/04/2018                                                                                               **
   ** Purpose: Create Meeting, Agenda and Attendees from a template                                                     **
   ** Changes                                                                                                           **
   ** Version  When       Who  What-for                                                                                 **
   ** ======== ========== ==== ======================================================================================== **
   ** V.01.001 18/04/2018 DL   Create Meeting, Agenda and Attendees from a template                                     **
   ** V.01.002 27/06/2018 DL   Treat existing agenda and attendees of a meeting when this class is called by trigger    **
   **                          Meeting after update                                                                     **
   ** V.02.001 10/06/2018 DL   Create Button, Class GMUtil, and a Method to send an invitation e-mail to Attendees      **
   **                                                                                                                   **
   **********************************************************************************************************************/
   private static final MeetingBO instance = new MeetingBO();    

   private MeetingBO(){}
    
   public static MeetingBO getInstance() {return instance;}
   
   public void createMeetingFromTemplate(Meeting__c pMeeting) {
      Datetime              dateTimeWIP;
      String                      agdId = null;
      String              existingAgdId = null;
      String              existingAttId = null;
      Meeting__c            mtgTemplate = new Meeting__c();
      List<Agenda__c>       agdTemplate = new List<Agenda__c>();
      List<Attendee__c>     attTemplate = new List<Attendee__c>();	
      List<Attendee__c>          insAtt = new List<Attendee__c>();

      if(String.IsNotEmpty(pMeeting.CreatedFromMeetingId__c)){
         System.debug('CreatedFromMeetingId__c not empty ===> ' + pMeeting.CreatedFromMeetingId__c);
         mtgTemplate = MeetingDAO.getInstance().getMeetingById(pMeeting.CreatedFromMeetingId__c);
         if(mtgTemplate.Id != null) {
            System.debug('mtgTemplate.Id not null ===> ' + mtgTemplate.Id);
            System.debug('pMeeting.Title__c ===> ' + pMeeting.Title__c + ' mtgTemplate.Title__c ===> ' + mtgTemplate.Title__c);
            dateTimeWIP              = this.meetingDate(mtgTemplate.DateTime__c, mtgTemplate.Frequency__c );
            pMeeting.DateTime__c     = pMeeting.DateTime__c    == null ? dateTimeWIP                : pMeeting.DateTime__c    != dateTimeWIP                ? dateTimeWIP             : pMeeting.DateTime__c      ;
            pMeeting.Description__c  = pMeeting.Description__c == null ? mtgTemplate.Description__c : pMeeting.Description__c != mtgTemplate.Description__c ? pMeeting.Description__c : mtgTemplate.Description__c; 
            pMeeting.Frequency__c    = pMeeting.Frequency__c   == null ? mtgTemplate.Frequency__c   : pMeeting.Frequency__c   != mtgTemplate.Frequency__c   ? pMeeting.Frequency__c   : mtgTemplate.Frequency__c  ; 
            pMeeting.MeetingType__c  = pMeeting.MeetingType__c == null ? mtgTemplate.MeetingType__c : pMeeting.MeetingType__c != mtgTemplate.MeetingType__c ? pMeeting.MeetingType__c : mtgTemplate.MeetingType__c; 
            pMeeting.ProjectId__c    = pMeeting.ProjectId__c   == null ? mtgTemplate.ProjectId__c   : pMeeting.ProjectId__c   != mtgTemplate.ProjectId__c   ? pMeeting.ProjectId__c   : mtgTemplate.ProjectId__c  ; 
            pMeeting.Title__c        = pMeeting.Title__c       == null ? mtgTemplate.Title__c       : pMeeting.Title__c       != mtgTemplate.Title__c       ? pMeeting.Title__c       : mtgTemplate.Title__c      ;

            System.debug('dateTimeWIP ===> '  + dateTimeWIP);
            System.debug('Title ===>  '       + mtgTemplate.Title__c);
            System.debug('Description ===>  ' + mtgTemplate.Description__c);
            System.debug('Frequency ===>  '   + mtgTemplate.Frequency__c);
            System.debug('MeetingType ===>  ' + mtgTemplate.MeetingType__c);
            System.debug('ProjectId ===>  '   + mtgTemplate.ProjectId__c);
            
            agdTemplate = AgendaDAO.getInstance().getAgendaByTemplateId(mtgTemplate.Id);
            if(agdTemplate.size() > 0) {
               for (Agenda__c lAgdT:agdTemplate){
                  existingAgdId = AgendaDAO.getInstance().getNewAgendaIdByAgdTptId(pMeeting.Id,lAgdT.Id);
                  if(existingAgdId == null) {
                     System.debug('agdTemplate.size() ===> ' + agdTemplate.size() + ' existingAgdId ===> ' + existingAgdId);
                     insert new Agenda__c(
                        Name                   = (String.isNotEmpty(lAgdT.Name)?lAgdT.Name:'Agenda Template Name Empty'),
                        KeyWords__c            = (String.isNotEmpty(lAgdT.KeyWords__c)?lAgdT.KeyWords__c:null),
                        KInId__c               = (String.isNotEmpty(lAgdT.KInId__c)?lAgdT.KInId__c:null),
                        MeetingId__c           = pMeeting.Id,
                        SubjectId__c           = (String.isNotEmpty(lAgdT.SubjectId__c)?lAgdT.SubjectId__c:null),
                        SubjectDescription__c  = (String.isNotEmpty(lAgdT.SubjectDescription__c)?lAgdT.SubjectDescription__c:null),
                        CreatedFromAgendaId__c = lAgdT.Id);
                  }
               }
            }

            attTemplate = AttendeeDAO.getInstance().getAttendeeByTemplateId(mtgTemplate.Id);
            for(Attendee__c lAttT:attTemplate) {
               
               if(lAttT.AgendaId__c == null) {agdId = null;}
               else {agdId = AgendaDAO.getInstance().getNewAgendaIdByAgdTptId(pMeeting.Id,lAttT.AgendaId__c);}
               
               existingAttId = AttendeeDAO.getInstance().getNewAttendeeIdByAttTptId(pMeeting.Id,lAttT.Id);
               if(existingAttId == null) {
                  System.debug('lAttTAgendaId__c ===> ' + lAttT.AgendaId__c + ' existingAttId ===> ' + existingAttId);
                  insAtt.add(new Attendee__c(
                     AgendaId__c              = agdId,
                     ContactId__c             = (String.isNotEmpty(lAttT.ContactId__c)   ?lAttT.ContactId__c:null),
                     EmployeeId__c            = (String.isNotEmpty(lAttT.EmployeeId__c)  ?lAttT.EmployeeId__c:null),
                     HasConfirmed__c          = lAttT.HasConfirmed__c,
                     InviteeId__c             = (String.isNotEmpty(lAttT.InviteeId__c)   ?lAttT.InviteeId__c:null),
                     JoinedBy__c              = (String.isNotEmpty(lAttT.JoinedBy__c)    ?lAttT.JoinedBy__c:null),
                     KeyWords__c              = (String.isNotEmpty(lAttT.KeyWords__c)    ?lAttT.KeyWords__c:null),
                     MeetingId__c             = pMeeting.Id,
                     SupContactId__c          = (String.isNotEmpty(lAttT.SupContactId__c)?lAttT.SupContactId__c:null),
                     StatusEmail__c           = 'Not Sent',
                     CreatedFromAttendeeId__c = lAttT.Id));
               }
            }
            if(insAtt.size() > 0) {insert insAtt;}        
            ProcessControl.ignoredByTrigger = True;
            update pMeeting;
         }
      }
   }

   public DateTime meetingDate(DateTime pDateTime, String pFrequency ) {
      Datetime dtReturn;
      Date dateWip = pDateTime.date();
      Integer mda;
      Integer mmo;
      Integer mye;
      Integer mhr = pDateTime.time().hour();
      Integer mmi = pDateTime.time().minute();
      Integer mse = pDateTime.time().second();
      Integer freq = (pFrequency == 'Annual'      ? 365 : pFrequency == 'Bimonthly'   ? 60  :
                      pFrequency == 'Biweekly'    ? 15  : pFrequency == 'Daily'       ? 1   :
                      pFrequency == 'Monthly'     ? 30  : pFrequency == 'Quarterly'   ? 90  :
                      pFrequency == 'Six-monthly' ? 180 : pFrequency == 'Weekly'      ? 7   : 1);
      
      Decimal daysBetween = dateWip.daysBetween(System.today());
      
      System.debug('Date Wip ===> ' + dateWip);
      System.debug('Days between today and ' + dateWip + ' ===> ' + daysBetween);
      
      Decimal qtFreqBlocks = (daysBetween/freq).intValue();
      
      System.debug('Integer part of ' + daysBetween + ' divided by  ' + freq + ' ===> '+ qtFreqBlocks);
      
      Decimal decimalPart = (daysBetween/freq)-(daysBetween/freq).intValue();
      
      System.debug('Decimal Part of the Division ===> ' + decimalPart);
      
      Integer intQtFreqBlocks = qtFreqBlocks.intValue();
      Integer oneBlockAhead = (intQtFreqBlocks * freq) + freq;
      
      System.debug('One Block Ahead ===> ' + oneBlockAhead);
      
      Date returnDate;
      if (decimalPart > 0) {
         returnDate = dateWip.addDays(oneBlockAhead);
         System.debug('Original Date + '+ oneBlockAhead + ' days ===> ' + returnDate);
      }
      else {
         returnDate = dateWip.addDays(intQtFreqBlocks * freq);
         System.debug('Original Date + '+ (intQtFreqBlocks * freq) + ' days ===> ' + returnDate);
      }
      mda = returnDate.day();
      mmo = returnDate.month();
      mye = returnDate.year();
      dtReturn = Datetime.newInstance(mye,mmo,mda,mhr,mmi,mse);
      System.debug('Returning Date ===> ' + dtReturn);
      return dtReturn;
   }

   webservice static String SendAttendeeInvitationByEmail(String pMeetingId) {    
      Meeting__c            mtg = MeetingDAO.getInstance().getMeetingById(pMeetingId);
      Contact               ctt = new Contact();
      Employee__c           emp = new Employee__c();
      Invitee__c            inv = new Invitee__c();
      SupContact__c         sct = new SupContact__c();
      String            attMail = '';
      List<Attendee__c>  updAtd = new List<Attendee__c>();
      List<String>   vAddresses = new List<String>();
      List<String> vCcAddresses = new List<String>();
      String           vReplyTo = Null;
      String           vSubject = 'Invitation for the meeting ' + mtg.Title__c + ' Id ===> ' + mtg.Id;
      String              vBody = 'You are invited to take part on the meeting above to discuss ' + mtg.description__c + '\nIt will take place at ' + mtg.Venue__c + ' on ' + mtg.DateTime__c; 
      Boolean        vPlainHTML = False;
      String        vMailReturn = '';
      String            vReturn = '';
      String vSenderDisplayName = 'Meeting Organizer';
      Integer    vMailSentCount = 0;
      Id        vTargetObjectId;

      System.debug('Meeting Title: ' + mtg.Title__c + ' Meeting Id ===> ' + mtg.Id);

      for (Attendee__c atd : AttendeeDAO.getInstance().getAttendeeWithoutMail(pMeetingId)) {   
         vAddresses.clear();
         if (atd.ContactId__c != Null) { ctt = GMContactDAO.getInstance().getContactById(atd.ContactId__c);                    attMail = ctt.email;    vTargetObjectId = atd.ContactId__c;}
         else {
            if (atd.EmployeeId__c != Null) { emp = EmployeeDAO.getInstance().getEmployeeById(atd.EmployeeId__c);               attMail = emp.Email__c; vTargetObjectId = atd.EmployeeId__c;}
            else {
               if (atd.InviteeId__c != Null) { inv = InviteeDAO.getInstance().getInviteeById(atd.InviteeId__c);                attMail = inv.Email__c; vTargetObjectId = atd.InviteeId__c;}
               else {
                  if (atd.SupContactId__c != Null) { sct = SupContactDAO.getInstance().getSupContactById(atd.SupContactId__c); attMail = sct.Email__c; vTargetObjectId = atd.SupContactId__c;}
               }
            }   
         }
         vAddresses.add(attMail);
         vTargetObjectId = null; //for a while. Need to perform a deep search 
         vMailReturn = GMUtil.getInstance().sendMail(vTargetObjectId,vSenderDisplayName,vAddresses,vCcAddresses,vReplyTo,vSubject,vBody,vPlainHtml);
         
         if(vMailReturn.left(7) != 'Success') {
            insert new EventLog__c(DateTime__c = System.now(), Process__c = 'MeetingBO.getAttendeeWithoutMail()', Type__c = 'Error',Description__c = vMailReturn);
            atd.StatusEmail__c = 'Error Found';
         }
         else {
            atd.StatusEmail__c = 'Sent';
            vMailSentCount += 1;
         }
         updAtd.add(atd);
      }
      update updAtd;
      vReturn = vMailSentCount.format() + ' E-Mail Sent';
      return vReturn;
   }
}