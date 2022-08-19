source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.5'

gem 'bootsnap', '>= 1.4.2', require: false
gem 'fb-jwt-auth', '~> 0.8.0'
gem 'kaminari'
gem 'metadata_presenter', '~> 2.17.17'
gem 'pg', '>= 0.18', '< 2.0'
gem 'prometheus-client', '~> 2.1.0'
gem 'puma', '~> 5.6'
gem 'rails', '~> 6.1.6'
gem 'sentry-rails', '~> 5.4.1'
gem 'sentry-ruby', '~> 5.4.1'
gem 'tzinfo-data'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'database_cleaner-active_record'
  gem 'factory_bot_rails'
  gem 'httparty'
  gem 'rspec_junit_formatter'
  gem 'rspec-rails'
end

group :development do
  gem 'brakeman'
  gem 'rubocop', '~> 1.31.2'
  gem 'rubocop-govuk'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
