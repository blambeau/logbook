require 'spec_helper'
require 'logbook/helpers'
module Logbook
  module Helpers
    describe DataGenerator do

      subject do
        DataGenerator.new(fields, size)
      end

      let(:fields){ [:first_name, :last_name, :cause, :room] }
      let(:size)  { 2 }

      it 'is an enumerable of tuples' do
        seen = 0
        subject.each do |t|
          t.should be_a(Hash)
          t.keys.should eq([ :id ] + fields)
          seen += 1
        end
        seen.should eq(size)
      end

    end
  end
end
