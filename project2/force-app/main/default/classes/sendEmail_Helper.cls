public with sharing class sendEmail_Helper {

    public static void sendEmail(List<User> us) {

        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();
        List<String> sendTo = new List<String>();
        
        for(User u : us){
            if(u.Blocked__c == true){
                Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
                sendTo.add(u.Username);
                mail.setToAddresses(sendTo);
                mail.setSubject('Blocked');
                String body = 'Your ebay Account is blocked. You are not able to send message please contact customer service.';
                mail.setHtmlBody(body);
                mails.add(mail);
            }
        }
    Messaging.sendEmail(mails);
    }  
}