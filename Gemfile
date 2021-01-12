source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

gem 'bootsnap', '>= 1.4.2', require: false
gem 'fb-jwt-auth', '~> 0.4.0'
gem 'metadata_presenter', '~> 0.1.5'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 5.1'
gem 'rails', '~> 6.1.1'
gem 'sentry-raven'
gem 'tzinfo-data'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'httparty'
  gem 'factory_bot_rails'
  gem 'rspec-rails'
end

group :development do
  gem 'brakeman'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
