INPUT_TYPE = Android::Text::InputType

class AMQStylesheet
  def apply_style_for(view, style_name, layout_params)
    style_view = AMQStylesheetElement.new(view, layout_params)
    self.send(style_name.to_s, style_view)
    view.get.setLayoutParams(style_view.params)
    view.get.tag = view
    view
  end
end



class AMQStylesheetElement
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
    self.view.get.onClickListener = AMQClickListener.new(self.view.activity, method_name)
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
    self.view.get.backgroundColor = AMQColor.parse_color(color.to_s)
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
    self.view.get.textColor = AMQColor.parse_color(color.to_s)
  end
  
  def hint=(t)
    self.view.get.hint = t
  end
  
  INPUT_TYPES = {
    normal: INPUT_TYPE::TYPE_CLASS_TEXT,
    password: INPUT_TYPE::TYPE_CLASS_TEXT | INPUT_TYPE::TYPE_TEXT_VARIATION_PASSWORD,
    visible_password: INPUT_TYPE::TYPE_CLASS_TEXT | INPUT_TYPE::TYPE_TEXT_VARIATION_VISIBLE_PASSWORD,
    number: INPUT_TYPE::TYPE_CLASS_NUMBER,
    email: INPUT_TYPE::TYPE_CLASS_TEXT | INPUT_TYPE::TYPE_TEXT_VARIATION_EMAIL_ADDRESS,
    phone: INPUT_TYPE::TYPE_CLASS_PHONE,
    date: INPUT_TYPE::TYPE_CLASS_DATETIME | INPUT_TYPE::TYPE_DATETIME_VARIATION_DATE,
    time: INPUT_TYPE::TYPE_CLASS_DATETIME | INPUT_TYPE::TYPE_DATETIME_VARIATION_TIME,
    datetime: INPUT_TYPE::TYPE_CLASS_DATETIME,
  }
  
  def input_type=(text_type)
    if INPUT_TYPES.keys.include? text_type
      self.view.get.inputType = INPUT_TYPES[text_type]
    else
      puts "The value #{text_type} is not a supported input_type value. Defaulting to normal text."
      self.input_type = :normal
    end
  end
  
  GRAVITY = Android::View::Gravity
  GRAVITY_OPTIONS = {
    top: GRAVITY::TOP,
    left: GRAVITY::LEFT,
    right: GRAVITY::RIGHT,
    bottom: GRAVITY::BOTTOM,
    center: GRAVITY::CENTER,
    bottom_right: GRAVITY::BOTTOM | GRAVITY::RIGHT,
    bottom_left: GRAVITY::BOTTOM | GRAVITY::LEFT,
    center_right: GRAVITY::CENTER | GRAVITY::RIGHT,
    center_left: GRAVITY::CENTER | GRAVITY::LEFT,
    top_right: GRAVITY::TOP | GRAVITY::RIGHT,
    top_left: GRAVITY::TOP | GRAVITY::LEFT,
  }
  
  def gravity=(alignment)
    if GRAVITY_OPTIONS.keys.include? alignment
      self.view.get.gravity = GRAVITY_OPTIONS[alignment]
    else
      puts "The value #{alignment} is not a supported gravity value. Defaulting to center."
      self.gravity = :center
    end
  end
end
