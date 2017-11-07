# Android Query

This gem is in its very early development. Please don't use in production.

Currently, `android_query` only supports the `LinearLayout`, `EditText`, `TextView`, and `Button` views.

The goal of `android_query` is to make android development on RubyMotion fun, easy, and quick.
It's intended for developers who prefer to code their UIs rather than use a GUI editor.

`android_query` was inspired by the wonderful [rmq](http://github.com/infinitered/rmq/) gem.

## Installation


Add this line to your application's Gemfile:

```ruby
  gem 'android_query', '~> 0.0.6'
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
  attr_accessor :aq
  
  def onCreate(savedInstanceState)
    super
    self.aq = AndroidQuery.new(self, HomeStyle)
    aq.linear_layout(:top_layout) do |top|
      top.image_button(:bench_button)
      top.image_button(:flower_button)
      top.linear_layout(:directions) do |direction_layout|
        direction_layout.text_view(:left_text)
        direction_layout.button(:right_button)
      end
    end
  end
  
  def coffee_message(view)
    aq.toast('This is a message for COFFEE LOVERS :)', gravity: :center)
  end
  
  def random_thing(view)
    puts "This should be printed when I click the button"
  end
  
  def another_toast(view)
    aq.toast("This is a purple", gravity: :top_right, length: :long)
  end
end
```

The previous code produces the following app:

![Sample Screenshot](screenshot.png)


The following is the `HomeStyle` class that styles the screen:
```ruby
class HomeStyle < AndroidMotionQuery::Stylesheet
  def top_layout(st)
    st.width = :mp
    st.height = 0
    st.weight_sum = 4
    st.orientation = :vertical
    st.background_color = '#A87E54'
  end
  
  def bench_button(st)
    st.width = :mp
    st.margin_top = 10
    st.margin_bottom = 10
    st.background_image = 'bench' # <-- image is resources/drawable/bench.png
    st.click = :coffee_message
    shared_button_styles(st)
  end
  
  def flower_button(st)
    st.width = :mp
    st.background_image = 'flower'
    st.click = :random_thing
    shared_button_styles(st)
  end
  
  def shared_button_styles(st)
    st.height = 0
    st.padding = 0
    st.margin_left = 10
    st.margin_right = 10
    st.scale_type = :fit_xy
    st.weight = 1.5
  end
  
  def directions(st)
    st.orientation = :horizontal
    st.weight = 1
    st.weight_sum = 2
    st.width = :mp
    st.height = 0
    st.margin_top = 10
  end
  
  def left_text(st)
    st.weight = 1
    st.text = 'android_query is AWESOME!'
    st.text_alignment = :center
  end
  
  def right_button(st)
    st.weight = 1
    st.text = 'Click Me'
    st.click = :another_toast
    st.background_color = '#927FD5'
    st.text_color = :white
  end
end
```

## Todo List
- [ ] Set automatic IDs for views
- [ ] Support all built-in android widgets (currently android_query supports 4 widgets)
- [ ] Support @string
- [x] Support @drawable
- [ ] Support easy animations

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/aesmail/android_query.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
