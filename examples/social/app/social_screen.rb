class SocialScreen < AMQScreen
  def on_create(state)
    setup_users
    amq.stylesheet = SocialStyle
    amq.add(:linear_layout, :top_layout) do |top|
      @user_grid = top.add(:grid_view, :users_grid)
    end
  end
  
  def setup_users
    @users = []
    amq.json.get("https://jsonplaceholder.typicode.com/users/") do |response|
      if response.success?
        @users = response.result
        # TODO @users is not an array, it's a JSONArray and needs to be converted to a ruby array
        @user_grid.adapter(@users) do |user|
          amq.add_alone(:linear_layout, :user_layout) do |user_layout|
            user_layout.add(:text_view, :user_name).text = user.get("name")
          end.get
        end
      else
        puts "Ops! Something went wrong"
        puts response.result
      end
    end
  end
end


class SocialStyle < AMQStylesheet
  def top_layout(st)
    st.width = :mp
  end
  
  def users_grid(st)
    st.number_of_columns = 1
    st.stretch_mode = 1
  end
  
  def user_layout(st)
    st.width = :mp
  end
  
  def user_name(st)
    st.text_alignment = :center
    st.height = :wc
    st.text_color = :red
  end
end