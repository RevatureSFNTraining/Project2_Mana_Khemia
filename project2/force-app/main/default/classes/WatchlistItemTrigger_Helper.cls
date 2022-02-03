public with sharing class WatchlistItemTrigger_Helper {
    
    // require product and user fields
    public static void requireFields(List<Watchlist_Item__c> items) {
        for(Watchlist_Item__c item : items) {
            if (item.User__c == null) {
                item.User__c.addError('User is required');
            }
            if (item.Product__c == null) {
                item.Product__c.addError('Product is required');
            }
        }
    }

    // send user notification that item has been added to watchlist
    public static void addedNotification(List<Watchlist_Item__c> items) {

        // Step 0: Create a master list to hold the emails we'll send
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
    
        for(Watchlist_Item__c item : items) {
            User user = [SELECT Id, name, email
                        FROM User 
                        WHERE Id=:item.OwnerId LIMIT 1];
            Product2 prod = [SELECT Id, Name
                        FROM Product2 
                        WHERE Id=:item.Product__c LIMIT 1];

            // Step 1: Create a new Email
            Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();

            // Step 2: Set list of people who should get the email
            List<String> sendTo = new List<String>();
            sendTo.add(user.email);
            mail.setToAddresses(sendTo);

            // Step 3: Set who the email is sent from
            mail.setReplyTo('admin@alchemy.p2');
            mail.setSenderDisplayName('Admin');

            // Step 4. Set email contents
            mail.setSubject('Item added to Watchlist');
            String body = prod.Name + ' has been added to your watchlist.';
            mail.setHtmlBody(body);

            // Step 5. Add your email to the master list
            mails.add(mail);
        }

        // Step 6: Send all emails in the master list
        Messaging.sendEmail(mails);
    }
}