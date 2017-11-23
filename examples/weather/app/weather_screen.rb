class WeatherScreen < AMQScreen
  def on_create(state)
    amq.stylesheet = WeatherStyle
    amq.add(:linear_layout, :top_layout) do |top|
      
      top.add(:linear_layout, :city_section) do |city_section|
        city_section.add(:text_view, :city_name)
        city_section.add(:text_view, :weather_condition)
        city_section.add(:text_view, :temperature)
      end
      
      top.add(:linear_layout, :details_section) do |details|
        details.add(:linear_layout, :day_info) do |day_info|
          day_info.add(:text_view, :day_name)
          day_info.add(:text_view, :high_temp)
          day_info.add(:text_view, :low_temp)
        end
        
        details.add(:linear_layout, :hourly_section) do |hourly|
          hourly.add(:linear_layout, :hour_layout) do |now|
            now.add(:text_view, :now_label)
            now.add(:image_view, :moon)
            now.add(:text_view, :temp)
          end
          
          6.times do
            hourly.add(:linear_layout, :hour_layout) do |hour|
              hour.add(:text_view, :hour_label)
              hour.add(:image_view, :moon)
              hour.add(:text_view, :temp)
            end
          end
        end
      end
    end
  end
end


class WeatherStyle < AMQStylesheet
  def top_layout(st)
    st.background_image = 'sky_gradient'
    st.weight_sum = 3
    st.orientation = :vertical
  end
    
  def city_section(st)
    st.height = 0
    st.weight = 1
    st.orientation = :vertical
  end
  
  def city_name(st)
    st.height = :wc
    st.text = 'Kuwait'
    st.text_alignment = :center
    st.text_color = :white
    st.text_size = 32
    st.margin_top = 20
  end
  
  def weather_condition(st)
    st.height = :wc
    st.text = 'Mostly Clear'
    st.text_alignment = :center
    st.text_color = :white
  end
  
  def temperature(st)
    st.height = :wc
    st.text = "16\u00B0"
    st.text_alignment = :center
    st.text_size = 52
    st.text_color = :white
  end
  
  def details_section(st)
    st.height = 0
    st.weight = 2
    st.orientation = :vertical
    st.weight_sum = 10
  end
  
  def day_info(st)
    st.height = :wc
    st.orientation = :horizontal
    st.weight_sum = 10
    st.weight = 1
  end
  
  def day_name(st)
    st.width = 0
    st.text = 'Thursday'
    st.gravity = :center_vertical
    st.text_color = :white
    st.weight = 6
    st.margin_left = 10
  end
  
  def high_temp(st)
    st.width = 0
    st.text = 'High: 23'
    st.text_color = :white
    st.weight = 2
    st.text_alignment = :center
  end
  
  def low_temp(st)
    st.width = 0
    st.text = 'Low: 13'
    st.text_color = :white
    st.weight = 2
    st.text_alignment = :center
  end
  
  def hourly_section(st)
    st.weight = 3
    st.weight_sum = 14
    st.height = 0
  end
  
  def hour_layout(st)
    st.weight = 2
    st.width = 0
    st.orientation = :vertical
    st.weight_sum = 3
  end
  
  def now_label(st)
    st.text = 'Now'
    st.text_color = :white
    st.text_alignment = :center
    st.weight = 1
    st.height = 0
  end
  
  def moon(st)
    st.image = 'moon'
    st.weight = 1
    st.height = 0
  end
  
  def temp(st)
    st.text = "17\u00B0"
    st.text_alignment = :center
    st.height = 0
    st.weight = 1
    st.text_color = :white
  end
  
  def hour_label(st)
    st.text = "02"
    st.text_alignment = :center
    st.height = 0
    st.weight = 1
    st.text_color = :white
  end
end