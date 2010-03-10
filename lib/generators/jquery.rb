require 'rails/generators/named_base'

module Jquery
  module Generators
    class Base < Rails::Generators::Base
      def self.source_root
        @_jquery_source_root ||= begin
          if base_name && generator_name
            File.expand_path(File.join(base_name, generator_name, 'templates'), File.dirname(__FILE__))
          end
        end
      end

      protected

      def self.banner
        "rails generate #{namespace} #{self.arguments.map{ |a| a.usage }.join(' ')} [options]"
      end

      def readme(file_name)
        file_path = File.expand_path(file_name, self.class.source_root)
        say File.exist?(file_path) ? File.read(file_path) : nil
      end

      # always relative to current path (Rails.root)
      def app_tmp_path
        'tmp/jquery'
      end

      def app_root_path
        defined?(Rails) && Rails.respond_to?(:root) ? Rails.root : Dir.pwd
      end

      def expand_app_path(file)
        File.expand_path(file, app_root_path)
      end
    end
  end
end
