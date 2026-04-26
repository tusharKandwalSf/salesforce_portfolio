@isTest
private class CaseRestServiceTest {
    
    @isTest
    static void testGetCase(){
        Case testCase = new Case(Subject = 'Test Case', Status = 'New');
        insert testCase;
        RestRequest req = new RestRequest();
        testCase = [SELECT Id, CaseNumber FROM Case WHERE Id = :testCase.Id];
        req.requestURI = '/services/apexrest/cases/' + testCase.CaseNumber;
        RestContext.request = req;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        req.httpMethod = 'GET';
        Case result = CaseRestService.getCaseById();
        System.assertEquals(testCase.Id,result.Id, 'Case ID should match');

        // Testing for Exceptions
        RestRequest reqInvalid = new RestRequest();
        reqInvalid.requestURI = '/services/apexrest/cases/Invalid123';
        RestContext.request = reqInvalid;
        RestResponse resInvalid = new RestResponse();
        RestContext.response = resInvalid;
        reqInvalid.httpMethod = 'GET';
        Case resultInvalid = CaseRestService.getCaseById();

    }

    @isTest
    static void testPostCase(){
        Case testCase = new Case(Subject = 'Test Case', Status = 'New');
        insert testCase;
        RestRequest req = new RestRequest();
        req.httpMethod = 'POST';
        req.requestURI = '/services/apexrest/cases/';
        req.requestBody = Blob.valueOf('{"subject":"Test Post Case","status":"New"}');
        RestContext.request = req;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        String caseID = CaseRestService.createCase();
        testCase = [SELECT Id, Subject FROM Case WHERE Id = :caseID];
        System.assertEquals(testCase.Id, caseId, 'Case should be created');

        // Test for Exceptions
        RestRequest reqInvalid = new RestRequest();
        reqInvalid.httpMethod = 'POST';
        reqInvalid.requestURI = '/services/apexrest/cases/';
        reqInvalid.requestBody = Blob.valueOf('Invalid Json');
        RestContext.request = reqInvalid;
        RestResponse resInvalid = new RestResponse();
        RestContext.response = resInvalid;
        String resultInvalid = CaseRestService.createCase();
    }
    
    @isTest
    static void testPatchCase(){
        Case testCase = new Case(Subject = 'Test Case', Status = 'New');
        insert testCase;
        RestRequest req = new RestRequest();
        req.httpMethod = 'PATCH';
        req.requestURI = '/services/apexrest/cases/';
        testCase = [SELECT Id, Subject FROM Case WHERE Id = :testCase.Id];
        String jsonStr = '{"caseId":"' + testCase.Id + '","status":"In Progress"}';
        req.requestBody = Blob.valueOf(jsonStr);
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        String caseID = CaseRestService.updateCase();
        Case result = [SELECT Id, Status FROM Case WHERE Id = :caseID];
        System.assertEquals('In Progress', result.Status, 'Case status should be updated');


        // Test for Exceptions
        RestRequest reqInvalid = new RestRequest();
        reqInvalid.httpMethod = 'PATCH';
        reqInvalid.requestURI = '/services/apexrest/cases/';
        String invalidJson = '{"caseId":"INVALIDID","Status":"In Progress"}';
        reqInvalid.requestBody = Blob.valueOf(invalidJson);
        RestContext.request = reqInvalid;
        RestResponse resInvalid = new RestResponse();
        RestContext.response = resInvalid;
        String resultInvalid = CaseRestService.updateCase();
    }

}