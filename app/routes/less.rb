module Squid
  module Routes
    class Less < Sinatra::Base

      configure do

        set       :show_exceptions,         App.settings.show_exceptions
        set       :raise_errors,            App.settings.raise_errors
        set       :views,                   App.settings.views
        set       :root,                    App.settings.root
        set       :partial_template_engine, :slim
        mime_type :less,                    'text/css'
        register                            Sinatra::AssetPipeline
        register                            Sinatra::SquidHelpers
        register                            Sinatra::Glorify
        register                            Sinatra::Partial

        Compass.configuration do |compass|
          compass.project_path = App.settings.assets_path
        end

      end
      get '/less' do
        generator = Squid::Generator.new

        attachment "grid.less"
        generator.mixin_grid 'less'
      end
    end
  end
end