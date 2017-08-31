source 'https://rubygems.org'

gem 'sass-rails', '~> 5.0'
gem 'jquery-rails'
gem 'bootstrap-sass', '~> 3.0.3.0'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0'
# Use sqlite3 as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 3.0'

gem 'uglifier'
gem 'jbuilder', '~> 2.5'

gem 'farm_ruby', :git => 'https://github.com/jessethebuilder/farm_ruby'
# gem 'farm_ruby', :path => 'C:\Users\Bucky\Desktop\jesseweb\farm_ruby'

gem 'farm_scrape', :git => 'https://github.com/jessethebuilder/farm_scrape'
# gem 'farm_scrape', :path => 'C:\Users\Bucky\Desktop\jesseweb\farm_scrape'

gem 'rest-client'

gem 'kaminari'

gem 'aws-sdk', '~> 2'

group :production do
  gem 'phantomjs', :require => 'phantomjs/poltergeist'
end
# gem 'poltergeist'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

ruby '2.3.1'
