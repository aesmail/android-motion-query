# Android Motion Query

`android_motion_query` was created to make android development on RubyMotion as enjoyable and productive as possible.
It also tries to make an android app look just like a ruby app, without losing any native functionality.

If you don't like dealing with XML layouts and long method names, `android_motion_query` might be for you.

`android_motion_query` was inspired by the wonderful [rmq](http://github.com/infinitered/rmq/) gem for iOS.

## Installation


Add this line to your application's Gemfile:

```ruby
  gem 'android_motion_query', '~> 0.2.0'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install android_motion_query

## Usage

The general rule is to create a top-level layout and add views to it.
Each view accepts a style name as an argument.

#### Tiny Example:

To create a LinearLayout and add a TextView widget to it:

```ruby
amq.add(:linear_layout, :layout_style) do |my_layout|
  my_layout.add(:text_view, :some_information)
end
```

The style for the LinearLayout is `:layout_style` and the TextView has a `:some_information` style.

How do you define styles?

Styles are defined in a separate class that inherits from `AMQStylesheet`.

Each style is passed a wrapper of the android view:

```ruby
def layout_style(st)
  st.width = :mp # or :wc for MATCH_PARENT and WRAP_CONTENT respectively
  st.height = :mp # could also provide an integer to be set directly
  st.background_color = '#CF7D33' # or you can do :white, :black, :green, etc
  st.orientation = :vertical # or :horizontal
end

def some_information(st)
  st.width = :mp
  st.height = :wc
  st.text = 'Hello Android Motion Query'
  st.text_color = :blue
  st.text_alignment = :center # or :bottom, :top, :center_right, etc
  st.margin_top = 10
end
```


#### Complete Example:

This code creates the following simple calculator app:

![Sample Screenshot](screenshot.png)

```ruby
class CalculatorScreen < AMQScreen
  def on_create(state)
    setup_calculator_variables
    amq.stylesheet = CalculatorStyle
    amq.add(:linear_layout, :top_layout) do |top|
      @result_label = top.add(:text_view, :result_label)
      top.add(:linear_layout, :buttons_layout) do |bottom|
        bottom.add(:linear_layout, :row_layout) do |row|
          row.add(:button, :ac).tap { reset_calculator }
          row.add(:button, :plus_minus).tap { amq.toast('This is not supported yet') }
          row.add(:button, :percentage).tap { amq.toast('This is not supported yet') }
          row.add(:button, :division).tap { save_result_with_operation(:div) }
        end
        
        bottom.add(:linear_layout, :row_layout) do |row|
          row.add(:button, :seven).tap { add_digit('7') }
          row.add(:button, :eight).tap { add_digit('8') }
          row.add(:button, :nine).tap { add_digit('9') }
          row.add(:button, :multiplication).tap { save_result_with_operation(:mul) }
        end
        
        bottom.add(:linear_layout, :row_layout) do |row|
          row.add(:button, :four).tap { add_digit('4') }
          row.add(:button, :five).tap { add_digit('5') }
          row.add(:button, :six).tap { add_digit('6') }
          row.add(:button, :minus).tap { save_result_with_operation(:min) }
        end
        
        bottom.add(:linear_layout, :row_layout) do |row|
          row.add(:button, :one).tap { add_digit('1') }
          row.add(:button, :two).tap { add_digit('2') }
          row.add(:button, :three).tap { add_digit('3') }
          row.add(:button, :plus).tap { save_result_with_operation(:add) }
        end
        
        bottom.add(:linear_layout, :row_layout) do |row|
          row.add(:button, :zero).tap { add_digit('0') }
          row.add(:button, :decimal_point).tap { add_decimal }
          row.add(:button, :equals).tap { calculate_result }
        end
      end
    end
  end
  
  def setup_calculator_variables
    @start_new_number = true
    @first_number = 0
    @result = 0
    @operation = nil
  end
  
  def add_digit(digit)
    @result_label.text = '' if @start_new_number
    display = @result_label.text + digit
    if display['.']
      display = display.to_f unless digit == '0'
    else
      display = display.to_i
    end
    @result_label.text = display.to_s
    @start_new_number = false
  end
  
  def add_decimal
    display = @result_label.text
    @result_label.text = display + '.'
  end
  
  def reset_calculator
    @result_label.text = '0'
    @result = 0
    @first_number = 0
    @start_new_number = true
    @operation = nil
  end
  
  def save_result_with_operation(op)
    display = @result_label.text
    @first_number = display.to_f
    @operation = op
    @start_new_number = true
  end
  
  def calculate_result
    display = @result_label.text.to_f
    case @operation
    when :add
      @result = @first_number + display
    when :min
      @result = @first_number - display
    when :mul
      @result = @first_number * display
    when :div
      @result = @first_number / display
    end
    @result_label.text = @result.to_s
  end
end
```


The following is the `HomeStyle` class that styles the screen:
```ruby
class HomeStyle < AMQStylesheet
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
- [ ] Refactor - create more "single responsibility" classes and have smaller functions (this will never be "done", it's just here as a constant reminder)
- [ ] Set automatic IDs for views
- [ ] Add wrappers for all built-in android widgets (currently android_query supports 5 widgets)
- [x] Add support for LinearLayouts
- [ ] Add support for RelativeLayouts
- [ ] Add support for FrameLayouts
- [ ] Add support for AbsoluteLayouts (worth it? AbsoluteLayout is deprecated a long time ago)
- [x] Add support for working with custom widgets/views (throught `aqv.new_view()`)
- [ ] Add support for `view.click { block of code }`
- [ ] Add support for @string values (strings.xml)
- [x] Add support for @drawable values (images in the resources/drawable directory)
- [ ] Add support for easy and quick animations
- [ ] Add support for rounded corners (first attempt failed, this is harder than I thought)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/aesmail/android_query.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
