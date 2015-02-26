$: << File.expand_path('../', __FILE__)
$: << File.expand_path('../lib', __FILE__)

require 'rubygems'
require 'bundler'
require 'sass'
require 'compass'
require 'sinatra/support'
require 'squid/squidhelpers'
require 'sinatra/base'
require 'sinatra/asset_pipeline'
require "sinatra/reloader"
require 'slim'
require 'rouge'
require 'glorify'
require 'app/routes'
require 'squid/generator'

Bundler.require

module Squid
	class App < Sinatra::Base

	  configure do
	  	set 			:server,													:puma
	    set 			:views, 													'views'
	    set 			:root, 														File.expand_path('../', __FILE__)
		  set 			:assets_prefix, 									%w(assets)
		  set 			:public_folder, 									root
		  set 			:digest_assets, 									false
	    set 			:show_exceptions, 								false
	    set 			:raise_errors , 									true
	    set 			:assets_path,   									File.join(root, assets_prefix)
	    set 			:raise_sinatra_param_exceptions,  true
	    disable 	:method_override
	    disable 	:static
	    disable 	:protection
		  register  Sinatra::AssetPipeline
			register  Sinatra::SquidHelpers

	    # Setup Sprockets
	    sprockets.append_path File.join(root, 'assets', 'css')
	    sprockets.append_path File.join(root, 'assets', 'js')
	    sprockets.append_path File.join(root, 'assets', 'img')

	    Compass.configuration do |compass|
	      compass.project_path = root
	      compass.images_dir   = 'img'
	      compass.http_generated_images_path = '/img'
	      compass.sass_dir   = 'css'
	      compass.output_style = development? ? :expanded : :compressed
	    end
	  end

		set :environment, :development

		use Squid::Routes::Index
		use Squid::Routes::Generator
	end
end

