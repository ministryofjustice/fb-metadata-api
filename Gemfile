source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.3'

gem 'bootsnap', '>= 1.4.2', require: false
gem 'fb-jwt-auth', '~> 0.7.0'
gem 'metadata_presenter', '~> 1.2.1'
gem 'pg', '>= 0.18', '< 2.0'
gem 'prometheus-client', '~> 2.1.0'
gem 'puma', '~> 5.3'
gem 'rails', '~> 6.1.3'
gem 'sentry-rails', '~> 4.5.0'
gem 'sentry-ruby', '~> 4.5.0'
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
