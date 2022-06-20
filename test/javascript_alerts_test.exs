defmodule JavascriptAlerts do
  # Import helpers
  use Hound.Helpers
  use ExUnit.Case
  
  def go_to_javascript_alerts() do 
    navigate_to "https://the-internet.herokuapp.com/javascript_alerts"
  end

  describe "Javascript Alerts" do
    hound_session()
    test "JS alert" do
      go_to_javascript_alerts()
      element = find_element(:xpath, "//*[@id='content']/div/ul/li[1]/button")
      click(element)

      assert dialog_text() == "I am a JS Alert"
      accept_dialog()
      
      # checks confirmation of closing JS alert
      result = find_element(:id, "result")
      assert inner_text(result) == "You successfully clicked an alert"
      assert attribute_value(result, "style") == "color: green;"
    end

    test "JS confirm" do
      go_to_javascript_alerts()
      element = find_element(:xpath, "//*[@id='content']/div/ul/li[2]/button")
      click(element)

      assert dialog_text() == "I am a JS Confirm"

      # click 'OK' on the dialog box
      accept_dialog()
      result = find_element(:id, "result")
      assert inner_text(result) == "You clicked: Ok"
      assert attribute_value(result, "style") == "color: green;"

      # click 'Cancel' on the dialog box
      click(element)
      dismiss_dialog()
      assert inner_text(result) == "You clicked: Cancel"
    end

    test "JS prompt" do
      go_to_javascript_alerts()
      element = find_element(:xpath, "//*[@id='content']/div/ul/li[3]/button")
      click(element)
      assert dialog_text() == "I am a JS prompt"

      # enter text into dialog prompt
      prompt_input = "Welcome to Divvy"
      input_into_prompt(prompt_input)
      accept_dialog()

      # checks if text entered is displayed
      result = find_element(:id, "result")
      assert inner_text(result) == "You entered: " <> prompt_input
      assert attribute_value(result, "style") == "color: green;"
    end
  end
end
