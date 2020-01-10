module RemainingDaysHelper
  def format_vote_post_remaining_days_hint(form, message = '')
    if form.vote_by_post_expired?
      'Termín hlasovania poštou uplynul 10.1.2020.'
    else
      if form.vote_by_post_remaining_days > 1
        message << " Ostáva ešte #{form.vote_by_post_remaining_days} dní."
      elsif form.vote_by_post_remaining_days == 1
        message << " Ostáva už len 1 deň."
      elsif form.vote_by_post_remaining_days == 0
        message << " Dnes je posledný možný termín."
      end
      message
    end
  end
end


