# Android Query

This gem is in its very early development. Please don't use in production.

Currently, `android_query` only supports the `LinearLayout`, `EditText`, `TextView`, and `Button` views.

The goal of `android_query` is to make android development on RubyMotion fun, easy, and quick.
It's intended for developers who prefer to code their UIs rather than use a GUI editor.

`android_query` was inspired by the wonderful [rmq](http://github.com/infinitered/rmq/) gem.

## Installation


Add this line to your application's Gemfile:

```ruby
  gem 'android_query', '~> 0.0.5'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install android_query

## Usage

The general rule is to create a top-level layout and add views to it.
Each view should be passed a style method.

```ruby
class MainActivity < Android::App::Activity
  attr_accessor :aq, :counter
  
  def onCreate(savedInstanceState)
    super
    self.counter = 0
    self.aq = AndroidQuery.new(self, HomeStyle)
    self.aq.linear_layout(:top_layout) do |top|
      top.text_view(:phone_field)
      top.edit_text(:email_field)
      top.button(:submit_button)
      top.linear_layout(:counter_layout) do |counter_layout|
        counter_layout.button(:increment)
        counter_layout.button(:decrement)
      end
    end
  end
  
  def show_message(view)
    # toast options can be:
    # for gravity: :bottom, :right, :left, :center, :top, and their combinations
    # for length: :short, :long
    self.aq.toast("The counter is set at #{self.counter}", gravity: :bottom_right, length: :short)
  end
  
  def increment_counter(view)
    self.counter += 1
  end
  
  def decrement_counter(view)
    self.counter -= 1
  end
end
```
The previous code produces the following app:
![Sample Screenshot](screenshot.png)


The following is the `HomeStyle` class that styles the screen:
```ruby
class HomeStyle < AndroidMotionQuery::Stylesheet
  def top_layout(v)
    v.width = :mp # <-- :mp, :wc, or a number
    v.height = :mp
    v.orientation = :vertical # <-- or :horizontal
    v.weight_sum = 10
  end
  
  def phone_field(v)
    v.text = 'Hello My Style!'
    v.weight = 4
  end
  
  def email_field(v)
    v.text = 'This is my email'
    v.weight = 1
  end
  
  def submit_button(v)
    v.text = 'Click Me To See'
    v.weight = 5
    v.click = :show_message # <-- this would call the show_message(view) method on the activity
  end
  
  def counter_layout(v)
    v.orientation = :horizontal
    v.width = :mp 
    v.height = :wc
    v.weight_sum = 2
  end
  
  def increment(v)
    v.text = '+ Increment'
    v.click = :increment_counter
    v.weight = 1
  end
  
  def decrement(v)
    v.text = '- Decrement'
    v.click = :decrement_counter
    v.weight = 1
  end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/aesmail/android_query.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
