$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rack/test'
require 'logbook'

ENV['RACK_ENV'] = "test"
Logbook::Backend.set :environment, :test

module SpecHelpers

  def app
    Logbook::Backend
  end

  RSpec.configure do |c|
    c.extend  SpecHelpers
    c.include SpecHelpers
  end

end
