trigger BidTrigger on Bid__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
  Switch on Trigger.OperationType {
    when BEFORE_INSERT {
      BidTrigger_Helper.requiredFields(Trigger.new);
    }
    when BEFORE_UPDATE {}
    when BEFORE_DELETE {}
    when AFTER_INSERT {
      BidTrigger_Helper.updateCurrentHighestBid(Trigger.new);
    }
    when AFTER_UPDATE {}
    when AFTER_DELETE {}
    when AFTER_UNDELETE {} 
  }
}