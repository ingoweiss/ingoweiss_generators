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
  And the routes should contain 'resources :posts'
  And the migration 'create_posts' should be generated
  And the generated file should look like 'reference_templates/create_posts'
  And the file 'app/views/posts/index.html.erb' should be generated
  And the generated file should look like 'reference_templates/posts/index'
  And the file 'app/views/posts/new.html.erb' should be generated
  And the generated file should look like 'reference_templates/posts/new'
  And the file 'app/views/posts/_form.html.erb' should be generated
  And the generated file should look like 'reference_templates/posts/_form'
  
  Scenario: Generator generates scaffold for nested (one level) plural resource 
  
  Given a new rails app
  When I generate a scaffold for the following resource:
   | name    | attributes | singleton | scope |
   | comment | body:text  | no        | posts |
  Then the file 'app/controllers/post_comments_controller.rb' should be generated
  And the generated file should look like 'reference_templates/post_comments_controller'
  And the routes should contain 'resources :comments'
  And the migration 'create_comments' should be generated
  And the generated file should look like 'reference_templates/create_comments'
  And the file 'app/views/post_comments/index.html.erb' should be generated
  And the generated file should look like 'reference_templates/post_comments/index'
  
  Scenario: Generator generates scaffold for nested (two levels) singular resource 
  
  Given a new rails app
  When I generate a scaffold for the following resource:
   | name     | attributes     | singleton | scope           |
   | approval | result:boolean | yes       | posts, comments |
  Then the file 'app/controllers/post_comment_approval_controller.rb' should be generated
  And the generated file should look like 'reference_templates/post_comment_approval_controller'
  And the routes should contain 'resource :approval'
  And the migration 'create_approvals' should be generated
  And the generated file should look like 'reference_templates/create_approvals'
