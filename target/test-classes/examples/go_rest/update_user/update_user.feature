Feature: Update newly created user

  Background:
    * def getUser = karate.callSingle('classpath:examples/go_rest/get_user/get_user.feature@Smoke')
    * url base_url
    * path update_user_uri

    #TO DO - find function to randomly get emails
    * def randomEmail = getUser.getEmail

    * def default_request = {name: "John", gender: male, status: active}
    * default_request.email = randomEmail

    * print default_request

    @Smoke
    Scenario: Update user after creation
      * default_request.name =  'Jane'
      * default_request.gender =  'female'
      * default_request.email =  'janedoe18@gmail.com'
      * default_request.status =  'inactive'
#      * default_request.email =  'janedoe@gmail.com'
#      * default_request.status =  'inactive'

      And path getUser.getUserId
      And request default_request
      And header Authorization = 'Bearer ' + tokenID
      When method put
      Then status 200

      * match response == "#object"
      * match response.id == getUser.getUserId
      * match response.name == default_request.name
      * match response.gender == default_request.gender
      * match response.email == default_request.email
      * match response.status == default_request.status

