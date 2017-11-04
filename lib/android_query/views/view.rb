module AndroidQuery
  
  LAYOUT_SIZE_OPTIONS = {
    mp: Android::View::ViewGroup::LayoutParams::MATCH_PARENT,
    wc: Android::View::ViewGroup::LayoutParams::WRAP_CONTENT,
  }
  
  ORIENTATION_OPTIONS = {
    vertical: Android::Widget::LinearLayout::VERTICAL,
    horizontal: Android::Widget::LinearLayout::HORIZONTAL,
  }
  
  
  class View
    attr_accessor :original_view, :options, :activity, :stylesheet
    
    def initialize(view, options = {}, activity, stylesheet)
      puts "Inside View initialize()"
      self.activity = activity
      self.original_view = view
      self.options = options
      self.stylesheet = stylesheet
      parse_options(options)
      self
    end
    
    def apply_style(style_method)
      
    end
    
    def parse_options(options)
      puts "Inside View parse_options()"
      self.options = {
        w: :mp,
        h: :mp,
        o: :horizontal,
        weight: 0,
        weight_sum: 0,
        parent: nil,
        click: nil,
        id: nil,
      }.merge(options)
      puts "merged all options..."
      puts LAYOUT_SIZE_OPTIONS
      puts LAYOUT_SIZE_OPTIONS.has_key?(options[:w])
      self.options[:width] = LAYOUT_SIZE_OPTIONS.has_key?(self.options[:w]) ? LAYOUT_SIZE_OPTIONS[self.options[:w]] : self.options[:w]
      puts self.options[:width]
      puts "set :width"
      self.options[:height] = LAYOUT_SIZE_OPTIONS.has_key?(self.options[:h]) ? LAYOUT_SIZE_OPTIONS[self.options[:h]] : self.options[:h]
      puts "set :height"
      self.options[:orientation] = ORIENTATION_OPTIONS[self.options[:o]]
      puts "set :orientation"
    end
    
    def get
      self.original_view
    end
    
    def left
      self.get.getLeft
    end
    
    def top
      self.get.getTop
    end
    
    def width
      self.get.getWidth
    end
    
    def height
      self.get.getHeight
    end
    
    def linear_layout(style_method, options = {}, &block)
      l = AndroidQuery::LinearLayout.new(options, self.activity)
      self.view.get.addView(l)
      block.call(l) if block_given?
      l
    end
    
    def add(view, style_method, options, &block)
      new_view = AndroidQuery::View.new(view, options, self.activity, self.stylesheet)
      new_view.apply_style(style_method)
      self.view.get.addView(new_view.get)
      block.call(new_view) if block_given?
      new_view
    end
    
    def text_view(style_method, options = {})
      v = Android::Widget::TextView.new(self.activity)
      add(v, style_method, options)
    end
    
    def edit_text(style_method, options = {})
      v = Android::Widget::EditText.new(self.activity)
      add(v, style_method, options)
    end
    
    def button(style_method, options = {})
      v = Android::Widget::Button.new(self.activity)
      add(v, style_method, options)
    end
  end
  
  class Layout
    attr_accessor :view, :layout_params, :param_class
    
    def create_android_query_view(view, options, context, style)
      puts "Inside create_android_query_view()"
      self.view = AndroidQuery::View.new(view, options, context, style)
    end
  end
  
  class LinearLayout < Layout
    def initialize(style_method, options, context, style)
      puts "Inside LinearLayout initialize()"
      view = Android::Widget::LinearLayout.new(context)
      create_android_query_view(view, options, context, style)
      self.view.apply_style(style_method)
      puts self.view.options
      self.set_layout_params(self.view.options)
      self.view
    end
    
    def set_layout_params(options)
      puts "Inside set_layout_params()"
      self.param_class = Android::Widget::LinearLayout::LayoutParams
      puts "This line should appear fine..."
      self.layout_params = self.param_class.new(options[:width], options[:height])
      puts "Initiated the layout params..."
      self.layout_params.weight = options[:weight]
      puts "We are 3 lines in set_layout_params()..."
      puts "Weight Sum: #{options[:weight_sum]}"
      self.setWeightSum(options[:weight_sum].to_f)
      self.view.get.setLayoutParams(self.layout_params)
      puts "Inside end of set_layout_params()"
      self.view
    end
  end
  
  class RelativeLayout < Layout
    def initialize(options, context)
      view = AndroidQuery::RelativeLayout.new(context)
      create_android_query_view(view, options, context)
      self.set_layout_params(self.view.options)
      self.view
    end
    
    def set_layout_params(options)
      self.param_class = Android::Widget::RelativeLayout::LayoutParams
      self.layout_params = self.param_class.new(options[:width], options[:height])
      self.view.get.setLayoutParams(self.layout_params)
    end
  end
  
  class FrameLayout < Layout
    def initialize(options, context)
      view =  AndroidQuery::FrameLayout.new(context)
      create_android_query_view(view, options, context)
      self.set_layout_params(self.view.options)
      self.view
    end
    
    def set_layout_params(options)
      self.param_class = Android::Widget::RelativeLayout::LayoutParams
      self.layout_params = self.param_class.new(options[:width], options[:height])
      self.view.getsetLayoutParams(self.layout_params)
      self.view
    end
  end
  
  class TextView < View
  end

  class EditText < View
  end

  class Button < View
  end  
end

class AndroidQuery
  attr_accessor :activity, :stylesheet
  def initialize(activity, stylesheet)
    self.activity = activity
    self.stylesheet = stylesheet.new
  end
  
  def linear_layout(style_method, options = {}, &block)
    layout = AndroidQuery::LinearLayout.new(style_method, options, self.activity, self.stylesheet)
    block.call(layout) if block_given?
    layout
  end
  
  def relative_layout(options = {}, &block)
    layout = AndroidQuery::RelativeLayout.new(options, self.activity, self.stylesheet)
    block.call(layout) if block_given?
    layout
  end
end
