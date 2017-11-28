# TYPE_FACE = Android::Graphics::TypeFace
# TYPE_FACE_OPTIONS = {
#   normal:           TYPE_FACE::Create("sans-serif",            TYPE_FACE::NORMAL),
#   normal_bold:      TYPE_FACE::Create("sans-serif",            TYPE_FACE::BOLD),
#   light:            TYPE_FACE::Create("sans-serif-light",      TYPE_FACE::NORMAL),
#   light_bold:       TYPE_FACE::Create("sans-serif-light",      TYPE_FACE::BOLD),
#   condensed:        TYPE_FACE::Create("sans-serif-condensed",  TYPE_FACE::NORMAL),
#   condensed_bold:   TYPE_FACE::Create("sans-serif-condensed",  TYPE_FACE::BOLD),
# }

VIEW_GROUP_PARAMS = Android::View::ViewGroup::LayoutParams
LAYOUT_SIZE_OPTIONS = {
  mp: VIEW_GROUP_PARAMS::MATCH_PARENT,
  wc: VIEW_GROUP_PARAMS::WRAP_CONTENT,
}

LINEAR_LAYOUT = Android::Widget::LinearLayout
ORIENTATION_OPTIONS = {
  vertical:   LINEAR_LAYOUT::VERTICAL,
  horizontal: LINEAR_LAYOUT::HORIZONTAL,
}

SCALE_TYPE = Android::Widget::ImageView::ScaleType
SCALE_TYPES = {
  center:         SCALE_TYPE::CENTER,
  center_crop:    SCALE_TYPE::CENTER_CROP,
  center_inside:  SCALE_TYPE::CENTER_INSIDE,
  fit_center:     SCALE_TYPE::FIT_CENTER,
  fit_end:        SCALE_TYPE::FIT_END,
  fit_start:      SCALE_TYPE::FIT_START,
  fit_xy:         SCALE_TYPE::FIT_XY,
  matrix:         SCALE_TYPE::MATRIX,
}

INPUT_TYPE = Android::Text::InputType
INPUT_TYPES = {
  normal:             INPUT_TYPE::TYPE_CLASS_TEXT,
  password:           INPUT_TYPE::TYPE_CLASS_TEXT | INPUT_TYPE::TYPE_TEXT_VARIATION_PASSWORD,
  visible_password:   INPUT_TYPE::TYPE_CLASS_TEXT | INPUT_TYPE::TYPE_TEXT_VARIATION_VISIBLE_PASSWORD,
  number:             INPUT_TYPE::TYPE_CLASS_NUMBER,
  email:              INPUT_TYPE::TYPE_CLASS_TEXT | INPUT_TYPE::TYPE_TEXT_VARIATION_EMAIL_ADDRESS,
  phone:              INPUT_TYPE::TYPE_CLASS_PHONE,
  date:               INPUT_TYPE::TYPE_CLASS_DATETIME | INPUT_TYPE::TYPE_DATETIME_VARIATION_DATE,
  time:               INPUT_TYPE::TYPE_CLASS_DATETIME | INPUT_TYPE::TYPE_DATETIME_VARIATION_TIME,
  datetime:           INPUT_TYPE::TYPE_CLASS_DATETIME,
}

GRAVITY = Android::View::Gravity
GRAVITY_OPTIONS = {
  top:                GRAVITY::TOP,
  left:               GRAVITY::LEFT,
  right:              GRAVITY::RIGHT,
  bottom:             GRAVITY::BOTTOM,
  center:             GRAVITY::CENTER,
  center_horizontal:  GRAVITY::CENTER_HORIZONTAL,
  center_vertical:    GRAVITY::CENTER_VERTICAL,
  bottom_right:       GRAVITY::BOTTOM | GRAVITY::RIGHT,
  bottom_left:        GRAVITY::BOTTOM | GRAVITY::LEFT,
  center_right:       GRAVITY::CENTER | GRAVITY::RIGHT,
  center_left:        GRAVITY::CENTER | GRAVITY::LEFT,
  top_right:          GRAVITY::TOP | GRAVITY::RIGHT,
  top_left:           GRAVITY::TOP | GRAVITY::LEFT,
}


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
  
  def initialize(view, layout_params)
    self.view = view
    self.params = layout_params.new(LAYOUT_SIZE_OPTIONS[:mp], LAYOUT_SIZE_OPTIONS[:mp])
    self
  end
  
  def id=(number)
    
    self.view.get.id = number
  end
  
  def text=(t)
    self.view.get.text = t
    self
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
  
  def border_color=(color)
    shape = Android::Graphics::Drawable::ShapeDrawable.new
    shape.shape = Android::Graphics::Drawable::Shapes::RectShape.new
    shape.paint.color = AMQColor.parse_color(color.to_s)
    shape.paint.strokeWidth = 1
    shape.paint.style = Android::Graphics::Paint::Style::STROKE
    self.view.get.background = shape
  end
  
  def background_color=(color)
    self.view.get.backgroundColor = AMQColor.parse_color(color.to_s)
  end
  
  def background_image=(image_name)
    context = self.view.get.getContext
    resource_id = context.getResources.getIdentifier(image_name, "drawable", context.getPackageName)
    self.view.get.backgroundResource = resource_id
  end
  
  def image=(image_name)
    context = self.view.get.getContext
    resource_id = context.getResources.getIdentifier(image_name, "drawable", context.getPackageName)
    self.view.get.setImageResource(resource_id)
  end
  
  def scale_type=(option)
    self.view.get.scaleType = SCALE_TYPES[option]
  end
  
  def text_alignment=(alignment)
    self.gravity = alignment
  end
  
  def text_color=(color)
    self.view.get.textColor = AMQColor.parse_color(color.to_s)
  end
  
  def text_size=(size)
    self.view.get.textSize = size
  end
  
  # def font=(font)
  #   if TYPE_FACE_OPTIONS.keys.include? font
  #     self.view.get.typeFace = TYPE_FACE_OPTIONS[font]
  #   else
  #     raise "The value #{font} is not a supported font value. Use one of #{TYPE_FACE_OPTIONS.keys}"
  #   end
  # end
  
  def hint=(t)
    self.view.get.hint = t
  end
  
  def alpha=(value)
    self.view.get.alpha = value
  end
  
  def input_type=(text_type)
    if INPUT_TYPES.keys.include? text_type
      self.view.get.inputType = INPUT_TYPES[text_type]
    else
      puts "The value #{text_type} is not a supported input_type value. Defaulting to normal text."
      self.input_type = :normal
    end
  end
  
  def gravity=(alignment)
    if GRAVITY_OPTIONS.keys.include? alignment
      self.view.get.gravity = GRAVITY_OPTIONS[alignment]
    else
      puts "The value #{alignment} is not a supported gravity value. Defaulting to center."
      self.gravity = :center
    end
  end
  
  def layout_gravity=(alignment)
    if GRAVITY_OPTIONS.keys.include? alignment
      self.params.gravity = GRAVITY_OPTIONS[alignment]
    else
      puts "The value #{alignment} is not a supported gravity value. Defaulting to center."
      self.params.gravity = :center
    end
  end
  
  def number_of_columns=(columns)
    self.view.get.numColumns = columns
  end
  
  def stretch_mode=(mode)
    # TODO add shortcuts for stretch modes
    self.view.get.stretchMode = mode
  end
  
  def vertical_spacing=(space)
    self.view.get.verticalSpacing = space
  end
end
