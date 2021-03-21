class AnonymousUser
  attr_reader :uuid

  def initialize(uuid)
    @uuid = uuid
  end

  def logged_in?
    false
  end

  def build_submission(params, extra:, skip_subscribe:, callback_step:)
    submission = Submission.new(params)
    submission.anonymous_user_uuid = @uuid
    submission.extra = params[:raw_extra] ? JSON.parse(params[:raw_extra]) : extra
    submission.skip_subscribe = skip_subscribe
    submission.current_user = self
    submission.callback_step = callback_step
    submission
  end

  def find_submission!(uuid)
    Submission.where(anonymous_user_uuid: self.uuid, uuid: uuid).first!
  end
end
