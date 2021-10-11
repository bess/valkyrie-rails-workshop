gem_group :development, :test do
  gem 'pry-byebug'
  gem 'pry-rails'
end

gem_group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'xray-rails'
end

gem_group :test do
  gem 'database_cleaner'
  gem 'launchy'
  gem 'rspec'
  gem 'rspec-its'
  gem 'rspec-rails'
  gem 'shoulda-matchers', '~> 3.1'
end

run "bundle install"

environment 'config.generators { |generator| generator.test_framework :rspec }'

after_bundle do
  generate "rspec:install"
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial Rails application setup' }
end
