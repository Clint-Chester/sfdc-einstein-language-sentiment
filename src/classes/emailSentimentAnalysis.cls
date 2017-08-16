public class emailSentimentAnalysis {
  // You can upload the `einstein_platform.pem` into your Salesforce org as `File` sObject and read it as below
    public static String getAccessToken() {
        // Ignore the File upload part and "jwt.pkcs" if you used a Salesforce certificate to sign up for an Einstein Platform account
        ContentVersion base64Content = [SELECT Title, VersionData FROM ContentVersion where Title='einstein_platform' OR  Title='predictive_services' ORDER BY Title LIMIT 1];
        String keyContents = base64Content.VersionData.tostring();
        keyContents = keyContents.replace('-----BEGIN RSA PRIVATE KEY-----', '');
        keyContents = keyContents.replace('-----END RSA PRIVATE KEY-----', '');
        keyContents = keyContents.replace('\n', '');
        
        // Now get the access email from Einstein Custom Metadata Settings
        EinsteinSetting__mdt einsteinEmail = [SELECT DeveloperName, Email__c FROM EinsteinSetting__mdt WHERE DeveloperName = 'AccessEmail' LIMIT 1];

        // Get a new token
        JWT jwt = new JWT('RS256');
        // jwt.cert = 'JWTCert'; // Uncomment this if you used a Salesforce certificate to sign up for an Einstein Platform account
        jwt.pkcs8 = keyContents; // Comment this if you are using jwt.cert
        jwt.iss = 'developer.force.com';
        jwt.sub = einsteinEmail.Email__c;
        jwt.aud = 'https://api.einstein.ai/v1/oauth2/token';
        jwt.exp = '3600';
        String access_token = JWTBearerFlow.getAccessToken('https://api.einstein.ai/v1/oauth2/token', jwt);
        return access_token;    
    }
    
    @InvocableMethod(label='Get Email Sentiment' description='Calls Salesforce Einstein API to analyse email sentiment')
    public static void prepareEmailSentiment(List<EmailMessage> emails) {
		// Ensuring that only one email is being used to call the Einstein API
        if(emails.size() == 1) {
            getEmailSentiment(emails.get(0).Id, emails.get(0).TextBody);
        } 	
    }
    
    @future (callout = true)
    public static void getEmailSentiment(Id recordId, String textBody) {
        // Get a new token
        String access_token = getAccessToken();
        // Call to analyse sentiment
        List<Language.Prediction> predictions = Language.sentiment(textBody,access_token,'CommunitySentiment');
        // Now get the email back to set the values
        EmailMessage email = [SELECT Id, SentimentPositive__c, SentimentNeutral__c, SentimentNegative__c FROM EmailMessage WHERE Id = :recordId];
        // Loop through the predictions and record the scores for each email
        for(Language.Prediction prediction : predictions) {
            if(prediction.label == 'positive') {
                email.SentimentPositive__c = prediction.probability * 100;
                continue;
            }
            if(prediction.label == 'neutral') {
                email.SentimentNeutral__c = prediction.probability * 100;
                continue;
            }
            if(prediction.label == 'negative') {
                email.SentimentNegative__c = prediction.probability * 100;
                continue;
            }
        }
        update email;
    }
}