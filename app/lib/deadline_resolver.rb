class DeadlineResolver
  def initialize(date_info, today = Date.today)
    is_one_time_event = date_info.start_with?(/\d{4}-/)
    @due_date = is_one_time_event ? Date.parse(date_info) : Date.parse("#{today.year}-#{date_info}")
    @due_date = @due_date + 365 if !is_one_time_event && (today - @due_date) > 365 / 2
    @today = today
  end

  def is_past_due?
    @due_date < @today
  end

  def remaining_days
    (@due_date - @today).to_i
  end
end
