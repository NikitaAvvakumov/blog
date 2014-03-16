This blog is deployed at [https://quoth-blog.herokuapp.com/](https://quoth-blog.herokuapp.com/)

A blog application written in Ruby on Rails
* Ruby version: 2.1.0
* Rails version: 4.0.2

This blog app is intended for use by a single blogger or a small team of known, trusted bloggers. All users have ability to create and delete users, and modify any profile or article. Comments on articles are open to the public and require a visitor's name but not email to be posted. Comments are not editable but can be deleted by any logged in writer.

At present, no helpers are included for article creation. Therefore, all markup, image insertion, link creation etc. are done by hand. Article contents are marked 'html_safe' to enable insertion of JavaScript. Comments are sanitized. When displayed in index view (root) or on a writer's page, posts are truncated on ---MORE---, which can be manually entered in post bodies.

The blog uses the Paperclip gem to handle uploads of user profile pictures. Bootstrap styling and layout via the Bootstrap-SASS gem. The app is deployable to Heroku and includes the pg gem in the Production group.

#Log of features and key modifications:
-14/03/2014: Post topics added
-10/03/2014: Paperclip configured to use Dropbox storage
-03/03/2014: Commenting system improved to include AJAX for posting & deleting comments without page reloads; comment formatting enhanced

-02/03/2014: Comments created as a nested resource of Posts

-26/02/2014: Vanity URLs created for blog's writers

-23/02/2014: Paperclip gem added to enable bloggers to upload their profile images

-06/02/2014: Sessions implemented to enable user authentication

-03/02/2014: Users resource created

-01/02/2014: Basic app layout finished with Bootstrap

-31/02/2014: Initial commit and Posts resource created