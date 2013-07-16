# EventAttribute

EventAttribute allows you to turn your date/datetime columns in to boolean attributes.
Idea for this was taken from http://jamis.jamisbuck.org/articles/2005/12/14/two-tips-for-working-with-databases-in-rails

## Installation

Add this line to your application's Gemfile:

    gem 'event_attribute'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install event_attribute

## Usage

```ruby
    class Referral < ActiveRecord::Base
      event_attribute :applied_at, :attribute => 'pending', :nil_equals => true
      event_attribute :subscribed_on
    end

    referral = Referral.create(:applied_at => Time.now)
    referral.pending?           # => false
    referral.subscribed?        # => false
    
    referral.pending = true
    referral.applied_at         # => nil
    referral.pending?           # => true
    
    referral.subscribed = true
    referral.subscribed_on      # => Time.now
    referral.subscribed?        # => true
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

### License

    Copyright (c) 2007 Jonathan Younger, released under the MIT license
    Copyright (c) 2013 Andrew Kuklewicz, Chris Rhoden

    Permission is hereby granted, free of charge, to any person obtaining
    a copy of this software and associated documentation files (the
    "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:

    The above copyright notice and this permission notice shall be
    included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
    NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
    LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
    OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
    WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

