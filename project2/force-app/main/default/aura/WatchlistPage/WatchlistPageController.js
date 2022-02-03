({
    pageRedirect : function(component, message) {
        var page;
        if(message) {
            page = '/s/' + message.getParam('pageRedirect');
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": page
            });
            urlEvent.fire();
        }
    }
})