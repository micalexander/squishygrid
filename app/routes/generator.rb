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

          default_units      = 12
          default_margin     = 2.5
          default_breakpoint = 420

          if params[:units] != ''

            param :units, Integer, error_message: 'Units must be an Integer', raise: true

          else

            params[:units] = default_units

          end

          if params[:margin] != ''

            param :margin, Float, error_message: 'Margin must be a Float', raise: true

          else

            params[:margin] = default_margin

          end

          if params[:breakpoint] != ''

            param :breakpoint, Integer, error_message: 'Breakpoint must be a Integer', raise: true

          else

            params[:breakpoint] = default_breakpoint

          end

          value = generator.get_grid params[:units],  params[:margin], params[:output], params[:breakpoint], params[:mixin]

        rescue Exception => e

          value = e.options[:error_message]

        end

        html        = "```html\n#{value[0]}\n```"
        html_text   = value[0]
        output = params[:output] == 'less' ? 'sass' : params[:output]
        styles      = "```#{output}\n#{value[1]}\n```"
        styles_text = value[1]

        {
          html:        glorify(html, fenced_code_blocks: 'enabled', line_numbers: true, wrap: true),
          # html:        glorify(html, fenced_code_blocks: 'enabled', line_numbers: true, wrap: true),
          html_text:   html_text,
          styles:      glorify(styles, fenced_code_blocks: 'enabled', line_numbers: true, wrap: true),
          styles_text: styles_text
        }.to_json

        # attachment "grid.css"
        # value

      end
    end
  end
end


