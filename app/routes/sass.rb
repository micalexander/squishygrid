module Squid
  module Routes
    class Sass < Sinatra::Base

      configure do

        set       :show_exceptions,         App.settings.show_exceptions
        set       :raise_errors,            App.settings.raise_errors
        set       :views,                   App.settings.views
        set       :root,                    App.settings.root
        set       :partial_template_engine, :slim
        mime_type :scss,                    'text/css'
        register                            Sinatra::AssetPipeline
        register                            Sinatra::SquidHelpers
        register                            Sinatra::Glorify
        register                            Sinatra::Partial

        Compass.configuration do |compass|
          compass.project_path = App.settings.assets_path
        end

      end
      get '/sass' do
        generator = Squid::Generator.new

        attachment "grid.scss"
        generator.mixin_grid 'sass'
      end
    end
  end
end


