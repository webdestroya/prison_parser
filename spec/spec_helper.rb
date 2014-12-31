require "simplecov"
require "coveralls"
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start do
  add_filter "/spec/"

  add_group "Models", "prison_parser/models"
  add_group "Utils", "prison_parser/utils"
end

require "prison_parser"

RSpec.configure do |config|
  config.order = "random"
end
