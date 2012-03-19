require File.expand_path('../spec_helper', __FILE__)
describe Logbook do

  it "should have a version number" do
    Logbook.const_defined?(:VERSION).should be_true
  end

end
