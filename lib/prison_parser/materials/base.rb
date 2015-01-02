module PrisonParser
  class Materials < PrisonParser::Node
    class Base < PrisonParser::Models::Base

      def name
        properties['Name']
      end

      def type
        @type ||= label.downcase.to_sym
      end
    end
  end
end
