#useful links here
Feature: Create a user

  Background:
    * url base_url
    * path create_user_uri

    * def default_request = {name: "Amanda", gender: female, email: amand30@gmail.com, status: active}
    * def schema = {id: #number,name: #string,email: #string,gender: #string,status: #string}

    * def invalid_email_response = {field: email, message: is invalid}
    * def null_email_response = {field: email, message: can't be blank}
    * def existing_email_response = {field: email, message: has already been taken}

    * def invalid_gender_response = {"field": "gender", "message": "can't be blank, can be male or female"}

  @Smoke
  Scenario: Create new user
    And request default_request
    And header Authorization = 'Bearer ' + tokenID
    When method post
    Then status 201
    * match response == "#object"
    * match response == schema


  @Regression
  Scenario Outline: Validating email with <attribute>
    * default_request.email = <email>
    And request default_request
    And header Authorization = 'Bearer ' + tokenID
    When method post
    Then status <status code>

    * match response == '#array'
    * match response[0] == <resp>
    Examples:
      | email                | attribute      | status code | resp                    |
      | 'amanda'             | invalid email  | 422         | invalid_email_response  |
      | null                 | null email     | 422         | null_email_response     |
      | 'amanda16@gmail.com' | existing email | 422         | existing_email_response |
      | ''                   | empty email    | 422         | null_email_response     |


  @Regression
  Scenario Outline: Validating gender with <attribute>
    * default_request.gender = <gender>
    And request default_request
    And header Authorization = 'Bearer ' + tokenID
    When method post
    Then status <status code>

    * match response == '#array'
    * match response[0] == <resp>
    Examples:
      | gender | attribute      | status code | resp                    |
      | 'abcd' | invalid gender | 422         | invalid_gender_response |
      | null   | null gender    | 422         | invalid_gender_response |
      | ''     | empty gender   | 422         | invalid_gender_response |
      | 1234   | int gender     | 422         | invalid_gender_response |
      | true   | boolean gender | 422         | invalid_gender_response |


  @Regression
  Scenario Outline: Validating missing field <attribute>
    * karate.forEach(<key>, function(k) {karate.remove('default_request', k)})
    And request default_request
    And header Authorization = 'Bearer ' + tokenID
    When method post
    Then status 422

    Examples:
      | key                                   | attribute |
      | ['name']                              | name      |
      | ['gender']                            | gender    |
      | ['email']                             | email     |
      | ['status']                            | status    |
      | ['name', 'gender']                    | status    |
      | ['name', 'email']                     | status    |
      | ['name', 'status']                    | status    |
      | ['name', 'gender', 'email']           | status    |
      | ['name', 'gender', 'email', 'status'] | status    |