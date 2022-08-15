Feature: Delete newly created user

  Background:
    * def createUser = karate.callSingle('classpath:examples/go_rest/create_user/create_user.feature@Smoke')
    * url base_url
    * path delete_user_uri

    @Smoke
    Scenario: Delete user after creating
      And path createUser.createdUserId
      And header Authorization = 'Bearer ' + tokenID
      When method delete
      Then status 204

      Then def deletedUserId = createUser.createdUserId

