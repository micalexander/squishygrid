module Squid
  module Routes
    class Generator < Sinatra::Base

      helpers Sinatra::Param

      configure do

        set :show_exceptions, App.settings.show_exceptions
        set :raise_errors,    App.settings.raise_errors
        set :views,           App.settings.views
        set :root,            App.settings.root
        register              Sinatra::AssetPipeline
        register              Sinatra::Helpers
        register              Sinatra::Glorify
        Compass.configuration do |compass|
          compass.project_path = App.settings.assets_path
        end
      end

      def self.cache
        @cache ||= {}
      end

      helpers do
        def ios?
          request.user_agent =~ /iPhone|iPod/
        end

        def cache(key)
          self.class.cache[key] ||= yield
        end
      end

      get '/generator' do

          cache(:generator) { slim :generator, :locals => { :title => 'SquishyGrid | Generator', :body_class => 'generator'} }

      end

      # error Sinatra::Param::InvalidParameterError do

      #     value = "#{env['sinatra.error'].param} is invalid"

      #     # cache(:generator) { slim :generator, :locals => { :title => 'SquishyGrid | Generator', :value => value } }
      # end

      post '/generator' do

        generator = Squid::Generator.new

        begin

          default_columns = 12
          default_gutter  = 2.5
          default_at      = 420

          if params[:columns] != ''

            param :columns, Integer, error_message: 'Columns must be an Integer', raise: true

          else

            params[:columns] = default_columns

          end

          if params[:gutter] != ''

            param :gutter, Float, error_message: 'Gutter must be a Float', raise: true

          else

            params[:gutter] = default_gutter

          end

          if params[:at] != ''

            param :at, Integer, error_message: 'At must be a Integer', raise: true

          else

            params[:at] = default_at

          end

          value = generator.get_grid params[:columns],  params[:gutter], params[:at], params[:output], params[:mixin]

          html        = "```html\n#{value[0]}\n```"
          html_text   = value[0] # Copy to Clipboard
          output      = params[:output] == 'less' ? 'sass' : params[:output]
          styles      = "```#{output}\n#{value[1]}\n```"
          styles_text = value[1]  # Copy to Clipboard

        rescue Exception => e

          value = e.options[:error_message]

          html        = "```html\n#{value}\n```"
          html_text   = value # Copy to Clipboard
          output      = params[:output] == 'less' ? 'sass' : params[:output]
          styles      = "```#{output}\n#{value}\n```"
          styles_text = value  # Copy to Clipboard

        end

          {
            html:        glorify(html, fenced_code_blocks: 'enabled', line_numbers: true, wrap: true),
            html_text:   html_text,  # Copy to Clipboard
            styles:      glorify(styles, fenced_code_blocks: 'enabled', line_numbers: true, wrap: true),
            styles_text: styles_text  # Copy to Clipboard
          }.to_json

      end
    end
  end
end


