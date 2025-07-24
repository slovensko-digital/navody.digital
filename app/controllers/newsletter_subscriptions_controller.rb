class NewsletterSubscriptionsController < ApplicationController

  def subscribe
    email, altcha = subscription_params
    if AltchaSolution.verify_and_save(altcha)
      SubscribeToNewsletterJob.perform_later(email, 'NewsletterSubscription')
      respond_to do |format|
        format.js { render :success}
      end
    else
      respond_to do |format|
        format.js { render :altcha_failure, status: :unprocessable_entity}
      end
    end
  end

  private

  def subscription_params
    params.require([:email, :altcha])
  end
end
