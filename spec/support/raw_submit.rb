class Capybara::Session
  def submit(element)
    Capybara::RackTest::Form.new(driver, element.native).submit({})
  end
end
