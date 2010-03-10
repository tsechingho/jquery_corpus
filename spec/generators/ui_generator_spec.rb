#require File.expand_path('../../spec_helper', __FILE__)
require 'spec_helper'
require 'generators/jquery/ui/ui_generator'

describe Jquery::Generators::UiGenerator do
  before do
    @destination = File.join('tmp', 'test_app')
    @source = Jquery::Generators::UiGenerator.source_root
    @generator = Jquery::Generators::UiGenerator.new(
      ["1.8rc3"], {}, {:destination_root => @destination}
    )
    @app_tmp_path = "tmp/jquery"
    @unzip_folder = "ui"
    @unzip_path = "#{@app_tmp_path}/#{@unzip_folder}"
  end

  after do
    FileUtils.rm_rf(@destination)
  end

  it "fetch jquery-ui files from remote" do
    @generator.version.should == '1.8rc3'
    @generator.options[:zip].should be_nil
    zip_file = "jquery-ui-#{@generator.version}.custom.zip"
    download_path = "http://jqueryui.com/download"
    @generator.should_receive(:empty_directory).with(@app_tmp_path).and_return(true)
    File.should_receive(:exists?).with(zip_file).and_return(false)
    @generator.should_receive(:get).with("#{download_path}/#{zip_file}", zip_file).and_return(true)
    @generator.should_receive(:run).with("unzip #{zip_file} -d #{@unzip_folder}", :verbose => false).and_return(true)
    @generator.fetch_jquery_ui_files
  end

  it "fetch jquery-ui files from local" do
    zip_file = 'my_jquery_ui.zip'
    @generator = Jquery::Generators::UiGenerator.new(
      ["1.8rc3"], {:zip => zip_file}, {:destination_root => @destination}
    )
    @generator.version.should == '1.8rc3'
    @generator.options[:zip].should_not be_nil
    @generator.options[:zip].should == zip_file
    @generator.should_receive(:empty_directory).with(@app_tmp_path).and_return(true)
    File.should_receive(:exists?).with(zip_file).and_return(true)
    @generator.should_not_receive(:get)
    @generator.should_receive(:run).with("unzip #{zip_file} -d #{@unzip_folder}", :verbose => false).and_return(true)
    @generator.invoke :fetch_jquery_ui_files
  end

  it "fetch rails jquery-ujs file" do
    url = 'http://github.com/rails/jquery-ujs/raw/master/src/rails.js'
    @generator.should_receive(:get).with(url, 'public/javascripts/rails.js').and_return(true)
    @generator.fetch_rails_jquery_ujs_file
  end

  it "copy javascript files" do
    @generator.version.should == '1.8rc3'
    glob_string = "#{@unzip_path}/js/jquery-*.min.js"
    source_files = [
      "#{@unzip_path}/js/jquery-ui-#{@generator.version}.custom.js",
      "#{@unzip_path}/js/jquery-#{@generator.version}.js"
    ]
    target_files = [
      'public/javascripts/jquery-ui.js',
      'public/javascripts/jquery.js'
    ]
    Dir.should_receive(:glob).with(glob_string).and_return(source_files)
    @generator.should_receive(:expand_app_path).with(source_files[0]).and_return(source_files[0])
    @generator.should_receive(:copy_file).with(source_files[0], target_files[0]).and_return(true)
    @generator.should_receive(:expand_app_path).with(source_files[1]).and_return(source_files[1])
    @generator.should_receive(:copy_file).with(source_files[1], target_files[1]).and_return(true)
    @generator.copy_javascript_files
  end

  it "copy stylesheet files" do
    @generator.version.should == '1.8rc3'
    glob_string = "#{@unzip_path}/css/**/*"
    source_files = [
      "#{@unzip_path}/css/smoothness",
      "#{@unzip_path}/css/smoothness/images",
      "#{@unzip_path}/css/smoothness/jquery-ui-#{@generator.version}.custom.css",
      "#{@unzip_path}/css/smoothness/images/ui-bg.png",
      "#{@unzip_path}/css/smoothness/images/ui-icons.png"
    ]
    target_files = [
      "public/stylesheets/smoothness",
      "public/stylesheets/smoothness/images",
      "public/stylesheets/smoothness/jquery-ui.css",
      "public/stylesheets/smoothness/images/ui-bg.png",
      "public/stylesheets/smoothness/images/ui-icons.png"
    ]
    Dir.should_receive(:glob).with(glob_string).and_return(source_files)
    @generator.should_receive(:expand_app_path).with(source_files[0]).and_return(source_files[0])
    File.should_receive(:directory?).with(source_files[0]).and_return(true)
    @generator.should_receive(:empty_directory).with(target_files[0]).and_return(true)
    @generator.should_receive(:expand_app_path).with(source_files[1]).and_return(source_files[1])
    File.should_receive(:directory?).with(source_files[1]).and_return(true)
    @generator.should_receive(:empty_directory).with(target_files[1]).and_return(true)
    @generator.should_receive(:expand_app_path).with(source_files[2]).and_return(source_files[2])
    File.should_receive(:directory?).with(source_files[2]).and_return(false)
    @generator.should_receive(:copy_file).with(source_files[2], target_files[2]).and_return(true)
    @generator.should_receive(:expand_app_path).with(source_files[3]).and_return(source_files[3])
    File.should_receive(:directory?).with(source_files[3]).and_return(false)
    @generator.should_receive(:copy_file).with(source_files[3], target_files[3]).and_return(true)
    @generator.should_receive(:expand_app_path).with(source_files[4]).and_return(source_files[4])
    File.should_receive(:directory?).with(source_files[4]).and_return(false)
    @generator.should_receive(:copy_file).with(source_files[4], target_files[4]).and_return(true)
    @generator.copy_stylesheet_files
  end

  it "create initializer file" do
    @generator.should_receive(:copy_file).with('jquery.rb', 'config/initializers/jquery.rb').and_return(true)
    @generator.create_initializer_file
  end

  it "create application layout file" do
    @generator.should_receive(:copy_file).with('application.html.erb', 'app/views/layouts/application.html.erb').and_return(true)
    @generator.create_application_layout_file
  end

  it "delete tmp files without zip file" do
    @generator.options[:clean].should be_nil
    @generator.should_receive(:run).with("rm -rf #{@unzip_path}", :verbose => false)
    @generator.delete_tmp_files
  end

  it "delete tmp files with zip file" do
    @generator = Jquery::Generators::UiGenerator.new(
      ["1.8rc3"], {:clean => true}, {:destination_root => @destination}
    )
    @generator.options[:clean].should_not be_nil
    @generator.options[:clean].should be_true
    @generator.should_receive(:run).with("rm -rf #{@app_tmp_path}", :verbose => false)
    @generator.delete_tmp_files
  end

  it "show_readme" do
    @generator.should_receive(:readme).with('README')
    @generator.show_readme
  end

  it "should go through all tasks" do
    @generator.should_receive(:fetch_jquery_ui_files).and_return(true)
    @generator.should_receive(:fetch_rails_jquery_ujs_file).and_return(true)
    @generator.should_receive(:copy_javascript_files).and_return(true)
    @generator.should_receive(:copy_stylesheet_files).and_return(true)
    @generator.should_receive(:create_initializer_file).and_return(true)
    @generator.should_receive(:create_application_layout_file).and_return(true)
    @generator.should_receive(:delete_tmp_files).and_return(true)
    @generator.should_receive(:show_readme).and_return(true)
    @generator.invoke
  end
end
