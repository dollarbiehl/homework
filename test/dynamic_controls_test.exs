defmodule DynamicControls do
  # Import helpers
  use Hound.Helpers
  use ExUnit.Case
  use Retry
  
  def go_to_dynamic_controls() do 
    navigate_to "https://the-internet.herokuapp.com/dynamic_controls"
  end

  def wait_for(func) do
    :timer.sleep(100)
    case func.() do
      true -> true
      false -> wait_for(func)
    end
  end

  # Start hound session and destroy when tests are run
  describe "Dynamic Controls" do
    hound_session()
    test "Remove checkbox" do
        go_to_dynamic_controls()
        
        checkbox = find_element(:id, "checkbox")
        remove_button = find_element(:xpath, "//*[@id='checkbox-example']/button")
        click(remove_button)
        assert find_element(:id, "loading")
        
        assert wait_for(fn -> element?(:id, "message") end)
        assert inner_text(find_element(:id, "message")) == "It's gone!"
        assert inner_text(remove_button) == "Add"
    end
    
    test "enable/disable input field" do
        go_to_dynamic_controls()

        input_field = find_element(:xpath, "//*[@id='input-example']/input")
        assert element_enabled?(input_field) == false

        enable_button = find_element(:xpath, "//*[@id='input-example']/button")
        click(enable_button)
        assert find_element(:id, "loading")
        assert wait_for(fn -> element_enabled?(input_field) end)
        assert inner_text(find_element(:id, "message")) == "It's enabled!"
        assert inner_text(enable_button) == "Disable"

        click(enable_button)
        assert find_element(:id, "loading")
        assert wait_for(fn -> element_enabled?(input_field) == false end)
        assert inner_text(find_element(:id, "message")) == "It's disabled!"
        assert inner_text(enable_button) == "Enable"
    end
  end
end