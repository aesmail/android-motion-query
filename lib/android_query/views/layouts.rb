module AndroidQuery
  # class Layout
#     attr_accessor :view, :layout_params, :param_class
#
#     def create_android_query_view(view, options, context)
#       self.view = AndroidQuery::View.new(view, options, context)
#     end
#   end
#
#   class LinearLayout < Layout
#     def initialize(options, context)
#       view = Android::Widget::LinearLayout.new(context)
#       create_android_query_view(view, options, context)
#       self.set_layout_params(self.view.options)
#       self.view
#     end
#
#     def set_layout_params(options)
#       self.param_class = Android::Widget::LinearLayout::LayoutParams
#       self.layout_params = self.param_class.new(options[:width], options[:height])
#       self.layout_params.weight = options[:weight]
#       self.setWeightSum(options[:weight_sum])
#       self.view.get.setLayoutParams(self.layout_params)
#       self.view
#     end
#   end
#
#   class RelativeLayout < Layout
#     def initialize(options, context)
#       view = AndroidQuery::RelativeLayout.new(context)
#       create_android_query_view(view, options, context)
#       self.set_layout_params(self.view.options)
#       self.view
#     end
#
#     def set_layout_params(options)
#       self.param_class = Android::Widget::RelativeLayout::LayoutParams
#       self.layout_params = self.param_class.new(options[:width], options[:height])
#       self.view.get.setLayoutParams(self.layout_params)
#     end
#   end
#
#   class FrameLayout < Layout
#     def initialize(options, context)
#       view =  AndroidQuery::FrameLayout.new(context)
#       create_android_query_view(view, options, context)
#       self.set_layout_params(self.view.options)
#       self.view
#     end
#
#     def set_layout_params(options)
#       self.param_class = Android::Widget::RelativeLayout::LayoutParams
#       self.layout_params = self.param_class.new(options[:width], options[:height])
#       self.view.getsetLayoutParams(self.layout_params)
#       self.view
#     end
#   end
end