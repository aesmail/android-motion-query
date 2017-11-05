module AndroidMotionQuery
  class View
    attr_accessor :view, :activity, :stylesheet, :style_name, :layout_params, :options

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

    def get
      self.view
    end

    def create_android_query_view(view, style_method, layout_params, options = {}, &block)
      aqv = View.new(view, self.activity, self.stylesheet, style_method, layout_params, options)
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
      create_android_query_view(view, style_method, self.layout_params, {}, &block)
    end
    
    def edit_text(style_method, &block)
      view = Android::Widget::EditText.new(self.activity)
      create_android_query_view(view, style_method, self.layout_params, {}, &block)
    end
    
    def button(style_method, &block)
      view = Android::Widget::Button.new(self.activity)
      create_android_query_view(view, style_method, self.layout_params, {}, &block)
    end
  end

  class Stylesheet
    def apply_style_for(view, style_name, layout_params)
      style_view = StylesheetElement.new(view, layout_params)
      self.send(style_name.to_s, style_view)
      view.get.setLayoutParams(style_view.params)
      view
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

    def initialize(view, layout_params)
      self.view = view
      self.params = layout_params.new(LAYOUT_SIZE_OPTIONS[:mp], LAYOUT_SIZE_OPTIONS[:wc])
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
        self.view.get.orientation = ORIENTATION_OPTIONS[o]
      end
    end
    
    def weight_sum=(number)
      self.view.get.weightSum = number
    end
    
    def weight=(number)
      self.params.weight = number
    end
    
    def click=(method_name)
      self.view.get.onClickListener = AQClickListener.new(self.view.activity, method_name)
    end
  end
  
  class AQClickListener
    attr_accessor :activity, :method_name
    def initialize(activity, method_name)
      self.activity = activity
      self.method_name = method_name
    end
    
    def onClick(view)
      self.activity.send(self.method_name.to_s, view)
    end
  end
end


class AndroidQuery
  attr_accessor :activity, :stylesheet
  
  def initialize(activity, stylesheet)
    self.activity = activity
    self.stylesheet = stylesheet.new
    self
  end
  
  def create_android_query_view(view, style_method, layout_params, options = {})
    AndroidMotionQuery::View.new(view, self.activity, self.stylesheet, style_method, layout_params, options)
  end
  
  def linear_layout(style_method, &block)
    view = Android::Widget::LinearLayout.new(self.activity)
    layout_params = Android::Widget::LinearLayout::LayoutParams
    aqv = create_android_query_view(view, style_method, layout_params, {})
    self.stylesheet.apply_style_for(aqv, style_method, layout_params)
    block.call(aqv) if block_given?
    self.activity.setContentView(aqv.get)
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
