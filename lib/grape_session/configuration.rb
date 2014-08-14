module GrapeSession
  module Configuration
    extend ActiveSupport::Concern

    class SettingsContainer
      def initialize
        @settings = {}
      end

      def to_hash
        @settings.to_hash
      end
    end

    def self.config_class(*args)
      new_config_class = Class.new(SettingsContainer)

      args.each do |setting_name|
        str = if setting_name.respond_to? :values
                nested_settings_methods(setting_name)
              else
                simple_settings_methods(setting_name)
              end

        new_config_class.class_eval str
      end

      new_config_class
    end

    def self.simple_settings_methods(setting_name)
      <<-EVAL
                   def #{setting_name}(new_value)
                     @settings[:#{setting_name}] = new_value
                   end
      EVAL
    end

    def self.nested_settings_methods(setting_name)
      StringIO.new.tap do |new_str|

        setting_name.each_with_object(new_str) do |(key, value), str|
          str.puts <<-EVAL
                    def #{key}_context
                      @#{key}_context ||= GrapeSession::Configuration.config_class(*#{value.inspect}).new
                    end

                    def #{key}(&block)
                      #{key}_context.instance_exec(&block)
                    end
          EVAL
        end

        new_str.puts <<-EVAL
                  def to_hash
                    @settings.to_hash.merge(
                      #{setting_name.keys.map { |key| "#{key}: #{key}_context.to_hash" }.join(",\n")}
                    )
                  end
        EVAL

      end.string
    end

    def self.module(*args)
      new_module = Module.new do
        extend ActiveSupport::Concern
        include GrapeSession::DSL::Configuration
      end

      new_module.tap do |mod|

        class_mod = create_class_mod(args)

        mod.const_set(:ClassMethods, class_mod)

      end
    end

    def self.create_class_mod(args)
      new_module = Module.new do
        def config_context
          @config_context ||= config_class.new
        end
      end

      new_module.tap do |class_mod|
        new_config_class = config_class(*args)

        class_mod.send(:define_method, :config_class) do
          @config_context ||= new_config_class
        end
      end
    end
  end
end
