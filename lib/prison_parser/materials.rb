require_relative 'materials/base'
# require_relative 'materials/callout'
require_relative 'materials/equipment'
require_relative 'materials/material'
require_relative 'materials/object'
require_relative 'materials/room'

module PrisonParser
  class Materials < Node

    node_class :Equipment, PrisonParser::Materials::Equipment
    node_class :Material,  PrisonParser::Materials::Material
    node_class :Object,    PrisonParser::Materials::Object
    node_class :Room,      PrisonParser::Materials::Room

    def initialize
      @materials = {}
      super("Materials")
    end

    def self.open(filename)
      file = File.open(filename, "r")
      materials = PrisonParser::Utils::Parser.new.load(file, Materials)
      file.close
      return materials
    end

    def get(type, name)
      @materials[type].try(:[], name)
    end

    def create_node(label)
      get_node_class(label).new
    end

    def finished_reading_node(node)
      @materials[node.type] ||= {}
      @materials[node.type][node.name] = node
    end

    private

    def get_node_class(lbl)
      if self.class.node_classes.has_key?(lbl)
        self.class.node_classes[lbl]
      else
        PrisonParser::Materials::Base
      end
    end

  end
end
