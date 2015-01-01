module PrisonParser
  module Models
    class Cell < Base

      attr_reader :x, :y

      def initialize(x=0, y=0)
        @x = x
        @y = y
        super("#{x} #{y}")
      end

      def material
        properties['Mat']
      end

      # 0 worst, 100 best
      def condition
        return nil unless properties.has_key?('Con')
        properties['Con'].to_f
      end

      def room_id
        return nil unless properties.has_key?('Room.i')
        properties['Room.i'].to_i
      end

      def room_uid
        return nil unless properties.has_key?('Room.u')
        properties['Room.u'].to_i
      end

      def room
        # TODO: Return the room object?
      end

      def indoors?
        "true" == properties['Ind']
      end
    end
  end
end
