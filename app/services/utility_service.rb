module UtilityService
  module_function

  def yes?(value)
    value.to_s.in?(['1', 'true'])
  end
end
