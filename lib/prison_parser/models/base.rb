module PrisonParser
  module Models
    class Base < Node
      def initialize
        class_name = self.class.name
        label = class_name[(class_name.rindex("::") + 2)..-1]
        super(label)
      end
    end
  end
end