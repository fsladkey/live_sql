# LiveSql

Hello friends! live_sql is a little program I wrote to watch how your SQL queries change your results as you type. This is a baby gem, so contributions are welcome! Fixing problems, adding new features, or reporting bugs is greatly appreciated!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'live_sql'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install live_sql

## Usage

### Running from the Terminal
To use with a postgres db, simply run:

    live_sql your_database_name_here

To use sqlite3 db, navigate to the folder containing the db and run

    live_sql your_database_name_here.db sqlite3


### Using the class

The gem exposes the LiveSQL object. To open the interface create a new instance, and call the run method.

```ruby
options = { db: :sqlite3, limit: 40 }
LiveSQL.new(your_database_name, options).run
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fsladkey/live_sql

## Running list of bugs and potential features:

  - Allow aggregate functions to be included in select but not actually used in the query until a group by clause is added.

  - Allow cursor navigation by holding down command/option for jumping words etc.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
