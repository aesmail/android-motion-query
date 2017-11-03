# Android Query

This gem is in its very early development. Please don't use in production.

Currently, `android_query` only supports the `LinearLayout`, `EditText`, `TextView`, and `Button` views.

The goal of `android_query` is to make android development on RubyMotion fun, easy, and quick.
It's intended for developers who prefer to code their UIs rather than use a GUI editor.

`android_query` was inspired by the wonderful [rmq](http://github.com/infinitered/rmq/) gem.

## Installation


Add this line to your application's Gemfile:

```ruby
  gem 'android_query', '~> 0.0.1'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install android_query

## Usage

```ruby
def onCreate(savedInstanceState)
  super
  @counter = 0
  self.aq = AndroidQuery.new(self)
  aq.layout(:linear, weight_sum: 10, w: :mp, h: :mp) do |linear|
    aq.edit_text(linear, id: 10, w: :mp, h: :wc)
    aq.text_view(linear, id: 11, text: "Hello Android Query!", w: :mp, h: :wc, weight: 8)
    aq.layout(:linear, parent: linear, weight_sum: 2, weight: 1, orientation: :h) do |buttons_layout|
      aq.button(buttons_layout, text: "+ (plus)", w: :wc, h: :mp, weight: 1, click: :increase_counter)
      aq.button(buttons_layout, text: "- (minus)", w: :wc, h: :mp, weight: 1, click: :decrease_counter)
    end
    aq.layout(:linear, parent: linear, weight_sum: 2, weight: 1) do |sweet|
      aq.button(sweet, id: 12, text: "This is SO SWEET!", w: :mp, h: :mp, click: :toast_me, weight: 1)
      aq.button(sweet, id: 13, text: "Change Label", w: :mp, h: :mp, click: :show_message, weight: 1)
    end
  end
end

def toast_me(view)
  aq.toast("You've been toasted #{@counter} times!", gravity: :center)
end

def increase_counter(view)
  @counter += 1
end

def decrease_counter(view)
  @counter -= 1
end

def show_message(view)
  my_text = aq.find(10)
  my_label = aq.find(11)
  my_label.text = my_text.text
  my_text.text = ""
end
```

![Sample Screenshot](screenshot.png)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/aesmail/android_query.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
