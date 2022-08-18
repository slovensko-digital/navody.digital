class Apps::OrSrApp::StakeholdersIdentifiersController < ApplicationController
  def corporate_body_selection
  end

  def stakeholder_identifier
    cin = params.require(:cin)
    @fuzs_data = UpvsSubmissions::Forms::Fuzs.new(cin)

    redirect_to action: :unsupported unless @fuzs_data.sro?
    redirect_to action: :nothing_missing if @fuzs_data.all_stakeholders_ok?

    @stakeholder_index = params.require(:n).to_i
    @stakeholder = @fuzs_data.stakeholders[@stakeholder_index - 1]
    @next_stakeholder_present = (@stakeholder_index < @fuzs_data.stakeholders.size - 1) ? true : false
  end

  def data_summary
  end

  def done
  end

  def unsupported
  end

  def nothing_missing
  end

  rescue_from OrSrRecordFetcher::OrsrRecordError do |error|
    redirect_to action: :unsupported, error: error
  end
end
