class Capybara::Session
  def submit(element)
    Capybara::RackTest::Form.new(driver, element.native).submit({})
  end
end

# monkey patch submit method to match 3 parameters
class Capybara::RackTest::Form < Capybara::RackTest::Node
  def submit(button)
    action = button&.[]('formaction') || native['action']
    method = button&.[]('formmethod') || request_method
    driver.submit(method, action.to_s, params(button))
  end
end
