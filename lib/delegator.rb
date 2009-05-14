module Shoutcast

  # Delegates methods via Forwardable.
  module Delegator
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      # Delegates all methods defined +klass+ to +object+.
      #
      # === Usage
      #   class ArrayMimic < SomeInheritance
      #
      #     delegate_all :@array, Array
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
