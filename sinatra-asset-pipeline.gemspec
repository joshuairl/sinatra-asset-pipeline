$:.unshift File.expand_path("../lib", __FILE__)

require 'sinatra/asset_pipeline/version'

Gem::Specification.new do |gem|
  gem.name = "sinatra-asset-pipeline"
  gem.version = Sinatra::AssetPipeline::VERSION
  gem.authors = ["Joakim Ekberg"]
  gem.email = ["jocke.ekberg@gmail.com"]
  gem.description = "An asset pipeline implementation for Sinatra based on Sprockets with support for SASS, CoffeeScript and ERB."
  gem.summary = "An asset pipeline implementation for Sinatra."
  gem.homepage = "https://github.com/kalasjocke/sinatra-asset-pipeline"

  gem.files = Dir["README.md", "lib/**/*.rb"]
  gem.add_dependency 'rake'
  gem.add_dependency 'sinatra'
  gem.add_dependency 'sass'
  gem.add_dependency 'haml_coffee_assets'
  gem.add_dependency 'active_support'
  gem.add_dependency 'coffee-script'
  gem.add_dependency 'sprockets'
  gem.add_dependency 'sprockets-sass'
  gem.add_dependency 'sprockets-helpers'
  gem.add_development_dependency 'rspec'
end
