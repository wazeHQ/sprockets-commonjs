require 'sprockets'
require 'tilt'

module Sprockets
  class CommonJS < Tilt::Template

    WRAPPER = '%s.define({"%s":' +
                     "function(exports, require, module){" +
                     '%s' +
                     ";}});\n"

    class << self
      attr_accessor :default_namespace
      attr_accessor :module_paths
      attr_accessor :ignore_paths
    end

    self.default_mime_type = 'application/javascript'
    self.default_namespace = 'this.require'
    self.module_paths = []
    self.ignore_paths = []

    protected

    def prepare
      @namespace = self.class.default_namespace
    end

    def evaluate(scope, locals, &block)
      if commonjs_module?(scope)
        WRAPPER % [ namespace, module_name(scope), data ]
      else
        data
      end
    end

    private

    attr_reader :namespace

    def commonjs_module?(scope)
      in_path?(scope) && !ignored_path?(scope) &&
        (exports_module? || has_dependencies?)
    end

    def in_path?(scope)
      self.class.module_paths.any? do |path|
        scope.pathname.to_s.start_with? path
      end
    end

    def ignored_path?(scope)
      self.class.ignore_paths.any? do |path|
        scope.pathname.to_s.start_with? path
      end
    end

    def exports_module?
      data.include?('module.exports')
    end

    def dependencies
      @dependencies ||= data.scan(/require\(['"](.*)['"]\)/).map(&:last)
    end

    def has_dependencies?
      dependencies.length > 0
    end

    def module_name(scope)
      path = scope.logical_path.gsub(/^\.?\//, '') # Remove relative paths
      basename = File.basename(path)
      dirname = File.dirname(path)

      basename = basename[1..-1] if basename.start_with? '_'

      if basename == 'index'
        dirname
      elsif dirname != '.'
        File.join(dirname, basename)
      else
        basename
      end
    end

  end

  register_postprocessor 'application/javascript', CommonJS
  append_path File.expand_path('../../../assets', __FILE__)
end
