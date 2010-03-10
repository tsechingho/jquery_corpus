require 'generators/jquery'

module Jquery
  module Generators
    class UiGenerator < Base
      argument :version, :type => :string
      class_option :zip, :desc => 'The absolute path of zip file'
      class_option :clean, :default => false, :desc => "Clean up tmp directory"

      def fetch_jquery_ui_files
        empty_directory app_tmp_path
        inside(app_tmp_path) do
          get "#{download_path}/#{zip_file}", zip_file unless File.exists? zip_file
          run "unzip #{zip_file} -d #{unzip_folder}", :verbose => false
        end
      end

      def fetch_rails_jquery_ujs_file
        get 'http://github.com/rails/jquery-ujs/raw/master/src/rails.js', 'public/javascripts/rails.js'
      end

      # http://code.google.com/apis/ajaxlibs/documentation/
      def copy_javascript_files
        Dir.glob("#{unzip_path}/js/jquery-*.min.js").each do |js_file|
          source_file = expand_app_path(js_file)
          if js_file =~ /-ui-.+\.custom/ # jquery-ui-VERSION.custom.js
            copy_file source_file, 'public/javascripts/jquery-ui.js'
          else # jquery-VERSION.js
            copy_file source_file, 'public/javascripts/jquery.js'
          end
        end
      end

      def copy_stylesheet_files
        Dir.glob("#{unzip_path}/css/**/*").each do |css_file|
          source_file = expand_app_path(css_file)
          target_file = css_file.sub("#{unzip_path}/css", 'public/stylesheets')
          if File.directory? source_file
            empty_directory target_file
          elsif source_file =~ /\.png$/ # images/*.png
            copy_file source_file, target_file
          elsif source_file =~ /\.css$/ # jquery-ui-VERSION.custom.css
            copy_file source_file, target_file.sub(/-ui-.+\.css$/, '-ui.css')
          end
        end
      end

      def create_initializer_file
        copy_file 'jquery.rb', 'config/initializers/jquery.rb'
      end

      def create_application_layout_file
        copy_file 'application.html.erb', 'app/views/layouts/application.html.erb'
      end

      def delete_tmp_files
        in_root do
          if options[:clean]
            run "rm -rf #{app_tmp_path}", :verbose => false
          else
            run "rm -rf #{unzip_path}", :verbose => false
          end
        end
      end

      def show_readme
        readme 'README'
      end

      protected

      def download_path
        "http://jqueryui.com/download"
      end

      def zip_file
        options[:zip] || "jquery-ui-#{version}.custom.zip"
      end

      def unzip_folder
        "ui"
      end

      def unzip_path
        "#{app_tmp_path}/#{unzip_folder}"
      end
    end
  end
end
