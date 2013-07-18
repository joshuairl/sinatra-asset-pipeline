require 'sprockets'
require 'sprockets-sass'
require 'sprockets-helpers'
require 'active_support'

module Sinatra
  module AssetPipeline
    def self.registered(app)
      app.set_default :sprockets, Sprockets::Environment.new
      app.set_default :assets_precompile, %w(app.js app.css *.png *.jpg *.svg *.eot *.ttf *.woff)
      app.set_default :assets_prefix, '/assets'
      app.set_default :assets_path, -> { File.join(public_folder, assets_prefix) }
      app.set_default :assets_protocol, :http
      app.set_default :assets_css_compressor, :none
      app.set_default :assets_js_compressor, :none

      app.set :static, true
      app.set :assets_digest, true
      app.set :static_cache_control, [:public, :max_age => 525600]

      app.configure do
        puts "config starting"
        ['stylesheets', 'javascripts', 'images', 'fonts'].each do |dir|
          app.sprockets.append_path(File.join('app','assets', dir))
          app.sprockets.append_path(File.join('vendor','assets', dir))
        end
        
        app.sprockets.cache = ActiveSupport::Cache::FileStore.new("tmp/cache/assets")
        
        Sprockets::Helpers.configure do |config|
          config.environment = app.sprockets
          config.assets_prefix = app.assets_prefix
          config.digest = app.assets_digest
        end
      end

      app.configure :staging, :production do
        puts "config staging / production"
        Sprockets::Helpers.configure do |config|
          config.manifest = Sprockets::Manifest.new(app.sprockets, app.assets_path)
          config.digest = app.assets_digest
        end
      end

      app.configure :production do
        puts "config production"
        app.sprockets.css_compressor = app.assets_css_compressor unless app.assets_css_compressor == :none
        app.sprockets.js_compressor = app.assets_js_compressor unless app.assets_js_compressor == :none

        Sprockets::Helpers.configure do |config|
          config.protocol = app.assets_protocol
          config.asset_host = app.assets_host if app.respond_to? :assets_host
        end
      end

      app.helpers Sprockets::Helpers

      app.configure :development do
        puts "config development"
        app.get '/assets/*' do |key|
          key.gsub! /(-\w+)(?!.*-\w+)/, ""
          asset = app.sprockets[key]
          content_type asset.content_type
          asset.to_s
        end
      end
    end

    def set_default(key, default)
      self.set(key, default) unless self.respond_to? key
    end
  end
end
