# LiveSql

Hello friends! live_sql is a little program I wrote to watch how your sqlite queries change your results as you type. This is a baby gem. It's has a few known bugs, probably way more unknown bugs, not to mention it could use some sexy new features. If you want to contribute either by pointing out bugs, fixing problems. or adding new features, your help would be greatly appreciated!

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

To use the test database, just download this repo and run bin/console. You can check out how it works with a simple actor, casting, and movie table.

To use on any sqlite3 db, navigate to the folder containing the db, run pry (or irb) and

    require 'live_sql'
    LiveSQL.run_with('your-db-name-here.db')

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fsladkey/live_sql

## Running list of bugs and potential features:

  - Oh god, I already forgot the most recent bug. It'll come back to me....

  - The most obvious extension is to get this thing hooked up to postgres as well as sqlite3.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
