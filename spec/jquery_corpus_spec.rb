#require File.expand_path('../spec_helper', __FILE__)
require 'spec_helper'

describe "JqueryCorpus" do
  it "has version string" do
    version = '0.1.2.beta'
    JqueryCorpus.should_receive(:version).and_return(version)
    JqueryCorpus::version.should == version
  end
end
