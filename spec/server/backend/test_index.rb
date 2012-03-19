require 'spec_helper'
module Logbook
  describe Backend, "/" do
    include Rack::Test::Methods

    subject{ get '/' }

    before do
      subject
      last_response.status.should eq(200)
    end

    let(:html){ last_response.body }

    it 'returns an html page' do
      last_response.content_type.should eq('text/html;charset=utf-8')
    end

    it 'has accessible stylesheets' do
      ss = html.scan(/link.*href=["'](.*)["']/).map(&:first)
      ss.each do |stylesheet|
        get(stylesheet)
        last_response.status.should eq(200), "#{stylesheet} is accessible"
        last_response.content_type.should match(/text\/css/)
      end
    end

    it 'has accessible scripts' do
      ss = html.scan(/script.*src=["'](.*)["']/).map(&:first)
      ss.each do |script|
        next if /^http/ =~ script
        get(script)
        last_response.status.should eq(200), "#{script} is accessible"
        last_response.content_type.should match(/javascript/)
      end
    end

  end
end
