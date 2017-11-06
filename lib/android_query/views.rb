module AndroidMotionQuery
  class View
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
    def get; self.view end
    def left; get.getLeft end
    def right; get.getRight end
    def bottom; get.getBottom end
    def top; get.getTop end
    def width; get.getWidth end
    def height; get.getHeight end
    def text; get.text end
    def text=(t); get.text = t end

    def create_android_query_view(view, style_method, layout_params, options = {}, &block)
      aqv = View.new(view, self.activity, self.stylesheet, style_method, layout_params, options)
      self.stylesheet.apply_style_for(aqv, style_method, layout_params)
      puts "Adding #{aqv.get} to #{self.get}"
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
    
    def image_view(style_method, &block)
      view = Android::Widget::ImageView.new(self.activity)
      create_android_query_view(view, style_method, self.layout_params, {}, &block)
    end
    
    def image_button(style_method, &block)
      view = Android::Widget::ImageButton.new(self.activity)
      create_android_query_view(view, style_method, self.layout_params, {}, &block)
    end
    
    def new_view(view, style_method, &block)
      create_android_query_view(view, style_method, self.layout_params, {}, &block)
    end
  end

  class Stylesheet
    def apply_style_for(view, style_name, layout_params)
      style_view = StylesheetElement.new(view, layout_params)
      self.send(style_name.to_s, style_view)
      view.get.setLayoutParams(style_view.params)
      view.get.tag = view
      view
    end
  end

  class StylesheetElement
    attr_accessor :view, :params, :radius

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
    
    def id=(number)
      
      self.view.get.id = number
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
    
    def padding_left=(number)
      left, top, right, bottom = get_padding
      self.padding = [number, top, right, bottom]
    end
    
    def padding_right=(number)
      left, top, right, bottom = get_padding
      self.padding = [left, top, number, bottom]
    end
    
    def padding_top=(number)
      left, top, right, bottom = get_padding
      self.padding = [left, number, right, bottom]
    end
    
    def padding_bottom=(number)
      left, top, right, bottom = get_padding
      self.padding = [left, top, right, number]
    end
    
    def padding=(number)
      if number.class == Array && number.count == 4
        left, top, right, bottom = number
        self.view.get.setPadding(left, top, right, bottom)
      elsif number.class == Fixnum
        self.view.get.setPadding(number, number, number, number)
      else
        raise "Invalid value (#{number}) set as padding for #{self.view.get}"
      end
    end
    
    def get_padding
      v = self.view.get
      [v.getPaddingLeft, v.getPaddingTop, v.getPaddingRight, v.getPaddingBottom]
    end
    
    def margin_left=(number)
      left, top, right, bottom = get_margins
      self.margin = [number, top, right, bottom]
    end
    
    def margin_right=(number)
      left, top, right, bottom = get_margins
      self.margin = [left, top, number, bottom]
    end
    
    def margin_top=(number)
      left, top, right, bottom = get_margins
      self.margin = [left, number, right, bottom]
    end
    
    def margin_bottom=(number)
      left, top, right, bottom = get_margins
      self.margin = [left, top, right, number]
    end
    
    def get_margins
      lp = self.params
      [lp.leftMargin, lp.topMargin, lp.rightMargin, lp.bottomMargin]
    end
    
    def margin=(number)
      if number.class == Array && number.count == 4
        left, top, right, bottom = number
        self.params.setMargins(left, top, right, bottom)
      elsif number.class == Fixnum
        self.params.setMargins(number, number, number, number)
      else
        raise "Invalid value (#{number}) set as margin for #{self.view.get}"
      end
    end
    
    def extra=(something)
      self.view.extra = something
    end
    
    def click=(method_name)
      self.view.get.onClickListener = AQClickListener.new(self.view.activity, method_name)
    end
    
    # TODO find a solution for rounded corners (with or without images)
    # def corner_radius=(radius)
    #   self.radius ||= radius
    #   drawable = self.view.get.getDrawable
    #   if drawable
    #     self.draw_image_with_radius(drawable, self.radius)
    #   else
    #     shape = Android::Graphics::GradientDrawable.new
    #     shape.cornerRadius = self.radius
    #     self.view.get.background = shape
    #   end
    # end
    # TODO find a solution for rounded corners (with or without images)
    # def draw_image_with_radius(image, radius)
    #   self.radius ||= radius
    #   width = image.getWidth
    #   height = image.getHeight
    #   result = Android::Graphics::Bitmap.createBitmap(width, height, Android::Graphics::Bitmap::Config::ARGB_8888)
    #   canvas = Android::Graphics::Canvas.new(result)
    #   canvas.drawARGB(0, 0, 0, 0)
    #   paint = Android::Graphics::Paint.new
    #   paint.antiAlias = true
    #   paint.color = AQColor.parse_color('#000000')
    #   rect = Android::Graphics::Rect.new(0, 0, width, height)
    #   rect_f = Android::Graphics::RectF.new(rect)
    #   canvas.drawRoundRect(rect_f, self.radius, self.radius, paint)
    #   paint.xfermode = Android::Graphics::PorterDuffXfermode.new(Android::Graphics::PorterDuff::Mode::SRC_IN)
    #   canvas.drawBitmap(raw, rect, rect, paint)
    #   result
    # end
    
    def background_color=(color)
      self.view.get.backgroundColor = AQColor.parse_color(color.to_s)
    end
    
    def background_image=(image_name)
      context = self.view.get.getContext
      resource_id = context.getResources.getIdentifier(image_name, "drawable", context.getPackageName)
      self.view.get.setImageResource(resource_id)
    end
    
    def scale_type=(option)
      scale_types = {
        center: Android::Widget::ImageView::ScaleType::CENTER,
        center_crop: Android::Widget::ImageView::ScaleType::CENTER_CROP,
        center_inside: Android::Widget::ImageView::ScaleType::CENTER_INSIDE,
        fit_center: Android::Widget::ImageView::ScaleType::FIT_CENTER,
        fit_end: Android::Widget::ImageView::ScaleType::FIT_END,
        fit_start: Android::Widget::ImageView::ScaleType::FIT_START,
        fit_xy: Android::Widget::ImageView::ScaleType::FIT_XY,
        matrix: Android::Widget::ImageView::ScaleType::MATRIX,
      }
      self.view.get.scaleType = scale_types[option]
    end
    
    def text_alignment=(alignment)
      self.gravity = alignment
    end
    
    def text_color=(color)
      self.view.get.textColor = AQColor.parse_color(color.to_s)
    end
    
    def gravity=(alignment)
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
      self.view.get.gravity = gravity_options[alignment]
    end
  end
  
  class AQColor
    def self.parse_color(hex); Android::Graphics::Color.parseColor(hex) end
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
  attr_accessor :activity, :stylesheet, :root, :view_ids
  
  def initialize(activity, stylesheet)
    self.activity = activity
    self.stylesheet = stylesheet.new
    self
  end
  
  def create_android_query_view(view, style_method, layout_params, options = {}, &block)
    self.root = AndroidMotionQuery::View.new(view, self.activity, self.stylesheet, style_method, layout_params, options)
    self.stylesheet.apply_style_for(self.root, style_method, layout_params)
    block.call(self.root) if block_given?
    self.activity.setContentView(self.root.get)
  end
  
  def find(id)
    self.root.get.findViewById(id).tag
  end
  
  def linear_layout(style_method, &block)
    view = Android::Widget::LinearLayout.new(self.activity)
    layout_params = Android::Widget::LinearLayout::LayoutParams
    create_android_query_view(view, style_method, layout_params, {}, &block)
  end
  
  def relative_layout(style_method, &block)
    view = Android::Widget::RelativeLayout.new(self.activity)
    layout_params = Android::Widget::RelativeLayout::Params
    create_android_query_view(view, style_method, layout_params, {}, &block)
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
