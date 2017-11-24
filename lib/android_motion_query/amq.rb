class AndroidMotionQuery
  attr_accessor :activity, :root, :view_ids
  attr_reader :stylesheet
  
  def initialize(activity)
    self.activity = activity
    self
  end
  
  def stylesheet=(style)
    @stylesheet = style.new
  end
    
  def create_android_query_view(view, style_method, layout_params, options = {}, &block)
    self.root ||= AMQView.new(view, self.activity, self.stylesheet, style_method, layout_params, options)
    self.stylesheet.apply_style_for(self.root, style_method, layout_params)
    block.call(self.root) if block_given?
    self.activity.setContentView(self.root.get)
    self
  end
  
  def create_standalone_amq_view(view, style_method, layout_params, options = {}, &block)
    amq_view = AMQView.new(view, self.activity, self.stylesheet, style_method, layout_params, options)
    self.stylesheet.apply_style_for(amq_view, style_method, layout_params)
    block.call(amq_view) if block_given?
    amq_view
  end
  
  def find(id)
    self.root.get.findViewById(id).tag
  end
  
  def add(view_sym, style_method, &block)
    view, layout_params = self.send(view_sym, &block)
    create_android_query_view(view, style_method, layout_params, {}, &block)
  end
  
  def add_alone(view_sym, style_method, &block)
    view, layout_params = self.send(view_sym, &block)
    create_standalone_amq_view(view, style_method, layout_params, {}, &block)
  end
  
  def linear_layout(&block)
    view = Android::Widget::LinearLayout.new(self.activity)
    layout_params = Android::Widget::LinearLayout::LayoutParams
    [view, layout_params]
  end
  
  def relative_layout(&block)
    view = Android::Widget::RelativeLayout.new(self.activity)
    layout_params = Android::Widget::RelativeLayout::LayoutParams
    [view, layout_params]
  end
  
  def frame_layout(&block)
    view = Android::Widget::FrameLayout.new(self.activity)
    layout_params = Android::Widget::FrameLayout::LayoutParams
    [view, layout_params]
  end
  
  def text_view(&block)
    view = Android::Widget::TextView.new(self.activity)
    layout_params = Android::Widget::LinearLayout::LayoutParams
    [view, layout_params]
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
      bottom_right: Android::View::Gravity::BOTTOM | Android::View::Gravity::RIGHT,
      bottom_left: Android::View::Gravity::BOTTOM | Android::View::Gravity::LEFT,
      center_right: Android::View::Gravity::CENTER | Android::View::Gravity::RIGHT,
      center_left: Android::View::Gravity::CENTER | Android::View::Gravity::LEFT,
      top_right: Android::View::Gravity::TOP | Android::View::Gravity::RIGHT,
      top_left: Android::View::Gravity::TOP | Android::View::Gravity::LEFT,
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
