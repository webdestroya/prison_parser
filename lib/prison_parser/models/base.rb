module PrisonParser
  module Models
    class Base < Node
      def initialize(label=nil)
        label ||= self.class.name[(self.class.name.rindex("::") + 2)..-1]
        super(label)
      end
    end
  end
end
