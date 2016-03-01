# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'live_sql/version'

Gem::Specification.new do |spec|
  spec.name          = "live_sql"
  spec.version       = LiveSql::VERSION
  spec.authors       = ["Fred Sladkey"]
  spec.email         = ["fsladkey@gmail.com"]
  spec.executables   = ["live_sql"]

  spec.summary       = %q{Live updating database querying utility.}
  spec.description   = %q{Interact with psql/sqlite3 database and watch your results change as you type the query.}
  spec.homepage      = "https://github.com/fsladkey/Live-SQL"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "thor", "~> 0.19"

  spec.add_dependency 'sqlite3', '1.3.11'
  spec.add_dependency 'pg', '0.18.4'
  spec.add_dependency 'colorize', '0.7.7'
  spec.add_dependency 'table_print', '1.5.4'
end
