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
