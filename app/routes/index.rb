module Squid
  module Routes
    class Index < Sinatra::Base

      configure do

        set :show_exceptions, App.settings.show_exceptions
        set :raise_errors,    App.settings.raise_errors
        set :views,           App.settings.views
        set :root,            App.settings.root
        register              Sinatra::AssetPipeline
        register              Sinatra::SquidHelpers
        register              Sinatra::Glorify

        Compass.configuration do |compass|
          compass.project_path = App.settings.assets_path
        end

      end

      get '/' do
        slim :index, :locals => { :title => 'SquishyGrid | A fluid responsive grid system', :body_class => 'index'}
      end
    end
  end
end


