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
        
        details.add(:plain_view, :separator)
        
        details.add(:linear_layout, :hourly_section) do |hourly|
          hours = %w(Now 20 21 22 23 00 01 02)
          temps = %w(18  18 17 16 16 15 15 15)          
          hours.each_with_index do |hour, index|
            hourly.add(:linear_layout, :hour_layout) do |hour_column|
              hour_column.add(:text_view, :hour_label).text = hour
              hour_column.add(:image_view, :moon)
              hour_column.add(:text_view, :temp).text = temps[index]
            end
          end
        end
        
        details.add(:plain_view, :separator)
        
        details.add(:grid_view, :daily_grid) do |daily_table|
          forecast = [
            {day: "Friday",     hi: "23", lo: "13"},
            {day: "Saturday",   hi: "22", lo: "14"},
            {day: "Sunday",     hi: "22", lo: "14"},
            {day: "Monday",     hi: "24", lo: "13"},
            {day: "Tuesday",    hi: "23", lo: "11"},
            {day: "Wednesday",  hi: "22", lo: "11"},
          ]
          daily_table.adapter(forecast) do |day_forecast|
            amq.add_alone(:linear_layout, :daily_layout) do |daily_layout|
              daily_layout.add(:text_view,  :week_day_name).text = day_forecast[:day]
              daily_layout.add(:image_view, :week_day_image)
              daily_layout.add(:text_view,  :week_day_hi).text = day_forecast[:hi]
              daily_layout.add(:text_view,  :week_day_lo).text = day_forecast[:lo]
            end.get
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
    st.text_size = 72
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
  
  def separator(st)
    st.height = 1
    st.background_color = '#999999'
  end
  
  def daily_grid(st)
    st.padding_top = 10
    st.number_of_columns = 1
    st.stretch_mode = 2
    st.vertical_spacing = 5
    st.weight = 6
    st.height = 0
    st.background_color = '#88001B2E'
  end
  
  def daily_layout(st)
    st.weight_sum = 10
  end
  
  def week_day_name(st)
    st.width = 0
    st.height = :wc
    st.weight = 5
    st.margin_left = 10
    st.text_color = :white
  end
  
  def week_day_image(st)
    st.image = 'partly_cloudy'
    st.width = 0
    st.height = 50
    st.weight = 1
    st.layout_gravity = :left
  end
  
  def week_day_hi(st)
    st.text_alignment = :right
    st.width = 0
    st.height = :wc
    st.weight = 3
    st.text_color = :white
  end
  
  def week_day_lo(st)
    st.text_alignment = :center
    st.width = 0
    st.height = :wc
    st.weight = 1
    st.text_color = :white
  end
end