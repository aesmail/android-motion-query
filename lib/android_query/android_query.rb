class AndroidQuery
  attr_accessor :activity
  
  def initialize(source)
    self.activity = source
  end
  
  def layout(layout_sym, options = {}, &block)
    layout_info = get_layout(layout_sym, options)
    my_layout = create_layout_with_params(layout_info, options)
    block_layout = {
      layout: my_layout,
      layout_class: layout_info[:layout_class],
      params_class: layout_info[:params_class],
      layout_sym: layout_sym,
      parent: layout_info[:parent],
    }
    block.call(block_layout)
    block_layout[:parent][:layout].addView(my_layout) if block_layout[:parent]
    set_content(block_layout) if block_layout[:parent].nil?
    block_layout
  end
  
  def text_view(layout, options = {})
    tv = Android::Widget::TextView.new(self.activity)
    create_view_layout_params(tv, layout, options)
  end
  
  def edit_text(layout, options = {})
    et = Android::Widget::EditText.new(self.activity) 
    create_view_layout_params(et, layout, options)
  end
  
  def button(layout, options = {})
    btn = Android::Widget::Button.new(self.activity)
    create_view_layout_params(btn, layout, options)
  end
  
  def set_content(layout, params = {})
    self.activity.setContentView(layout[:layout])
  end
  
  def get_layout(layout, options)
    options = merge_options(options)
    layout_and_params = case layout
                        when :linear
                          [Android::Widget::LinearLayout, Android::Widget::LinearLayout::LayoutParams]
                        when :relative
                          [Android::Widget::RelativeLayout, Android::Widget::RelativeLayout::LayoutParams]
                        when :absolute
                          [Android::Widget::AbsoluteLayout, Android::Widget::AbsoluteLayout::LayoutParams]
                        else
                          layout
                        end
    {
      layout: nil,
      layout_class: layout_and_params[0],
      params_class: layout_and_params[1],
      layout_sym: layout,
      parent: options[:parent],
    }
  end
  
  def merge_options(options)
    {
      w: :mp,
      h: :wc,
      orientation: :vertical,
      weight: 0,
      weight_sum: 0,
      parent: nil,
      click: nil,
      id: nil,
    }.merge(options)
  end
  
  def get_width(options, layout)
    case options[:w]
    when :mp, :match_parent
      layout[:params_class]::MATCH_PARENT
    when :wc, :wrap_content
      layout[:params_class]::WRAP_CONTENT
    else
      options[:w]
    end
  end
  
  def get_height(options, layout)
    case options[:h]
    when :mp, :match_parent
      layout[:params_class]::MATCH_PARENT
    when :wc, :wrap_content
      layout[:params_class]::WRAP_CONTENT
    else
      options[:h]
    end
  end
  
  def get_orientation(options, layout)
    case options[:orientation]
    when :vertical, :v
      layout[:layout_class]::VERTICAL
    when :horizontal, :h
      layout[:layout_class]::HORIZONTAL
    else
      raise 'Please set either :horizontal or :vertical for the orientation'
    end
  end
  
  def create_layout_with_params(layout, options)
    options = merge_options(options)
    width = get_width(options, layout)
    height = get_height(options, layout)
    orientation = get_orientation(options, layout)
    my_layout = layout[:layout_class].new(self.activity)
    layout_params = layout[:params_class].new(width, height)
    layout_params.weight = options[:weight] if layout[:layout_sym] == :linear
    my_layout.setLayoutParams(layout_params)
    my_layout.setOrientation(orientation) if layout[:layout_sym] == :linear
    my_layout.setWeightSum(options[:weight_sum]) if layout[:layout_sym] == :linear
    my_layout
  end
  
  def create_view_layout_params(view, layout, options)
    options = merge_options(options)
    width = get_width(options, layout)
    height = get_height(options, layout)
    layout_params = layout[:params_class].new(width, height)
    layout_params.weight = options[:weight]
    view.setText(options[:text]) unless options[:text].nil?
    view.setLayoutParams(layout_params)
    view.onClickListener = AQClickListener.new(self.activity, options) if options[:click]
    view.setId(options[:id]) if options[:id]
    layout[:layout].addView(view)
    view
  end
  
  def find(view_id)
    self.activity.findViewById(view_id)
  end
  
  def toast(text, options = {})
    options = {
      gravity: :bottom,
      length: :short
    }.merge(options)
    
    gravity_options = {
      top: Android::View::Gravity::TOP,
      left: Android::View::Gravity::LEFT,
      right: Android::View::Gravity::RIGHT,
      bottom: Android::View::Gravity::BOTTOM,
      center: Android::View::Gravity::CENTER,
    }
    
    length_options = {
      short: Android::Widget::Toast::LENGTH_SHORT,
      long: Android::Widget::Toast::LENGTH_LONG,
    }
    
    the_toast = Android::Widget::Toast.makeText(self.activity, text, length_options[options[:length]])
    the_toast.setGravity(gravity_options[options[:gravity]], 0, 0)
    the_toast.show
  end
end

class AQClickListener
  attr_accessor :activity, :options
  
  def initialize(activity, options)
    self.activity = activity
    self.options = options
  end
  
  def onClick(view)
    self.activity.send(self.options[:click], view)
  end
end
