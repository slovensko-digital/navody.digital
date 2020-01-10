module FormatDaysHelper
  def format_remaining_days(remaining_days)
    if remaining_days > 1
      "Ostáva ešte #{remaining_days} dní."
    elsif remaining_days == 1
      "Ostáva už len 1 deň."
    elsif remaining_days == 0
      "Dnes je posledný možný termín."
    end
  end
end


