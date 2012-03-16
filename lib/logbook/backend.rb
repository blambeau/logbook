module Logbook
  class Backend < Sinatra::Base
    ROOT = Path.backfind(".[public]")

    set :public_folder, ROOT/:public

    unless environment.to_s == "production"
      require_relative 'helpers/nocache'
      use Rack::Nocache
    end

    get '/' do
      send_file settings.public_folder/"index.html"
    end

    get '/logs' do
      require_relative "helpers/data_generator"
      content_type 'application/json', :charset => 'utf-8'
      fields = [:no, :first_name, :last_name, :cause, :treatment, :room]
      JSON.dump Helpers::DataGenerator.new(fields, 100).to_a
    end

  end # class Backend
end # module LogBook
