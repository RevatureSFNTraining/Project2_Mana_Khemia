trigger ProductTrigger on Product (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    Switch on Trigger.OperationType {
        when BEFORE_INSERT {
        } 
        when BEFORE_UPDATE {
        }
        when BEFORE_DELETE {
        }
        when AFTER_INSERT {
            ProductTrigger_Helper.createAssociatedChatterGroup(Trigger.new);
        }
        when AFTER_UPDATE {
            ProductTrigger_Helper.newHighestBidMessage(Trigger.old, Trigger.new);
            ProductTrigger_Helper.sendClosingMessage(Trigger.new);
        }
        when AFTER_DELETE {
        }
        when AFTER_UNDELETE {
        } 
    }
}