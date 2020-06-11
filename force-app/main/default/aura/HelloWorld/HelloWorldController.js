({
    getListofSObjects: function (component, event, helper) {
        //NIHJKML
        helper.test(component, event,helper);
       
    },
    openPop : function(component, event, helper) {
        var cmpTarget = component.find('pop');
        $A.util.addClass(cmpTarget, 'slds-show');
        $A.util.removeClass(cmpTarget, 'slds-hide');
        helper.toggleHelper(component, event);
        
    },
    
    closePop : function(component, event, helper) {
        var cmpTarget = component.find('pop');
        // $A.util.addClass(cmpTarget, 'slds-hide');
        //  $A.util.removeClass(cmpTarget, 'slds-show');
        helper.toggleHelper1(component, event);
        // $A.util.addClass(cmpTarget, 'slds-hide');
        
    },
   
    handleOnSavePrefrence: function (component, event, helper) {
        var boolean;
        var value = event.getSource().get("v.checked");
        console.log("value", value);
        if (value == true) {
            var action = component.get("c.getCustomObjectData");
            action.setCallback(this, function (response) {
                console.log("response",response.getReturnValue());
                var state = response.getState();
                if (state === "SUCCESS") {
                    if (response.getReturnValue().length > 0) {
                        console.log("helllo", response.getReturnValue());
                        var rvalue = response.getReturnValue();
                        component.set("v.saveprefrence", value);
                        console.log('return value',rvalue[0].Record_Type_Id__c);
                        console.log('return value',rvalue[0].Record_Type_Label__c);
                        if (rvalue[0].Record_Type_Id__c != undefined) {
                            console.log("if case");
                            component.set("v.message", true);
                            component.set("v.message1", rvalue[0].Object_Name__c);
                            component.set("v.message2", rvalue[0].Record_Type_Label__c);
                            component.set("v.isOpen", true);
                        } else {
                            console.log("elsecalse");
                            component.set("v.message", false);
                            component.set("v.message1", rvalue[0].Object_Name__c);
                            component.set("v.isOpen", true);
                        }
                        console.log("fwefgSGRGHE");
                    } else {
                        component.set("v.saveprefrence", value);
                        helper.handleOnSavePrefrence1(component, event, helper);
                    }
                }
            });
            $A.enqueueAction(action);
        } else if (value == false) {
            component.set("v.saveprefrence", value);
            helper.handleOnSavePrefrence1(component, event, helper);
        }
    },
    handleOnSaveandNew: function (cmp, event, helper) {
        console.log("value of clickedButton", cmp.get("v.clickedButton"));
        cmp.set("v.clickedButton", "SaveandNew"); 
        console.log("piyush0");
        helper.handleOnSave1(cmp, event, helper);
        console.log("iPHASEd");
        component.set("v.reloadForm", false);
        component.set("v.showForm", false);
        
    },
    
    handleSelectedObject: function (component, event, helper) {
        component.set("v.showForm", false);
        component.set("v.isAllSelected", false);

        var sobjectname = event.getSource().get("v.value");
        console.log("value", sobjectname);
        component.set("v.RecordTypeId", '');
        component.set("v.sObjectName", sobjectname);
        console.log("erewergrregr", component.get("v.sObjectName"));
        var action = component.get("c.getRecordTypeList");
        action.setParams({
            "sobjectname": sobjectname
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if (response.getReturnValue().length > 0) {
                    component.set("v.showRecordTypeOptions", true);
                    var abc = response.getReturnValue()
                    component.set("v.listOfRecordType", response.getReturnValue());
                    var value = response.getReturnValue();
                    component.set("v.RecordTypeId", value[0].Id);
                    console.log('recordtypeid', component.get("v.RecordTypeId"));
                    component.set("v.showForm", true);
                    component.set("v.showButtons", true); 
                    
                } else {
                    component.set("v.RecordTypeId", '');
                    component.set("v.showRecordTypeOptions", false);
                    component.set("v.showForm", true);
                    component.set("v.showButtons", true); 
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    handleSelectedRecordType: function (component, event, helper) {
        component.set("v.showForm", false);
		component.set("v.isAllSelected", false);

        var objectname = component.get("v.sObjectName");
        console.log("hello", objectname);
        var recordTypeLabel = event.getSource().get("v.value");
        console.log("recordTypeLabel", recordTypeLabel);
        var action = component.get("c.getRecordTypeId");
        action.setParams({
            "recordTypeLabel": recordTypeLabel,
            "objectname": objectname
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("helllo", response.getReturnValue());
                component.set("v.RecordTypeId", response.getReturnValue());
                console.log(component.get("v.RecordTypeId"));
                component.set("v.showForm", true);
                component.set("v.showButtons", true); 
            }
        });
        $A.enqueueAction(action);
    },
    handleOnCreateNew: function (component, event, helper) {
        component.set("v.reloadForm", false);
        component.set("v.showButtons1", false); 
        component.set("v.reloadForm", true);
        component.set("v.showForm", true);
        component.set("v.showButtons", true); 
        
        
    },
    
    handleOnSuccess: function (component, event, helper) {
        console.log("value of clickedButton", component.get("v.clickedButton"));
        var id= event.getParam("id");
        console.log("idddddddddddddddddpiyushddddd",id);
        var objectname= component.get("v.sObjectName");
        if (component.get("v.clickedButton") === "SaveandNew") {
            console.log("if");
            component.set("v.reloadForm", false);
            component.set("v.showForm", false);
            component.set("v.showButtons1", false); 
            
            component.set("v.reloadForm", true);
            component.set("v.showForm", true);
            component.set("v.showButtons", true); 
            component.set("v.clickedButton", "false1");
            
            //component.set('v.counter',component.get('v.counter')+1); 
            var action = component.get("c.getRecordName");
            action.setParams({
                "recordId": id,
                "objectname": objectname
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log("oandey",response.getReturnValue());
                    var recordDetail=component.get("v.RecordNameList");
                    recordDetail.push(response.getReturnValue());
                    component.set("v.RecordNameList",recordDetail);
                    console.log("poandey",component.get("v.RecordNameList"));
                    
                }
            });
            $A.enqueueAction(action);
            component.set("v.showRecordList",true);
            
        } else{
            console.log("elese");
            component.set("v.showButtons", false); 
            
            component.set("v.showButtons1", true);
            component.set("v.showRecordList",false);
            //component.set('v.counter',component.get('v.counter')+1); 
            console.log("value"+component.get('v.counter'));
        }
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            type: 'success',
            mode: 'dismissible',
            message: 'This is a required message',
            messageTemplate: '{0} created! {1}!',
            messageTemplateData: [objectname, {
                url: '/lightning/r/'+objectname +'/'+id+'/'+'view',
                label: 'Click here',
            }]
        });
        toastEvent.fire();
    },
    
    handleOnSave: function (component, event, helper) { 
        console.log("value of clickedButton", component.get("v.clickedButton"));
        console.log("save Button");
        helper.handleOnSave1(component, event, helper);
    },
    handleOnCancel: function (component, event, helper) { 
        console.log("handleOnCancel");
        component.set("v.reloadForm", false);
        component.set("v.reloadForm", true);
    },
    handleonError: function(component, event,handler) {
        var error = event.getParam('output')['fieldErrors']['Name'][0]['message'];
        console.log("response1", error);
        var resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "type":"error",
            "title":"Error!",
            "message": error
        });
        resultsToast.fire();
    },
    closeModel: function (component, event, helper) {
component.set("v.isOpen", false);
component.set("v.isAllSelected", false);
},

savePrefrence: function (component, event, helper) {
// Display alert message on the click on the "Like and Close" button from Model Footer 
// and set set the "isOpen" attribute to "False for close the model Box.

component.set("v.isOpen", false);
var value = component.get("v.saveprefrence");
console.log("value", value);
component.set("v.saveprefrence", value);
helper.handleOnSavePrefrence1(component, event, helper);
},
})