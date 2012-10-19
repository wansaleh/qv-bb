# encoding: utf-8
require "bundler"
Bundler.require

ROOT_DIR = File.expand_path(File.dirname(__FILE__))
Encoding.default_external = "utf-8" if defined?(::Encoding)

def root_path(*args)
  File.join(ROOT_DIR, *args)
end


# The Main Sinatra class
class App < Sinatra::Base

  # Sequel DB connection
  DB = Sequel.mysql2 "quran_sinatra", user: "root", password: "www", host: "localhost"

  # Settings

  set :root,  ROOT_DIR
  set :views, root_path("sinatra/views")

  configure :development do
    use Rack::LiveReload
    register Sinatra::Reloader
  end

  # Compass and SASS options
  Compass.add_project_configuration root_path("config.rb")
  set :scss, Compass.sass_engine_options
  set :sass, Compass.sass_engine_options

  # HAML options
  set :haml,
    :format       => :html5,
    :attr_wrapper => '"',
    :escape_attrs => false,
    :preserve     => ["textarea", "pre", "code"]

  # Not found error
  error 404 do
    content_type :html
    haml :error
  end

  # Internal server error
  error 500 do
    content_type :html
    haml :error
  end

  # Helpers
  helpers do
    include Sinatra::ContentFor

    def body_class
      path_info = request.path_info
      status    = response.status

      classes = []
      parts = path_info.gsub(/^\/|\/$/, '').split(/\//)
      parts.each_with_index { |path, i| classes << parts.first(i + 1).join('-') }

      path_info + ' ' + classes
        .map do |classname|
          classname = 'error' if status != 200
          classname
        end
        .uniq.join(' ')
    end
  end

end

# Require everything
Dir[root_path("{ext,sinatra}/*.rb")].each do |file|
  require file
end
