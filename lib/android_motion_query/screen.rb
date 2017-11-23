class AMQScreen < Android::App::Activity
  attr_accessor :amq, :extras
  
  def onCreate(savedInstance)
    super
    self.create_amq_object
    self.on_create(savedInstance)
  end
    
  def create_amq_object
    self.amq = AndroidMotionQuery.new(self)
  end
  
  def open_screen(screen, extra_data={})
    intent = Android::Content::Intent.new(self, screen)
    extra_data.each do |k, v|
      intent.putExtra(k.to_s, v)
    end
    startActivity(intent)
  end
  
  def extra(key)
    data = getIntent.getExtra(key.to_s)
    if data.nil?
      puts "WARNING: The extra data (#{key.to_s}) you are trying to get is nil"
    end
    data
  end
end
