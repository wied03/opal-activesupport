# TODO: Segment these out into different requires

require 'active_support/core_ext/module/delegation'

class Module
  def delegate(*methods)
    options = methods.pop
    unless options.is_a?(Hash) && to = options[:to]
      raise ArgumentError, 'Delegation needs a target. Supply an options hash with a :to key as the last argument (e.g. delegate :hello, to: :greeter).'
    end

    prefix, allow_nil = options.values_at(:prefix, :allow_nil)

    if prefix == true && to =~ /^[^a-z_]/
      raise ArgumentError, 'Can only automatically set the delegation prefix when delegating to a method.'
    end

    method_prefix = \
        if prefix
                              "#{prefix == true ? to : prefix}_"
        else
          ''
        end

    # Opal file/line
    #file, line = caller.first.split(':', 2)
    file = 'not_supported_in_opal'
    line = '1'
    line = line.to_i

    to = to.to_s
    to = "self.#{to}" if RUBY_RESERVED_WORDS.include?(to)

    methods.each do |method|
      # Attribute writer methods only accept one argument. Makes sure []=
      # methods still accept two arguments.
      definition = (method =~ /[^\]]=$/) ? 'arg' : '*args, &block'

      # The following generated method calls the target exactly once, storing
      # the returned value in a dummy variable.
      #
      # Reason is twofold: On one hand doing less calls is in general better.
      # On the other hand it could be that the target has side-effects,
      # whereas conceptually, from the user point of view, the delegator should
      # be doing one call.
      if allow_nil
        module_eval do
          define_method "#{method_prefix}#{method}" do |definition|
            _ = to
            if !_.nil? || nil.respond_to?(method)
              _.send(method, definition)
            end
          end
        end
      else
        define_method "#{method_prefix}#{method}" do |definition|
          begin
            _ = to
            _.send(method, definition)
          rescue NoMethodError => e
            if _.nil? && e.name == method
              raise DelegationError, "#{self}##{method_prefix}#{method} delegated to #{to}.#{method}, but #{to} is nil: \#{self.inspect}"
            else
              raise
            end
          end
        end
      end
    end
  end
end

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
          callbacks = self.send "_#{name}_callbacks"
          __run_callbacks__(callbacks, &block)
        end
      end
    end
  end
end

require 'active_support/core_ext/module/attribute_accessors'

class Module
  def mattr_reader(*syms)
    options = syms.extract_options!
    syms.each do |sym|
      raise NameError.new("invalid attribute name: #{sym}") unless sym =~ /^[_A-Za-z]\w*$/
      class_eval do
        class_variable_set("@@#{sym}", nil) unless defined? class_variable_get("@@#{sym}")

        define_singleton_method sym do
          class_variable_get("@@#{sym}")
        end
      end

      unless options[:instance_reader] == false || options[:instance_accessor] == false
        class_eval do
          define_method sym do
            class_variable_get("@@#{sym}")
          end
        end
      end
      class_variable_set("@@#{sym}", yield) if block_given?
    end
  end

  def mattr_writer(*syms)
    options = syms.extract_options!
    syms.each do |sym|
      raise NameError.new("invalid attribute name: #{sym}") unless sym =~ /^[_A-Za-z]\w*$/
      class_eval do
        class_variable_set("@@#{sym}", nil) unless defined? class_variable_get("@@#{sym}")

        define_singleton_method "#{sym}=" do |obj|
          class_variable_set "@@#{sym}", obj
        end
      end

      unless options[:instance_writer] == false || options[:instance_accessor] == false
        class_eval do
          define_method "#{sym}=" do |obj|
            class_variable_set "@@#{sym}", obj
          end
        end
      end
      send("#{sym}=", yield) if block_given?
    end
  end
end

class Logger
  class Formatter

  end

  def info(*args)
    puts "#{args}"
  end
end

require 'active_support/tagged_logging'

# avoid logger check in testing/lagged_logging
module Rails
end

require 'active_support/number_helper/number_converter'
require 'active_support/number_helper/number_to_phone_converter'

class ActiveSupport::NumberHelper::NumberToPhoneConverter
  def convert
    str = country_code(opts[:country_code])
    str += convert_to_phone_number(number.to_s.strip)
    str + phone_ext(opts[:extension])
  end

  def convert_with_area_code(number)
    # string mutate
    #number.gsub!(/(\d{1,3})(\d{3})(\d{4}$)/, "(\\1) \\2#{delimiter}\\3")
    #number
    number.gsub(/(\d{1,3})(\d{3})(\d{4}$)/, "(\\1) \\2#{delimiter}\\3")
  end

  def convert_without_area_code(number)
    # string mutate
    # number.gsub!(/(\d{0,3})(\d{3})(\d{4})$/, "\\1#{delimiter}\\2#{delimiter}\\3")
    # number.slice!(0, 1) if start_with_delimiter?(number)
    # number
    subbed = number.gsub(/(\d{0,3})(\d{3})(\d{4})$/, "\\1#{delimiter}\\2#{delimiter}\\3")
    start_with_delimiter?(number) ? subbed.slice(0, 1) : subbed
  end
end
