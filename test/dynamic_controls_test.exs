defmodule DynamicControls do
  # Import helpers
  use Hound.Helpers
  use ExUnit.Case
  use Retry
  
  def go_to_dynamic_controls() do 
    navigate_to "https://the-internet.herokuapp.com/dynamic_controls"
  end

  # function to wait for page elements to display/hide
  def wait_for(func) do
    :timer.sleep(100)
    case func.() do
      true -> true
      false -> wait_for(func)
    end
  end

  describe "Dynamic Controls" do
    hound_session()
    test "Remove/Add checkbox" do
        go_to_dynamic_controls()
        
        remove_button = find_element(:xpath, "//*[@id='checkbox-example']/button")
        # click the remove button
        click(remove_button)
        # check for loading bar to display
        assert find_element(:id, "loading")
        # wait for the `It's gone!` message to be displayed
        assert wait_for(fn -> element?(:id, "message") end)
        assert inner_text(find_element(:id, "message")) == "It's gone!"
        assert inner_text(remove_button) == "Add"
        assert catch_error(find_element(:id, "checkbox"))

        # click add button
        click(remove_button)
        # checks for the `It's back` message to be displayed
        assert find_element(:id, "loading")
        assert wait_for(fn -> element?(:id, "message") end)
        assert inner_text(find_element(:id, "message")) == "It's back!"
        # checks for butoton text is updated
        assert inner_text(remove_button) == "Remove"
        # checks that checkbox is missing
        assert find_element(:id, "checkbox")
    end
    
    test "enable/disable input field" do
        go_to_dynamic_controls()

        input_field = find_element(:xpath, "//*[@id='input-example']/input")
        assert element_enabled?(input_field) == false

        enable_button = find_element(:xpath, "//*[@id='input-example']/button")
        click(enable_button)
        # checks the `It's enabled` message is displayed
        assert find_element(:id, "loading")
        assert wait_for(fn -> element_enabled?(input_field) end)
        assert inner_text(find_element(:id, "message")) == "It's enabled!"
        # checks button text now says 'Disable'
        assert inner_text(enable_button) == "Disable"

        click(enable_button)
        # checks `It's disabled!` message is displayed
        assert find_element(:id, "loading")
        assert wait_for(fn -> element_enabled?(input_field) == false end)
        assert inner_text(find_element(:id, "message")) == "It's disabled!"
        # checks button text is updated
        assert inner_text(enable_button) == "Enable"
    end
  end
end