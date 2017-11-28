class AMQAdapter < Android::Widget::BaseAdapter
  attr_accessor :context, :items, :view_block
  
  def initialize(context, list, &block)
    self.context = context
    self.items = list
    self.view_block = block if block_given?
    self
  end
  
  def getCount
    self.items.length
  end
  
  def getItemId(position)
    0
  end
  
  def getItem(position)
    self.items[position]
  end
  
  def getView(position, convert_view, parent)
    self.custom_view(position, convert_view, parent, &self.view_block)
  end
  
  def custom_view(position, convert_view, parent, &block)
    if block_given?
      block.call(self.items[position], position)
    else
      text_view = Android::Widget::TextView.new(self.context)
      text_view.text = self.items[position]
      text_view
    end
  end
end
