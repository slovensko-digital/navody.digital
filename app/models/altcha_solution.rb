class AltchaSolution < ApplicationRecord
  validates :algorithm, :challenge, :salt, :signature, :number, presence: true
  attr_accessor :took

  def self.verify_and_save(base64encoded)
    p = JSON.parse(Base64.decode64(base64encoded)) rescue nil
    return false if p.nil?

    submission = Altcha::Submission.new(p)
    return false unless submission.valid?

    solution = self.new(p)

    begin
      return solution.save
    rescue ActiveRecord::RecordNotUnique
      # Replay attack
      return false
    end
  end

  def self.cleanup
    # Replay attacks are protected by the time stamp in the salt of the challenge for
    # the duration configured in the timeout. All solutions in the database that older
    # can be deleted.
    AltchaSolution.where('created_at < ?', Time.now - Altcha.timeout).delete_all
  end
end
