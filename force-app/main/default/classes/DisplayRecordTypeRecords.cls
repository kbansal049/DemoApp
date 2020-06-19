public with sharing class DisplayRecordTypeRecords {
    
    @AuraEnabled
    public static List < String > getSobjectsList() {
        List < String > options = new List < String > ();
        List < String > options1 = new List < String > ();
        for (Schema.SObjectType objTyp: Schema.getGlobalDescribe().values()) {
            // Exclude all the unwanted Sobjects e.g. CustomSettings, History, Share, Feed, ApexClass, Pages etc..
            if ((objTyp.getDescribe().isCreateable()== True) && (objTyp.getDescribe().isCustomSetting() == False) && (objTyp.getDescribe().isQueryable() == True) && (objTyp.getDescribe().isMruEnabled() == True) && objTyp.getDescribe().isAccessible() == true){
                String name = objTyp.getDescribe().getName();
                if(objTyp.getDescribe().isCustom() == False){
                    options1.add(name);
                } 
                else if((name != 'Knowledge__kav') && objTyp.getDescribe().isCustom() == True){ 
                    System.debug('hello2'+name);
                    options.add(name);
                }
            }
        } 
        if(!options1.isEmpty()){
            List<String> names= getListofSobject(options1);
            options.addAll(names);
        }
        System.debug('options'+options);
        options.sort();
        return options;
    }
    
    public static List<String> getListofSobject(List<String> objectNames){
        List < String > options = new List < String > ();
        for(String name:objectNames){
            if((!name.containsignorecase('Form') &&!name.containsignorecase('ChannelProgram') && !name.containsignorecase('tag') && !name.containsignorecase('share') 
                && !name.containsignorecase('feed') && !name.containsignorecase('Task')  && !name.containsignorecase('Event') && !name.containsignorecase('Brand') 
                && !name.containsignorecase('ScratchOrg') && !name.containsignorecase('Payment') && !name.containsignorecase('WorkTypeGroup') && !name.containsignorecase('CommSubscription')
                &&!name.containsignorecase('ContactPoint') &&!name.containsignorecase('Company')  &&!name.containsignorecase('Email') &&  !name.containsignorecase('Messaging')
                &&!name.containsignorecase('Fund') && !name.containsignorecase('Budget')&&!name.containsignorecase('Permission')   &&!name.containsignorecase('Party')
                &&!name.containsignorecase('Query')   &&!name.containsignorecase('Collaboration')&&!name.containsignorecase('Consumption')  &&!name.containsignorecase('DataUse')&&!name.containsignorecase('DigitalWallet') &&!name.containsignorecase('Duplicate')
                &&!name.containsignorecase('Engagement') &&!name.containsignorecase('Idea')&&!name.containsignorecase('Macro') &&!name.containsignorecase('Text')&&!name.containsignorecase('Idea') &&!name.containsignorecase('Recommendation')
                &&!name.containsignorecase('Solution')  &&!name.containsignorecase('Streaming')
                &&!name.containsignorecase('Topic') &&!name.containsignorecase('Enhanced')&&!name.equals('Document')) ){ 
                    options.add(name);
                } 
        }
        return options;
    }
    
    @AuraEnabled
    public static List < Record_Data__c > saveCustomObjectData(String objectName, String recordTypeId, Boolean value) {
        try{
            Boolean value1 = false;
            System.debug('ObjectName'+ObjectName);
            System.debug('RecordTypeId'+RecordTypeId);
            System.debug('value'+value);
            String label;
            if(String.isNotBlank(RecordTypeId)){
                label  =[select id, name from RecordType where id=:RecordTypeId].Name;
                System.debug('label'+label); 
            }
            Map < String, Record_Data__c> newmap =  new Map < String, Record_Data__c> ();
            List<Record_Data__c> recordlist = new List<Record_Data__c>();
             List < Record_Data__c > recordatalist = new   List < Record_Data__c > ();
            if(
                Record_Data__c.SObjectType.getDescribe().isAccessible() &&
                Schema.SObjectType.Record_Data__c.fields.Id.isAccessible() &&
                Schema.SObjectType.Record_Data__c.fields.Object_Name__c.isAccessible() &&
                Schema.SObjectType.Record_Data__c.fields.Record_Type_Id__c.isAccessible() &&
                Schema.SObjectType.Record_Data__c.fields.Record_Type_Label__c.isAccessible() &&
                Schema.SObjectType.Record_Data__c.fields.Active__c.isAccessible()
            ){
            recordatalist = [select id, Object_Name__c, Record_Type_Id__c, Active__c, Record_Type_Label__c 
                                                     from Record_Data__c 
                                                     where UserId__c =: UserInfo.getUserId() 
                                                     ORDER BY CreatedDate Asc];
                                                    }
            System.debug('recordatalist'+recordatalist);
            List < Record_Data__c > list1 = new List < Record_Data__c > ();
                if (!recordatalist.isEmpty() && (value == True || value == False) ) {
                    for (Record_Data__c robj: recordatalist) {
                        System.debug('recordlist'+robj);
                        if (robj.Object_Name__c == ObjectName && String.isBlank(RecordTypeId)) {
                            System.debug('step1');
                            robj.Active__c = value;
                            value1 = true;
                            recordlist.add(robj);
                            System.debug('recordlist'+recordlist);
                        } else if (robj.Object_Name__c == ObjectName && robj.Record_Type_Id__c == RecordTypeId) {
                            System.debug('step2');
                            robj.Active__c = value;
                            value1 = true;
                            recordlist.add(robj);
                            System.debug('recordlist'+recordlist);
                        } else {
                            System.debug('step3');
                            robj.Active__c = false;
                            recordlist.add(robj);
                            System.debug('recordlist'+recordlist);
                            Record_Data__c obj = new Record_Data__c();
                            obj.Active__c = True;
                            obj.Object_Name__c = ObjectName;
                            obj.UserId__c = UserInfo.getUserId();
                            if(String.isNotBlank(RecordTypeId)){
                                obj.Record_Type_Label__c= label;
                                obj.Record_Type_Id__c = RecordTypeId; 
                            }
                            if(newmap.isEmpty()){
                                newmap.put(ObjectName,obj);  
                                System.debug('if part');
                            }    
                        
                    }
                } 
            }else {
                    System.debug('case4');
                    Record_Data__c obj = new Record_Data__c();
                    obj.Object_Name__c = ObjectName;
                    obj.Active__c = true;
                    obj.UserId__c = UserInfo.getUserId();
                    if(String.isNotBlank(RecordTypeId) ){
                        obj.Record_Type_Label__c= label;
                        obj.Record_Type_Id__c = RecordTypeId;
                    } 
                    recordlist.add(obj);
                    System.debug('recordlist'+recordlist);
                }
            if (!recordlist.isEmpty()) {
                if(!newmap.isEmpty()){
                    recordlist.add(newmap.values());
                }
                System.debug('recordlist' + recordlist);
                if (!Schema.sObjectType.Record_Data__c.isUpdateable()){
                    return null;
                }
                if (!Schema.sObjectType.Record_Data__c.fields.Record_Type_Id__c.isUpdateable() || !Schema.sObjectType.Record_Data__c.fields.Record_Type_Label__c.isUpdateable() || !Schema.sObjectType.Record_Data__c.fields.Object_Name__c.isUpdateable() || !Schema.sObjectType.Record_Data__c.fields.Active__c.isUpdateable() || !Schema.sObjectType.Record_Data__c.fields.UserId__c.isUpdateable()){
                    return null;
                }else{
                    if( Schema.sObjectType.Record_Data__c.isAccessible() && Schema.sObjectType.Record_Data__c.isCreateable() && Schema.sObjectType.Record_Data__c.isUpdateable()){
                        upsert  recordlist;
                    }
                }
            }
            return recordlist;
        }
        catch(exception e)
        { 
            System.debug('The following exception has occurred: ' + e.getMessage());
            return null;
        }
    }
    
    
    @AuraEnabled
    public static List < RecordType > getRecordTypeList(String sobjectname) {
            List < RecordType > rlist = new   List < RecordType >();
        if(
                RecordType.SObjectType.getDescribe().isAccessible() &&
                Schema.SObjectType.RecordType.fields.Id.isAccessible() &&
                Schema.SObjectType.RecordType.fields.SobjectType.isAccessible()
            ){  
      rlist = [Select id, Name, SobjectType from RecordType where SobjectType =: sobjectname];
            }
                System.debug('list' + rlist);
        return rlist;
    }
    
    @AuraEnabled
    public static Id getRecordTypeId(String recordTypeLabel, String objectname) {
        System.debug('value' + objectname);
        System.debug('vasclue' + recordTypeLabel);
        Id devRecordTypeId = Schema.getGlobalDescribe().get(objectname).getDescribe().getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();
        System.debug('id' + devRecordTypeId);
        return devRecordTypeId;
    }
    @AuraEnabled
    public static List < Record_Data__c > getCustomObjectData() {        
        try{
            List<Record_Data__c> recordata = new   List < Record_Data__c >(); 
             if(
                Record_Data__c.SObjectType.getDescribe().isAccessible() &&
                Schema.SObjectType.Record_Data__c.fields.Id.isAccessible() &&
                Schema.SObjectType.Record_Data__c.fields.Object_Name__c.isAccessible() &&
                Schema.SObjectType.Record_Data__c.fields.Record_Type_Id__c.isAccessible() &&
                Schema.SObjectType.Record_Data__c.fields.Record_Type_Label__c.isAccessible() &&
                Schema.SObjectType.Record_Data__c.fields.Active__c.isAccessible()
            ){
            
            recordata = [select id, Object_Name__c, Active__c, Record_Type_Id__c, Record_Type_Label__c from Record_Data__c where Active__c = True and UserId__c =: UserInfo.getUserId()  order by CreatedDate desc];
            }
            System.debug('record data' + recordata);
            return recordata;
        }
        catch(exception e)
        {
            System.debug('The following exception has occurred: ' + e.getMessage());
            
            return null;
        }
    }
    
    
    public class WrapperClass{
        @AuraEnabled
        public List<String> listofsobject{get;set;}
        @AuraEnabled
        public List <Record_Data__c > returnedCustomObjectData {get;set;}
        @AuraEnabled
        public List <RecordType> listOfRecordType {get;set;}
        
    }
    
    
    @AuraEnabled
    public static wrapperClass initMethod(){
        
        wrapperClass returnwrapperClass = new  wrapperClass ();
        
        returnwrapperClass.listofsobject = getSobjectsList();
        System.debug('value CUSTOM'+returnwrapperClass.listofsobject);
        
        returnwrapperClass.returnedCustomObjectData = getCustomObjectData();
        System.debug('value1' +returnwrapperClass.returnedCustomObjectData);
        if(!returnwrapperClass.returnedCustomObjectData.isEmpty())
        {
            
            returnwrapperClass.listOfRecordType = getRecordTypeList(returnwrapperClass.returnedCustomObjectData[0].Object_Name__c);
            system.debug('TEST NONCASE'+ returnwrapperClass.listOfRecordType);
            
        }
        
        else
        {
            returnwrapperClass.listOfRecordType = getRecordTypeList('Case');
            system.debug('TEST CASE'+ returnwrapperClass.listOfRecordType);
        }
        System.debug('valsaWFue1' +returnwrapperClass);
        
        return returnwrapperClass;
        
    }
    
    
    //init wrapper 
    public class RecordWrapper{
        @AuraEnabled
        public String dataId {get;set;}
        @AuraEnabled
        public String name {get;set;}
        @AuraEnabled
        public String recordObject {get;set;}
        
    }
    
    
    @AuraEnabled
    public static recordWrapper getRecordName(String recordId,String objectname) {
          recordWrapper obj = new recordWrapper();
        if(objectname.contains('Case'))
        {  List<case>  qr = new    List<case>();
            if(case.SObjectType.getDescribe().isAccessible() &&Schema.SObjectType.case.fields.Id.isAccessible() && Schema.SObjectType.case.fields.caseNumber.isAccessible())
            {
                qr =  [select id,caseNumber from case  where id=:recordId];
            }
         /*Case caseNumber1 = Database.query(qr);
         obj.dataId = (Database.query(qr)).Id;*/
         obj.dataId= qr[0].id;
         obj.Name = (string) qr[0].caseNumber;
         obj.recordObject = objectname;
         return obj;
        }
        else  if(objectname.contains('Contract'))
        { List<contract>  qr1 = new List<contract> ();
            if(contract.SObjectType.getDescribe().isAccessible() &&Schema.SObjectType.contract.fields.Id.isAccessible() && Schema.SObjectType.contract.fields.ContractNumber.isAccessible())
            {
                qr1 =  [select id,ContractNumber from contract  where id=:recordId];
            }
          //  string qr =  ('select id,ContractNumber from '+objectname+' where id= \'' + recordId + '\'') ; 
           // Contract caseNumber1=Database.query(qr);
            obj.dataId = qr1[0].id;
            obj.Name = (string) qr1[0].ContractNumber;
            obj.recordObject = objectname;
            return obj; 
            
        }
        else{
            
            string qr2 =  'select id,Name from '+String.escapeSingleQuotes(objectname)+' where id= \'' +String.escapeSingleQuotes(objectname) ; 
            
            sObject record = (sObject) Database.query(qr2);
            
            obj.dataId = (Database.query(qr2)).Id;
            
            obj.Name = (String) record.get('Name');
            obj.recordObject = objectname;
            return obj;
        }
    }
    
}
