class AMQScreen < Android::App::Activity
  attr_accessor :amq, :extras
  
  def onCreate(savedInstance)
    super
    self.create_amq_object
    # self.get_extras(savedInstance)
    self.on_create(savedInstance)
  end
    
  def create_amq_object
    self.amq = AndroidMotionQuery.new(self)
  end
  
  def open_screen(screen, extra_data={})
    intent = Android::Content::Intent.new(self, screen)
    extra_data.each do |k, v|
      puts "Putting #{k} as #{v}"
      intent.putExtra(k.to_s, v)
    end
    startActivity(intent)
  end
  
  def extra(key)
    data = getIntent.getExtra(key.to_s)
    new_data = Android::Text::SpannableStringBuilder.new(data)
    new_data.toString
    # case data.class
    # when Android::Text::SpannableStringBuilder
    #   puts "---------------------------------- converting SpannableStringBuilder"
    #   data.toString
    # when Android::Text::SpannableString
    #   puts "---------------------------------- converting SpannableString"
    #   new_data = Android::Text::SpannableStringBuilder.new(data)
    #   new_data.toString
    # else
    #   puts "---------------------------------- converting CUSTOM #{data.class}"
    #   data
    # end
  end
end
