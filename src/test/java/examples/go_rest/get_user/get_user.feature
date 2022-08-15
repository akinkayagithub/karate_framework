Feature: Get newly created user

  Background:
    * def createUser = karate.callSingle('classpath:examples/go_rest/create_user/create_user.feature@Smoke')
    * def deleteUser = karate.callSingle('classpath:examples/go_rest/delete_user/delete_user.feature@Smoke')
    * url base_url
    * path get_user_uri


  @Smoke
  Scenario: Validate newly created user
    * def userCreatedName = createUser.createdName
    * def userCreatedGender = createUser.createdGender
    * def userCreatedEmail = createUser.createdEmail
    * def userCreatedStatus = createUser.createdStatus
    * def userCreatedId = createUser.createdUserId

    And path userCreatedId
    And header Authorization = 'Bearer ' + tokenID
    When method get
    Then status 200

    * match response == "#object"
    * match userCreatedId == response.id
    * match userCreatedName == response.name
    * match userCreatedGender == response.gender
    * match userCreatedEmail == response.email
    * match userCreatedStatus == response.status

    Then def getUserId = response.id
    Then def getName = response.name
    Then def getGender = response.gender
    Then def getEmail = response.email
    Then def getStatus = response.status


  @Regression
  Scenario Outline: Get newly created user with invalid id <id>
    * def invalid_id_response = {message: Resource not found}

    And path <id>
    And header Authorization = 'Bearer ' + tokenID
    When method get
    Then status 404

    * match response == "#object"
    * match response == invalid_id_response

    Examples:
      | id        |
      | 'null'    |
      | 123434634 |
      | 'abcd'    |
#      | ''        |
      | -123      |
      | true      |

  @Regression
  Scenario: Make sure user is deleted
    And path deleteUser.deletedUserId
    And header Authorization = 'Bearer ' + tokenID
    When method get
    Then status 404

    * match response == {message: Resource not found}
