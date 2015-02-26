# http://blog.sourcing.io/structuring-sinatra
module Squid
  module Routes
    autoload :Index, 'app/routes/index'
    autoload :Generator, 'app/routes/generator'
  end
end