({
    doInit:function(cmp, event, helper) {
        console.log("flow screen");
        var orderId=cmp.get("v.recordId");
        console.log(orderId);
        
        var flow=cmp.find("flowData");
        var inputVariables = [ { name : "Order_Object", type : "SObject", value: {
            "Id" : orderId}}];                               
        console.log("before flow start");
        flow.startFlow("Cancel_Order_Flow",inputVariables);
        console.log("afetr flow");
    },
    
    //Flow Status Change
    statusChange : function (component, event, helper) {
        //Check Flow Status
        if (event.getParam('status') === "FINISHED_SCREEN" || event.getParam('status') === "FINISHED") {
            var navigate = component.get("v.navigateFlow");
      		navigate("FINISH");
            $A.get("e.force:closeQuickAction").fire();
            $A.get('e.force:refreshView').fire();
        } else if (event.getParam('status') === "ERROR") {
            component.set("v.hasError", true);
        }
    },
    
    handleStatusChange : function (cmp, event) {
        if (event.getParam('status') === "FINISHED") {
            //Do something
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": "https://proapistonecom-dev-ed.lightning.force.com/lightning/o/Product2/list?filterName=00B5i000006pyciEAA"
            });
            
            urlEvent.fire();
        }
    },
    
    goToNewPage: function(component, event, helper) {
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/newPage"
        });
        
        urlEvent.fire();
    }
});