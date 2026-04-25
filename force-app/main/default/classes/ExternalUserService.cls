public with sharing class ExternalUserService {

    public class ExternalUserWrapper{
        public Integer id {get;set;}
        public String name {get;set;}
        public String email {get;set;}
    }
    
    public static List<ExternalUserWrapper> fetchExternalUsers(){
        List<ExternalUserWrapper> users = new List<ExternalUserWrapper>();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:JSONPlaceholder/users');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200){
            users = (List<ExternalUserWrapper>) JSON.deserialize(response.getBody(), List<ExternalUserWrapper>.class);
        }
        return users;
    }

}