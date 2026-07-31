source "https://rubygems.org"

gem "cocoapods", "~> 1.16"
gem "fastlane", "~> 2.228"

group :development do
	gem "rubocop", "~> 1.82.1", require: false
end

plugins_path = File.join(File.dirname(__FILE__), "fastlane", "Pluginfile")
eval_gemfile(plugins_path) if File.exist?(plugins_path)
