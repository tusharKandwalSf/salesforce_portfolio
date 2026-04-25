@isTest
private class ExternalUserServiceTest {

    @isTest
    static void testExternalUserService(){
        Test.setMock(HttpCalloutMock.class, new ExternalUserServiceMock());
        List<ExternalUserService.ExternalUserWrapper> users = ExternalUserService.fetchExternalUsers();
        System.assertEquals(2, users.size(), 'Size of the user list should be 2');
    }

    @isTest
    static void testExternalUserBatch(){
        Test.setMock(HttpCalloutMock.class, new ExternalUserServiceMock());
        UserSyncBatch batch = new UserSyncBatch();
        Test.startTest();
        Database.executeBatch(batch);
        Test.stopTest();
        List<Contact> conList = [Select Id,FirstName,LastName from Contact where FirstName like 'MockTest%'];
        System.assertEquals(2, conList.size(), 'Size of the contact list should be 2');
    }
}