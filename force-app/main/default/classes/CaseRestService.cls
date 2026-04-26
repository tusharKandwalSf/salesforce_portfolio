@RestResource(urlMapping='/cases/*')
global with sharing class CaseRestService {


    public class CaseRequestWrapperPost{
        public String subject {get;set;}
        public String status {get;set;}
    }

    public class CaseRequestWrapperPatch{
        public String caseId {get;set;}
        public String status {get;set;}
    }
    
    @HttpGet
    global static Case getCaseById() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String caseId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        try{
            Case c = [SELECT Id, Subject, Status FROM Case WHERE CaseNumber = :caseId  LIMIT 1];
            return c;
        }Catch(exception e){
            res.statusCode = 404;
            return null;
        }
    }

    @HttpPost
    global static String createCase(){
        String request = RestContext.request.requestBody.toString();
        try{
            CaseRequestWrapperPost caseWrapper = (CaseRequestWrapperPost) JSON.deserialize(request, CaseRequestWrapperPost.class);
            Case c = new Case();
            c.Subject = caseWrapper.subject;
            c.Status = caseWrapper.status;
            insert c;
            return c.Id;
        }Catch(exception e){
            RestContext.response.statusCode = 400;
            return 'Error creating case: ' + e.getMessage();
        }
    }

    @HttpPatch
    global static String updateCase(){
        String request = RestContext.request.requestBody.toString();
        try{
            CaseRequestWrapperPatch caseWrapper = (CaseRequestWrapperPatch) JSON.deserialize(request, CaseRequestWrapperPatch.class);
            Case c = [SELECT Id, Status FROM Case WHERE Id = :caseWrapper.caseId LIMIT 1];
            c.Status = caseWrapper.status;
            update c;
            return c.Id;
        }Catch(exception e){
            RestContext.response.statusCode = 400;
            return 'Error updating case: ' + e.getMessage();
        }
    }

}