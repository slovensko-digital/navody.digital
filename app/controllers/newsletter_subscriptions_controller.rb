class NewsletterSubscriptionsController < ApplicationController

  def subscribe
    email, altcha = subscription_params
    if AltchaSolution.verify_and_save(altcha)
      begin
        EmailService.subscribe_to_newsletter_with_doi(email, 'NewsletterSubscription')
        respond_to do |format|
          format.js { render :success}
        end
      rescue => e
        respond_to do |format|
          format.js { render :subscription_failure, status: :bad_request }
        end
      end
    else
      respond_to do |format|
        format.js { render :failure, status: :unprocessable_content}
      end
    end
  end

  def confirmed
    redirect_to root_path, notice: 'Ďakujeme za potvrdenie! Vaša emailová adresa bola pridaná do nášho zoznamu odberateľov.'
  end

  private

  def subscription_params
    params.require([:email, :altcha])
  end
end
