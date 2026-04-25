public with sharing class ExternalUserServiceMock implements HttpCalloutMock {
    
    public HttpResponse respond(HttpRequest req){
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        String responseMockJSON = '[{"id": 1, "name": "MockTest1 Fn Ln","email":"Mock1@example.com", "company": {"name": "TestCo1"}}, {"id": 2, "name": "MockTest2 Fn Ln","email":"Mock2@example.com", "company": {"name": "TestCo2"}}]';
        res.setBody(responseMockJSON);
        return res;
    }

}