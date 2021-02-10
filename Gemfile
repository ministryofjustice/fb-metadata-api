source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

gem 'bootsnap', '>= 1.4.2', require: false
gem 'fb-jwt-auth', '~> 0.5.0'
gem 'metadata_presenter', '~> 0.7.1'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 5.2'
gem 'rails', '~> 6.1.2'
gem 'sentry-raven'
gem 'tzinfo-data'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'httparty'
  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'database_cleaner-active_record'
end

group :development do
  gem 'brakeman'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
