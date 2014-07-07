migrations.
sequel has a migration tool. see below for some basic info.
probably wanna a rake file.
need ruby mysql drivers. gem install mysql.

possible cmd. this actually works..
sequel -m migrations/ mysql2://root:password@localhost/stock5_test



http://sequel.jeremyevans.net/rdoc/files/doc/migration_rdoc.html

sequel -m path/to/migrations postgres://host/database