module AndroidQuery
  class View
    attr_accessor :original_view, :options, :activity, :stylesheet, :layout_params
    
    def initialize(view, activity, stylesheet)
      puts "Inside View initialize()"
      self.activity = activity
      self.original_view = view
      self.stylesheet = stylesheet
      self
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
    
    def text
      self.get.text
    end
    
    def linear_layout(style_method, &block)
      l = AndroidQuery::LinearLayout.new(style_method, self.activity, self.stylesheet)
      self.view.get.addView(l)
      block.call(l) if block_given?
      l
    end
    
    def add(view, style_method, &block)
      new_view = AndroidQuery::View.new(view, self.activity, self.stylesheet)
      new_view.apply_style(style_method)
      self.view.get.addView(new_view.get)
      block.call(new_view) if block_given?
      new_view
    end
    
    def text_view(style_method)
      v = Android::Widget::TextView.new(self.activity)
      add(v, style_method)
    end
    
    def edit_text(style_method)
      v = Android::Widget::EditText.new(self.activity)
      add(v, style_method)
    end
    
    def button(style_method)
      v = Android::Widget::Button.new(self.activity)
      add(v, style_method)
    end
  end
  
  class Layout
    attr_accessor :view, :layout_params, :param_class
    
    def create_android_query_view(view, context, style)
      puts "Inside create_android_query_view()"
      self.view = AndroidQuery::View.new(view, context, style)
    end
  end
  
  class LinearLayout < Layout
    def initialize(style_method, context, style)
      puts "Inside LinearLayout initialize()"
      puts "Style method: #{style_method}"
      view = Android::Widget::LinearLayout.new(context)
      create_android_query_view(view, context, style)
      puts "Created AQV object - LinearLayout.new"
      puts self.view.get
      self.view
    end
  end
  
  class RelativeLayout < Layout
    def initialize(options, context)
      view = AndroidQuery::RelativeLayout.new(context)
      create_android_query_view(view, options, context)
      self.view
    end    
  end
  
  class FrameLayout < Layout
    def initialize(options, context)
      view =  AndroidQuery::FrameLayout.new(context)
      create_android_query_view(view, options, context)
      self.view
    end    
  end
  
  class Stylesheet
    def apply_style_for(aqv, method_name)
      element = StylesheetElement.new(aqv)
      self.send(method_name.to_s, element)
      element.view.get.setLayoutParams(element.params)
      aqv
    end
  end
  
  class StylesheetElement
    attr_accessor :view, :params
    
    LAYOUT_SIZE_OPTIONS = {
      mp: Android::View::ViewGroup::LayoutParams::MATCH_PARENT,
      wc: Android::View::ViewGroup::LayoutParams::WRAP_CONTENT,
    }
  
    ORIENTATION_OPTIONS = {
      vertical: Android::Widget::LinearLayout::VERTICAL,
      horizontal: Android::Widget::LinearLayout::HORIZONTAL,
    }
    
    def initialize(android_query_view)
      self.view = android_query_view
      self.params = Android::View::ViewGroup::LayoutParams.new(LAYOUT_SIZE_OPTIONS[:mp], LAYOUT_SIZE_OPTIONS[:wc])
      self
    end
    
    def text=(t)
      self.view.get.text = t
    end
    
    def width=(w)
      if w == :mp || w == :wc
        self.params.width = LAYOUT_SIZE_OPTIONS[w]
      else
        self.params.width = w
      end
    end
    
    def height=(h)
      if h == :mp || h == :wc
        self.params.height = LAYOUT_SIZE_OPTIONS[h]
      else
        self.params.height = h
      end
    end
    
    def orientation=(o)
      if o == :vertical || o == :horizontal
        self.params.orientation = ORIENTATION_OPTIONS[o]
      end
    end
  end
end






class AndroidQuery
  attr_accessor :activity, :stylesheet
  def initialize(activity, stylesheet)
    self.activity = activity
    self.stylesheet = stylesheet.new
  end
  
  def linear_layout(style_method, &block)
    layout = AndroidQuery::LinearLayout.new(style_method, self.activity, self.stylesheet)
    puts "Created the layout, now passing to the block, if there's any..."
    block.call(layout) if block_given?
    layout
  end
  
  # def relative_layout(options = {}, &block)
  #   layout = AndroidQuery::RelativeLayout.new(options, self.activity, self.stylesheet)
  #   block.call(layout) if block_given?
  #   layout
  # end
end
