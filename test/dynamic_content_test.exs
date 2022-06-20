defmodule DynamicContent do
  # Import helpers
  use Hound.Helpers
  use ExUnit.Case
  use Retry
  
  def go_to_dynamic_content() do 
    navigate_to "https://the-internet.herokuapp.com/dynamic_content"
  end

  describe "Dynamic Content" do
    hound_session()
    test "new image is found when page is refreshed" do
        go_to_dynamic_content()
    
        img_1 = find_element(:xpath, "//*[@id='content']/div[1]/div[1]/img")
        img_src_1 = attribute_value(img_1, "src")

        # continues to refresh page until we assertion is true
        retry with: constant_backoff(100) |> Stream.take(10) do
            refresh_page()

            img_2 = find_element(:xpath, "//*[@id='content']/div[1]/div[1]/img")
            img_src_2 = attribute_value(img_2, "src")

            assert img_src_2 != img_src_1
        after 
            result -> result
        else
            error -> error
        end
    end
  end
end