class AMQClickListener
  attr_accessor :activity, :method_name
  def initialize(activity, method_name)
    self.activity = activity
    self.method_name = method_name
  end
  
  def onClick(view)
    self.activity.send(self.method_name.to_s, view)
  end
end


class AMQTapListener
  attr_accessor :activity, :amq, :callback
  def initialize(activity, amq, &block)
    self.activity = activity
    self.callback = block
    self.amq = amq
    self
  end
  
  def onClick(view)
    self.callback.call(view)
  end
end
