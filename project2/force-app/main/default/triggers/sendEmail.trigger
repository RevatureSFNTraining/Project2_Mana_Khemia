trigger sendEmail on User (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    Switch on Trigger.OperationType {
        when AFTER_INSERT {
            sendEmail_Helper.myMethod(Trigger.new);
        }
        when AFTER_UPDATE {
            sendEmail_Helper.myMethod(Trigger.new);
        }
    }     
}