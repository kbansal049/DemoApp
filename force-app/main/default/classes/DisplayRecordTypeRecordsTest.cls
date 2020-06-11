@isTest
public class DisplayRecordTypeRecordsTest {
    
    @testSetup static void testSetupMethod() {
       Record_Data__c obj= new Record_Data__c();
        List < RecordType > rlist = DisplayRecordTypeRecordsTestHelper.RecordTypeList('Case');
        obj.Object_Name__c = 'Case';
        obj.Record_Type_Id__c = rlist[0].id;
        obj.Active__c = true;
        insert obj;
        
      /*  Record_Data__c obj1= new Record_Data__c();
        obj1.Object_Name__c = 'Account';
        obj1.Active__c = true;
        insert obj1;*/
    }
    
    @isTest static void getSobjectsListTest() {
        List < String > options = DisplayRecordTypeRecords.getSobjectsList();
    }
    
    @isTest static void saveCustomObjectDataTest() {
        List < RecordType > rlist = DisplayRecordTypeRecordsTestHelper.RecordTypeList('Case');
        
        List < Record_Data__c > obj = DisplayRecordTypeRecords.saveCustomObjectData('Case',rlist[0].id,true);
        List < Record_Data__c > obj1 = DisplayRecordTypeRecords.saveCustomObjectData('Case',rlist[0].id,false);
        List < Record_Data__c > obj2 = DisplayRecordTypeRecords.saveCustomObjectData('Case','',false);
        List < Record_Data__c > obj3 = DisplayRecordTypeRecords.saveCustomObjectData('Case',rlist[1].id,true);
    }
      @isTest static void saveCustomObjectDataTest1() {
       DisplayRecordTypeRecords.initMethod();
    }

    @isTest static void getRecordTypeListTest() {
        List < RecordType > rlist =  DisplayRecordTypeRecords.getRecordTypeList('Case');
        List < RecordType > rlist1 = DisplayRecordTypeRecordsTestHelper.RecordTypeList('Case');
        System.assertEquals(rlist1.size(), rlist.size());
    }
    
    @isTest static void getRecordTypeIdTest() {
        List < RecordType > rlist = DisplayRecordTypeRecordsTestHelper.RecordTypeList('Case');
        Id devRecordTypeId = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosByName().get(rlist[0].Name).getRecordTypeId();
        Id objectid =  DisplayRecordTypeRecords.getRecordTypeId(rlist[0].Name,'Case');
        System.assertEquals(devRecordTypeId, objectid);
    }
    
    @isTest static void getCustomObjectDataTest() {
        List < Record_Data__c > recordata =  DisplayRecordTypeRecords.getCustomObjectData();
        System.assertEquals(1, recordata.size());
    }
    
      @isTest static void initMethodTest() {
         DisplayRecordTypeRecords.initMethod();
    }
    
     @isTest static void getRecordNameTest() {
         List < RecordType > rlist = DisplayRecordTypeRecordsTestHelper.RecordTypeList('Case');
         DisplayRecordTypeRecords.getRecordName(rlist[0].Id,'Case');
    }
}