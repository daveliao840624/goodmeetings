public with sharing class GMUtil { /* Singleton */

   private static final GMUtil instance = new GMUtil();    
   
   private GMUtil(){}
    
   public static GMUtil getInstance() { return instance; }

   /**************************************
   ** sendMail()  Method                **
   **************************************/
   public String sendMail(Id pTargetObjectId, String pSenderDisplayName, String[] pAddresses,String[] pCcAddresses,String pReplyTo,String pSubject,String pBody,Boolean pPlainHtml) {
      String returnString;
      if (Limits.getLimitEmailInvocations() - Limits.getEmailInvocations() > 0) {
         Messaging.reserveSingleEmailCapacity(1);  //indicates the total number of addresses that emails will be sent to
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
         mail.setSaveAsActivity(true);
         mail.setToAddresses(pAddresses);
         mail.setCcAddresses(pCcAddresses);
         mail.setReplyTo(pReplyTo);
         mail.setSenderDisplayName(pSenderDisplayName);
         mail.setSubject(pSubject);
         mail.setBccSender(false);
         mail.setUseSignature(false);
         if(pTargetObjectId != null) {mail.setTargetObjectId(pTargetObjectId);}
         if (pPlainHtml == true) {mail.setPlainTextBody(pBody);}
         else {mail.setHtmlBody(pBody);}
         Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });         
         try { 
            Messaging.SendEmailResult[] emailResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            if (emailResult[0].isSuccess()) returnString = 'Success - Email sent';
            else {
               Messaging.SendEmailError[] emailError = emailResult[0].getErrors();
               returnString = 'Failure - Email not sent ===> ' + emailError[0].getMessage();
            }
         }               
         catch ( Exception ex ) {
            returnString = 'Failure - Email not sent ==> Error: ' + ex.getMessage() + ' / ' + ex.getStackTraceString();                      
         }
      }
      else {returnString = 'Failure - Sent Mail Limit exceeded!';}
      return(returnString);
   }
}