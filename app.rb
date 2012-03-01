require 'rubygems'
require 'mustache'
require 'sinatra'
require 'yaml'

set :public_folder, File.expand_path('../public', __FILE__)

get '/' do
  views = File.expand_path('../views', __FILE__)
  data = YAML.load_file File.join(views, 'data.yml')
  tpl  = File.read File.join(views, 'index.mustache')
  Mustache.render(tpl, data)
end

