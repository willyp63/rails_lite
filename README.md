# Rails Lite

Backend application framework inspired by Rails, includes ORM inspired by Active Record

## Implementation

Rails Lite is built on top of a simple webserver interface called Rack. The Rails Lite router handles incoming HTTP requests and passes them off to a controller's action based on the application's routes. The controller is free to make database interactions, but must render a view or redirect to another URL. The result of the action is turned into an HTTP response and sent back to the client.

Controllers have access to both a Flash and a Session object, allowing information to persist for the next request.

Rails Lite's ORM supports one-to-one, one-to-many, and through relations. This is achieved by saving information about the tables and keys for each relationship. Meta programming is then used to create retrieval methods for relationships and column values.

Rails Lite uses a SQLite database and the ruby gem active_support-inflector convert between naming conventions.

 Custom middleware is used for rendering server side errors and sending static resources.

## installation
- Download or clone the repo.
- Navigate to the root directory.
- `gem install rails_lite-1.0.0.gem`

## Launch the Example App!
- Follow installation instructions.
* `cd example_app`
* `rails_lite rdb`
* `rails_lite s`
* Open your browser and navigate to `http://localhost:3000/`

![screenshot]
[screenshot]: ./docs/screenshots/example-app.jpg

## Documentation
* Create new Project: `rails_lite new [project_name]`
* Launch the Server: `rails_lite server`
* Create/Reset the Database: `rails_lite reset_database`

 Routes can easily be defined in `config/routes.rb`. The database can be built manually or from within `db/[project_name].sql`.

 Your Controllers need to subclass `ApplicationController` and models need to subclass `ModelBase`.

 Views are written in HTML and ERB.
