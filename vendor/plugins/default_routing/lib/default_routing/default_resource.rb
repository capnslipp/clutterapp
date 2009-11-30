# DefaultRouting
module DefaultRouting

  module DefaultResource

    def self.included(base)
      return if base.included_modules.include?(InstanceMethods)
      base.send(:include, InstanceMethods)
      base.alias_method_chain :initialize, :default_routing
      base.alias_method_chain :path, :default_routing
      base.alias_method_chain :member_path, :default_routing
      base.alias_method_chain :nesting_path_prefix, :default_routing
    end

    module InstanceMethods

      def initialize_with_default_routing(entities, options)
        default = options.delete(:default)
        initialize_without_default_routing(entities, options)
        @path_segment = nil if default.to_s == entities.to_s || default == true
      end

      def path_with_default_routing
        @path ||= "#{path_prefix}#{'/' if @path_segment}#{@path_segment}"      
      end

      def member_path_with_default_routing
        @member_path ||= "#{shallow_path_prefix}#{'/' if path_segment}#{path_segment}/:id"
      end

      def nesting_path_prefix_with_default_routing
        @nesting_path_prefix ||= "#{shallow_path_prefix}#{'/' if path_segment}#{path_segment}/:#{singular}_id"
      end

    end
  end
end