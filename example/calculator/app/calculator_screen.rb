class CalculatorScreen < AMQScreen
  def on_create(state)
    @start_new_number = true
    @first_number = 0
    @result = 0
    @operation = nil
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


class CalculatorStyle < AMQStylesheet
  def top_layout(st)
    st.orientation = :vertical
    st.weight_sum = 3
    st.background_color = :black
  end
  
  def result_label(st)
    st.height = 0
    st.text_alignment = :bottom_right
    st.weight = 1
    st.text = '0'
    st.text_color = :white
    st.text_size = 52
  end
  
  def buttons_layout(st)
    st.height = 0
    st.orientation = :vertical
    st.weight_sum = 5
    st.weight = 2
  end
  
  def row_layout(st)
    st.height = 0
    st.weight_sum = 4
    st.weight = 1
  end
  
  def decimal_point(st)
    st.text = '.'
    shared_number_styles(st)
  end
  
  def zero(st)
    st.text = '0'
    shared_number_styles(st)
    st.weight = 2
  end
  
  def one(st)
    st.text = '1'
    shared_number_styles(st)
  end
  
  def two(st)
    st.text = '2'
    shared_number_styles(st)
  end
  
  def three(st)
    st.text = '3'
    shared_number_styles(st)
  end
  
  def four(st)
    st.text = '4'
    shared_number_styles(st)
  end
  
  def five(st)
    st.text = '5'
    shared_number_styles(st)
  end
  
  def six(st)
    st.text = '6'
    shared_number_styles(st)
  end
  
  def seven(st)
    st.text = '7'
    shared_number_styles(st)
  end
  
  def eight(st)
    st.text = '8'
    shared_number_styles(st)
  end
  
  def nine(st)
    st.text = '9'
    shared_number_styles(st)
  end
  
  def ac(st)
    st.text = 'AC'
    shared_other_styles(st)
  end
  
  def plus_minus(st)
    st.text = '+/-'
    shared_other_styles(st)
  end
  
  def percentage(st)
    st.text = '%'
    shared_other_styles(st)
  end
  
  def division(st)
    st.text = '/'
    shared_operation_styles(st)
  end
  
  def multiplication(st)
    st.text = 'X'
    shared_operation_styles(st)
  end
  
  def minus(st)
    st.text = '-'
    shared_operation_styles(st)
  end
  
  def plus(st)
    st.text = '+'
    shared_operation_styles(st)
  end
  
  def equals(st)
    st.text = '='
    shared_operation_styles(st)
  end
  
  def shared_other_styles(st)
    st.background_color = '#999999'
    shared_button_styles(st)
  end
  
  def shared_operation_styles(st)
    st.background_color = '#F49B01'
    shared_button_styles(st)
  end
  
  def shared_number_styles(st)
    st.background_color = '#444444'
    shared_button_styles(st)
  end
  
  def shared_button_styles(st)
    st.width = 0
    st.margin = 5
    st.text_color = :white
    st.weight = 1
  end
end