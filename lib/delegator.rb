module Shoutcast

  # Delegates methods via Forwardable.
  # See +delegate_all+ for examples.
  module Delegator

    def self.included(base) # :nodoc:
      base.extend ClassMethods
    end

    module ClassMethods
      # Delegates all methods defined +klass+ to +object+.
      #
      # === Usage
      #   class ArrayMimic < SomeInheritance
      #     include Shoutcast::Delegator
      #
      #     delegate_all :@array, Array
      #
      #     def initialize
      #       @array = []
      #     end
      #
      #   end
      #
      #   array = ArrayMimic.new
      #   array.push 1, 2, 3
      #   array.each do |item|
      #     p item
      #   end
      #
      def delegate_all(object, klass)
        class_eval <<-EVAL
          extend Forwardable

          def_delegators :#{object}, *(#{klass}.instance_methods - instance_methods)
        EVAL
      end
    end

  end

end
