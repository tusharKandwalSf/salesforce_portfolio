public with sharing class ExternalAIService {
    
    public class AIRequest{
        @InvocableVariable(label = 'Case Description' description = 'The model to use for the AI request')
        public String caseDescription;
    }

    public class AIResponse{
        @InvocableVariable(label = 'AI Response' description = 'The response from the AI model')
        public String resolution;
    }

    @InvocableMethod(label = 'Get AI Response' description = 'Get AI Response from OpenAI API')
    public static List<AIResponse> getAIResponse(List<AIRequest> AIRequests){
        HttpRequest req = new HttpRequest();
        String caseDescription;
        req.setEndpoint('callout:OpenAI_API/v1/chat/completions');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        List<AIResponse> aiResponses = new List<AIResponse>();
        for(AIRequest aiReq : AIRequests){
            caseDescription = aiReq.caseDescription;
        }
        String reqBody  = JSON.serialize(new Map<String,Object>{
            'model' => 'gpt-4o-mini',
            'messages' => new List<Map<String,String>>{
                new Map<String, String>{
                    'role' => 'user',
                    'content' => 'Suggest a resolution for this support case: ' + caseDescription
                }
            },
            'max_tokens' => 100
        });
        Http http = new Http();
        req.setBody(reqBody);
        req.setTimeout(120000);
        HttpResponse res = http.send(req);
        System.debug(res.getStatusCode());
        System.debug(res.getBody());
        Map<String,Object> resMap = (Map<String,Object>) JSON.deserializeUntyped(res.getBody());
        List<Object> choices = (List<Object>) resMap.get('choices');
        Map<String,Object> message = (Map<String,Object>) ((Map<String,Object>) choices[0]).get('message');
        String suggestion = (String) message.get('content');
        System.debug('AI Suggestion: ' + suggestion);
        AIResponse aiRes = new AIResponse();
        aiRes.resolution = suggestion;
        aiResponses.add(aiRes);
        return aiResponses;
    }

}