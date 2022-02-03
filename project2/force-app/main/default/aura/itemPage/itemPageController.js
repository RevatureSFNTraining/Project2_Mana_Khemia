({
    pageRedirect : function(component, message) {
        var page;
        if(message) {
            page = '/s/' + message.getParam('pageRedirect');
            var urlEvent = $A.get("e.force:vaigateToURL");
            urlEvent.setParams({
                "url": page
            });
            urlEvent.fire();
        }
    },

    init : function(component, event, helper) {
		var userId = $A.get("$SObjectType.CurrentUser.Id");
        component.set("v.userId", userId);
	},

    handleSubmit : function(component, event, helper) {
        event.preventDefault();
        const fields = event.detail.fields;
        fields.Bidder__c = $A.get("$SObjectType.CurrentUser.Id");
        this.template.querySelector('lightning-record-form').submit(fields);
    },

    handleSuccess : function(component, event, helper) {
        component.find('notifLib').showToast({
            "variant": "success",
            "title": "Account Created",
            "message": "Record ID: " + event.getParam("id")
        });
    }
})
