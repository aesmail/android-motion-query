class AMQScreen < Android::App::Activity
  attr_accessor :amq
  def onCreate(savedInstance)
    super
    self.create_amq_object
    self.on_create(savedInstance)
  end
    
  def create_amq_object
    self.amq = AndroidMotionQuery.new(self)
  end
  
  def open(screen, extra={})
    intent = Android::Content::Intent.new(self, screen)
    extra.each {|k, v| intent.putExtra(k.to_s, v) }
    startActivity(intent)
  end
end
