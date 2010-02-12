Feature: Generator generates files
  The generator
  Should be able to generate resources
  So that we can build prototypes quickly
  
  Scenario: Generator generates scaffold for top-level plural resource
  
  Given a new rails app
  When I generate a scaffold for the following resource:
   | name | attributes             | singleton | scope |
   | post | title:string body:text | no        |       |
  Then the file 'app/controllers/posts_controller.rb' should be generated
  And the generated file should look like 'reference_templates/posts_controller'
  
  Scenario: Generator generates scaffold for nested (one level) plural resource 
  
  Given a new rails app
  When I generate a scaffold for the following resource:
   | name    | attributes | singleton | scope |
   | comment | body:text  | no        | posts |
  Then the file 'app/controllers/post_comments_controller.rb' should be generated
  And the generated file should look like 'reference_templates/post_comments_controller'
