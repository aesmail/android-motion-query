class AMQAdapter < Android::Widget::BaseAdapter
  attr_accessor :mContext, :items
  
  def initialize(context, list, options={})
    self.mContext = context
    self.items = list
  end
  
  def getCount
    self.items.count
  end
  
  def getItemId(position)
    0
  end
  
  def getItem(position)
    self.items[position]
  end
  
  def getView(position, convert_view, parent)
    text_view = Android::Widget::TextView.new(self.mContext)
    text_view.text = self.items[position]
    text_view
  end
end
