class QuickTipsController < ApplicationController
  def show
    @quick_tip = QuickTip.find_by_slug(params[:id])
  end
end
