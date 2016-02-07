Feature: Create Category
  As a blog administrator
  In order to categorize articles
  I want to be able to add new categories

  Background:
    Given the blog is set up
    And I am logged into the admin panel

  Scenario: Successfully create category
    Given I am on the new category page
    When I fill in "category_name" with "test_cat_1"
    And I fill in "category_keywords" with "test_cat_key_1"
    And I fill in "category_description" with "test category 1 description"
    And I press "Save"
    Then I should be on the new category page
    And I should see "test_cat_1" in page body