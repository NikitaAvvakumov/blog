A blog application written in Ruby on Rails
Ruby version: 2.1.0
Rails version: 4.0.2

This blog app is intended for use by a single blogger or a small team of known, trusted bloggers. All users have ability to create and delete users, and modify any profile or article. Comments on articles are open to the public and require a visitor's name but not email to be posted. Comments are not editable but can be deleted by any logged in writer.

At present, no helpers are included for article creation. Therefore, all markup, image insertion, link creation etc. are done by hand. Article contents are marked 'html_safe' to enable insertion of JavaScript. Comments are sanitized. When displayed in index view (root) or on a writer's page, posts are truncated on ---MORE---, which can be manually entered in post bodies.

The blog uses the Paperclip gem to handle uploads of user profile pictures. Bootstrap styling and layout via the Bootstrap-SASS gem. The app is deployable to Heroku and includes the pg gem in the Production group.

#Log of features and key modifications:
-03/03/2014: Commenting system improved to include AJAX for posting & deleting comments without page reloads.
    * a visitor's just-posted comment(s) are highlighted in blue.
    * comments by blog writers are treated differently: when a writer posts a comment while logged in, his/her name is pre-filled in the comment entry form and is not editable. After posting, the comment receives a yellow highlight and "@ blog-name" is appended to the writer's name.

-02/03/2014: Comments created as a nested resource of Posts

-26/02/2014: Vanity URLs created for blog's writers

-23/02/2014: Paperclip gem added to enable bloggers to upload their profile images

-06/02/2014: Sessions implemented to enable user authentication

-03/02/2014: Users resource created

-01/02/2014: Basic app layout finished with Bootstrap

-31/02/2014: Initial commit and Posts resource created

#Deployment:
After deployment to Heroku and database migrations, the first user must be created manually via the Heroku console. Required attributes:
* name
* email (format validated)
* title
* password (min 8)
* password_confirmation (must match password)
* bio