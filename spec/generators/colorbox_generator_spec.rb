#require File.expand_path('../../spec_helper', __FILE__)
require 'spec_helper'
require 'generators/jquery/colorbox/colorbox_generator'

describe Jquery::Generators::ColorboxGenerator do
  before do
    @destination = File.join('tmp', 'test_app')
    @source = Jquery::Generators::ColorboxGenerator.source_root
    @generator = Jquery::Generators::ColorboxGenerator.new(
      [], {}, {:destination_root => @destination}
    )
    @app_tmp_path = "tmp/jquery"
    @unzip_path = "#{@app_tmp_path}/colorbox"
  end

  after do
    FileUtils.rm_rf(@destination)
  end

  it "fetch colorbox files from remote" do
    zip_file = "colorbox.zip"
    download_path = "http://colorpowered.com/colorbox"
    @generator.options[:zip].should be_nil
    @generator.should_receive(:empty_directory).with(@app_tmp_path).and_return(true)
    File.should_receive(:exists?).with(zip_file).and_return(false)
    @generator.should_receive(:get).with("#{download_path}/#{zip_file}", zip_file).and_return(true)
    @generator.should_receive(:run).with("unzip #{zip_file} -d .", :verbose => false).and_return(true)
    @generator.fetch_colorbox_files
  end

  it "fetch colorbox files from local" do
    zip_file = "my_colorbox.zip"
    @generator = Jquery::Generators::ColorboxGenerator.new(
      [], {:zip => zip_file}, {:destination_root => @destination}
    )
    @generator.options[:zip].should_not be_nil
    @generator.options[:zip].should == zip_file
    @generator.should_receive(:empty_directory).with(@app_tmp_path).and_return(true)
    # @generator.stub!(:empty_directory).with(@app_tmp_path).and_return(true)
    File.should_receive(:exists?).with(zip_file).and_return(true)
    @generator.should_not_receive(:get)
    @generator.should_receive(:run).with("unzip #{zip_file} -d .", :verbose => false).and_return(true)
    @generator.invoke :fetch_colorbox_files
  end

  it "copy javascript files" do
    glob_string = "#{@unzip_path}/colorbox/jquery.*-min.js"
    source_files = ["#{@unzip_path}/colorbox/jquery.colorbox-min.js"]
    target_files = ['public/javascripts/jquery.colorbox.js']
    Dir.should_receive(:glob).with(glob_string).and_return(source_files)
    @generator.should_receive(:expand_app_path).with(source_files[0]).and_return(source_files[0])
    @generator.should_receive(:copy_file).with(source_files[0], target_files[0]).and_return(true)
    @generator.copy_javascript_files
  end

  it "delete tmp files without zip file" do
    @generator.options[:clean].should be_nil
    @generator.should_receive(:run).with("rm -rf #{@unzip_path}", :verbose => false)
    @generator.delete_tmp_files
  end

  it "delete tmp files with zip file" do
    @generator = Jquery::Generators::ColorboxGenerator.new(
      [], {:clean => true}, {:destination_root => @destination}
    )
    @generator.options[:clean].should_not be_nil
    @generator.options[:clean].should be_true
    @generator.should_receive(:run).with("rm -rf #{@app_tmp_path}", :verbose => false)
    @generator.delete_tmp_files
  end

  it "should go through all tasks" do
    @generator.should_receive(:fetch_colorbox_files).and_return(true)
    @generator.should_receive(:copy_javascript_files).and_return(true)
    @generator.should_receive(:delete_tmp_files).and_return(true)
    @generator.invoke
  end

  it "do real work" do
    # Jquery::Generators::ColorboxGenerator.start('', :destination_root => @destination)
    # File.directory?(File.join(@app_tmp_path)).should be_true
    # File.exist?(File.join(@app_tmp_path, 'colorbox.zip')).should be_true
  end
end
