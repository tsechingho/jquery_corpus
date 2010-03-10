require 'generators/jquery'

module Jquery
  module Generators
    class ColorboxGenerator < Base
      class_option :zip, :desc => 'The absolute path of zip file'
      class_option :clean, :default => false, :desc => "Clean up tmp directory"

      def fetch_colorbox_files
        empty_directory app_tmp_path
        inside(app_tmp_path) do
          get "#{download_path}/#{zip_file}", zip_file unless File.exists? zip_file
          run "unzip #{zip_file} -d .", :verbose => false
        end
      end

      def copy_javascript_files
        Dir.glob("#{unzip_path}/colorbox/jquery.*-min.js").each do |js_file|
          source_file = expand_app_path(js_file) # jquery.colorbox-min.js
          copy_file source_file, 'public/javascripts/jquery.colorbox.js'
        end
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

      protected

      def download_path
        "http://colorpowered.com/colorbox"
      end

      def zip_file
        options[:zip] || "colorbox.zip"
      end

      def unzip_path
        "#{app_tmp_path}/colorbox"
      end
    end
  end
end
