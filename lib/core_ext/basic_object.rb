# taken from Sequel gem, BasicObject implementation for ruby 1.8
if RUBY_VERSION < '1.9.0'
  # If on Ruby 1.8, create a <tt>Sequel::BasicObject</tt> class that is similar to the
  # the Ruby 1.9 +BasicObject+ class. This is used in a few places where proxy
  # objects are needed that respond to any method call.
  class BasicObject
    # The instance methods to not remove from the class when removing
    # other methods.
    KEEP_METHODS = %w"__id__ __send__ __metaclass__ instance_eval == equal? initialize method_missing"

    # Remove all but the most basic instance methods from the class. A separate
    # method so that it can be called again if necessary if you load libraries
    # after Sequel that add instance methods to +Object+.
    def self.remove_methods!
      ((private_instance_methods + instance_methods) - KEEP_METHODS).each{|m| undef_method(m)}
    end
    remove_methods!
  end
end
