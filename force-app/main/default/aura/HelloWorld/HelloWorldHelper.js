({
    test: function (component,event,helper) {
        //hello
        var action = component.get("c.initMethod");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("TEST",response.getReturnValue());
                component.set("v.listofsobject",response.getReturnValue().listofsobject);
                
                if((response.getReturnValue()).returnedCustomObjectData.length > 0)
                {
                    console.log("recordpssss");
                    component.set("v.isAllSelected",((response.getReturnValue()).returnedCustomObjectData[0].Active__c));
                    console.log("asfe",component.get("v.isAllSelected"));
                    
                    console.log("hello",component.get("v.selectedobject1"));
                    if(((response.getReturnValue()).returnedCustomObjectData[0].Record_Type_Label__c) !=undefined &&  ((response.getReturnValue()).returnedCustomObjectData[0].Record_Type_Id__c) !=null)
                    {  
                        component.set("v.RecordTypeId",((response.getReturnValue()).returnedCustomObjectData[0].Record_Type_Id__c));
                        component.set("v.selectedRecordType",((response.getReturnValue()).returnedCustomObjectData[0].Record_Type_Label__c));
                        console.log("23456",component.get("v.returnedid"));
                    } 
                    component.set("v.selectedobject1",(response.getReturnValue()).returnedCustomObjectData[0].Object_Name__c);
                    console.log("hello1",component.get("v.selectedobject1"));
                      component.set("v.sObjectName",component.get("v.selectedobject1"));
                }
                else{
                    console.log("hello");
                    var abc = component.get("v.listofsobject");
                    console.log("value1",abc);
                    var count = abc.length;
                    console.log("value2",abc.length);
                    for(var i = 0; i <=count; i++){
                        if(abc[i] == "Case"){
                            console.log("insideloop");
                            component.set("v.selectedobject1", abc[i]);
                        }
                    }
                      component.set("v.sObjectName",component.get("v.selectedobject1"));
                    component.set("v.isAllSelected", false);
                    if((response.getReturnValue()).listOfRecordType.length > 0)
                    {
                        component.set("v.selectedRecordType",(response.getReturnValue()).listOfRecordType[0].Name);
                        component.set("v.RecordTypeId",(response.getReturnValue()).listOfRecordType[0].Id);  
                        console.log("p1",component.get("v.RecordTypeId"));
                        
                    }
                }  
              
                console.log("p1",component.get("v.selectedRecordType"));
                
                if((response.getReturnValue()).listOfRecordType.length > 0)
                {
                    console.log("insideloop");
                    component.set("v.showRecordTypeOptions", true);
                    component.set("v.listOfRecordType",(response.getReturnValue()).listOfRecordType);
                    console.log("insideloop",component.get("v.listOfRecordType"));
                   
                    
                    
                    
                }
                
                
                 
                component.set("v.showForm", true);
               
                component.set("v.showButtons", true); 
                 component.set("v.reloadForm", true);
                
                console.log("piyush");
            }
        });
        
        $A.enqueueAction(action);
    },
    handleOnSavePrefrence1:  function (component, event, helper) {
        var sobjectname = component.get("v.sObjectName");
        console.log("sobjectname", sobjectname);
        var recordtypeid = component.get("v.RecordTypeId");
        console.log("recordtypeid", recordtypeid);
        var value = component.get("v.saveprefrence");
        console.log("value", value);
        var action = component.get("c.saveCustomObjectData");
        action.setParams({
            "ObjectName": sobjectname,
            "RecordTypeId": recordtypeid,
            "value": value
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("heeelooooopiyusgf", response.getReturnValue());
            }
        });   $A.enqueueAction(action); 
    },
    toggleHelper : function(component,event) {
        var toggleText = component.find("pop");
        $A.util.toggleClass(toggleText, "toggle");
    },
    toggleHelper1 : function(component,event) {
        var toggleText = component.find("pop");
        $A.util.toggleClass(toggleText, "toggle");
    },
    handleOnSave1: function (component, event, helper) {
        event.preventDefault();
        var globalId = component.get("v.dummy");
        console.log("GID",globalId);
        console.log("PIYUSH", component.find("recordForm"));
        console.log("PIYUSH", component.find("recordForm")[0]);
        if(component.find("recordForm")[0] != undefined)
            component.find("recordForm")[0].submit();
        else
            component.find('recordForm').submit(); 
    }
    
})