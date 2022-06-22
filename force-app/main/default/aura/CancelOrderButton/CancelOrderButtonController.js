({
    closeModal:function(component,event,helper){
        console.log("close modal");
        component.set('v.ismodalClicked', false);
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
   	 },
        openmodal: function(component,event,helper) {
             console.log("open modal start");
            component.set('v.ismodalClicked', true);
            var cmpTarget = component.find('Modalbox');
            var cmpBack = component.find('Modalbackdrop');
           $A.util.addClass(cmpTarget, 'slds-fade-in-open');
            $A.util.addClass(cmpBack, 'slds-backdrop--open');
              console.log("open modal end");
        }
})