module ActiveSupport
  module Autoload
    def eager_autoload
    end
  end

  # No autoloading in Opal, so replicating this here

  @@test_order = nil

  def self.test_order=(new_order) # :nodoc:
    @@test_order = new_order
  end

  def self.test_order # :nodoc:
    @@test_order
  end
end

# this is in stdlib, but we can't get around it, seems to be mimic'ing a hash, so do this for now
class ThreadSafe
  class Cache < Hash
  end
end

require 'active_support/callbacks'

module ActiveSupport::Callbacks::ClassMethods
  def define_callbacks(*names)
    options = names.extract_options!

    names.each do |name|
      class_attribute "_#{name}_callbacks"
      set_callbacks name, CallbackChain.new(name, options)

      module_eval do
        define_method "_run_#{name}_callbacks" do |&block|
          __run_callbacks__("_#{name}_callbacks", &block)
        end
      end
    end
  end
end
