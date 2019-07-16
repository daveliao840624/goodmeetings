public class VFLoginFlowController {
   public PageReference FinishLoginFlowStartUrl() {
      //finish the login flow and send you to the startUrl (meeting page in this case)
      return Auth.SessionManagement.finishLoginFlow('/a00/o');
   }
   public PageReference FinishLoginFlowHome() { 
      //finish the login flow and send you the default homepage
      return Auth.SessionManagement.finishLoginFlow();
   }
}