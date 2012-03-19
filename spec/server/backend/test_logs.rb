require 'spec_helper'
module Logbook
  describe Backend, "/logs" do
    include Rack::Test::Methods

    subject{ get '/logs' }

    before do
      subject
      last_response.status.should eq(200)
    end

    it 'returns json by default' do
      last_response.content_type.should eq('application/json;charset=utf-8')
    end

    it 'returns an array of tuples' do
      tuples = JSON.parse last_response.body
      tuples.should be_a(Array)
      tuples.each do |t|
        t.should be_a(Hash)
      end
    end

  end
end
