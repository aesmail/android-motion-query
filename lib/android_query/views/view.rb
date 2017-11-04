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
    attr_accessor :original_view, :options, :activity
    
    def initialize(view, options = {}, activity)
      puts "Inside View initialize()"
      self.activity = activity
      self.original_view = view
      self.options = options
      parse_options(options)
      self
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
      # TODO debug this issue, apparently the "options[:w].is_a? Symbol" line is making troubel
      self.options[:width] = options[:w] == :mp ? Android::View::ViewGroup::LayoutParams::MATCH_PARENT : options[:w]
      puts "set :width"
      self.options[:height] = options[:h].is_a? Symbol ? LAYOUT_SIZE_OPTIONS[options[:h]] : options[:h]
      puts "set :height"
      self.options[:orientation] = ORIENTATION_OPTIONS[optinos[:o]]
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
    
    def layout(type, options = {}, &block)
      l = AndroidQuery::AQLayout.new(type, options, self.activity)
      self.view.get.addView(l)
      block.call(l) if block_given?
      l
    end
    
    def add(view, options, &block)
      new_view = AndroidQuery::View.new(view, options, self.activity)
      self.view.get.addView(new_view.get)
      block.call(new_view) if block_given?
      new_view
    end
    
    def text_view(options = {})
      v = AndroidQuery::TextView.new(self.activity)
      add(v, options)
    end
    
    def edit_text(options = {})
      v = AndroidQuery::EditText.new(self.activity)
      add(v, options)
    end
    
    def button(options = {})
      v = AndroidQuery::Button.new(self.activity)
      add(v, options)
    end
  end
  
  class Layout
    attr_accessor :view, :layout_params, :param_class
    
    def create_android_query_view(view, options, context)
      puts "Inside create_android_query_view()"
      self.view = AndroidQuery::View.new(view, options, context)
    end
  end
  
  class LinearLayout < Layout
    def initialize(options, context)
      puts "Inside LinearLayout initialize()"
      view = Android::Widget::LinearLayout.new(context)
      create_android_query_view(view, options, context)
      self.set_layout_params(self.view.options)
      self.view
    end
    
    def set_layout_params(options)
      puts "Inside set_layout_params()"
      self.param_class = Android::Widget::LinearLayout::LayoutParams
      self.layout_params = self.param_class.new(options[:width], options[:height])
      self.layout_params.weight = options[:weight]
      self.setWeightSum(options[:weight_sum])
      self.view.get.setLayoutParams(self.layout_params)
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
  attr_accessor :activity
  def initialize(activity)
    self.activity = activity
  end
  
  def layout(type, options = {}, &block)
    l = case type
        when :linear
          AndroidQuery::LinearLayout.new(options, self.activity)
        when :relative
          AndroidQuery::RelativeLayout.new(options, self.activity)
        when :frame
          AndroidQuery::FrameLayout.new(options, self.activity)
        end
    block.call(l) if block_given?
    l
  end
end
