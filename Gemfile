source 'https://rubygems.org'


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

# gem 'farm_scrape', :git => 'https://github.com/jessethebuilder/farm_scrape'
gem 'farm_scrape', :path => 'C:\Users\Bucky\Desktop\jesseweb\farm_scrape'

group :production do
  gem 'phantomjs', :require => 'phantomjs/poltergeist'
end
# gem 'poltergeist'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

ruby '2.2.4'
