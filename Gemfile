source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

gem 'bootsnap', '>= 1.4.2', require: false
gem 'fb-jwt-auth', '~> 0.6.0'
gem 'metadata_presenter', '~> 1.0.6'
gem 'pg', '>= 0.18', '< 2.0'
gem 'prometheus-client', '~> 2.1.0'
gem 'puma', '~> 5.2'
gem 'rails', '~> 6.1.3'
gem 'sentry-rails', '~> 4.4.0'
gem 'sentry-ruby', '~> 4.4.0'
gem 'tzinfo-data'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'database_cleaner-active_record'
  gem 'factory_bot_rails'
  gem 'httparty'
  gem 'rspec-rails'
end

group :development do
  gem 'brakeman'
  gem 'rubocop', '~> 1.10.0'
  gem 'rubocop-govuk'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
