# Prison Architect Parser

This gem allows you to parse, access, and manipulate a save file from Prison Architect.

## Installation

Add this line to your application's Gemfile:

    gem 'prison_parser'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install prison_parser

## Usage

```ruby
require 'prison_parser'
prison = PrisonParser::Prison.open("myprison.prison")

puts prison.Finance.Balance # 1318560.0

prison.save("newprison.prison")

```

## Roadmap

* Ability to convert a prison to a blank, but planned prison.

## Thanks
Special thanks to: [Matvei Stefarov](https://github.com/fragmer) for his work on [PASaveEditor](https://github.com/fragmer/PASaveEditor), which served as the basis for the parsing implementation. To [Jason Dew](https://github.com/jasondew) for letting me use the name of his original library, [prison_parser](https://github.com/jasondew/prison_parser)

## License
Please see the [LICENSE](https://github.com/webdestroya/prison_parser/LICENSE) for more information.