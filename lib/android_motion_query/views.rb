class AMQView
  attr_accessor :view, :activity, :stylesheet, :style_name, :layout_params, :options, :extra

  def initialize(view, activity, stylesheet, style_name, layout_params, options = {})
    self.view = view
    self.activity = activity
    self.stylesheet = stylesheet
    self.style_name = style_name
    self.layout_params = layout_params
    self.options = {
      parent: nil,
    }.merge(options)
  end
  
  # convenience methods
  def id; get.id end
  def id=(vid); get.id = vid; self end
  def get; self.view end
  def left; get.getLeft end
  def right; get.getRight end
  def bottom; get.getBottom end
  def top; get.getTop end
  def width; get.getWidth end
  def height; get.getHeight end
  def text; get.text end
  def text=(t); get.text = t end
  def data(t); get.text = t; self end
  def tap(&block)
    AMQTapListener.new(self.activity, self, &block)
    self
  end
  
  def create_android_query_view(view, style_method, layout_params, options = {}, &block)
    aqv = AMQView.new(view, self.activity, self.stylesheet, style_method, layout_params, options)
    self.stylesheet.apply_style_for(aqv, style_method, layout_params)
    self.get.addView(aqv.get)
    block.call(aqv) if block_given?
    aqv
  end
  
  def linear_layout(style_method, &block)
    view = Android::Widget::LinearLayout.new(self.activity)
    lp = Android::Widget::LinearLayout::LayoutParams
    create_android_query_view(view, style_method, lp, {}, &block)
  end

  def text_view(style_method, &block)
    view = Android::Widget::TextView.new(self.activity)
    new_view(view, style_method, &block)
  end
  
  def edit_text(style_method, &block)
    view = Android::Widget::EditText.new(self.activity)
    new_view(view, style_method, &block)
  end
  
  def button(style_method, &block)
    view = Android::Widget::Button.new(self.activity)
    new_view(view, style_method, &block)
  end
  
  def image_view(style_method, &block)
    view = Android::Widget::ImageView.new(self.activity)
    new_view(view, style_method, &block)
  end
  
  def image_button(style_method, &block)
    view = Android::Widget::ImageButton.new(self.activity)
    new_view(view, style_method, &block)
  end
  
  def grid_view(style_method, &block)
    view = Android::Widget::GridView.new(self.activity)
    new_view(view, style_method, &block)
  end
  
  def adapter(list, &block)
    # this method has to be called from a grid_view or similar views (which accept adapters)
    self.get.adapter = AMQAdapter.new(self.activity, list, &block)
    self
  end
  
  def new_view(view, style_method, &block)
    create_android_query_view(view, style_method, self.layout_params, {}, &block)
  end
end
