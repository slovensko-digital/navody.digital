class ExitsController < ApplicationController
  def redirect_to_external_task
    task = Task.find(params[:task_id])
    user_id = session[:user_id]

    dr = DataReceipt.create(user_id: user_id, task_id: task.id, generated_at: Time.now)

    uri = URI(task.url)
    add_parameter(uri, 'token', dr.token)

    dr.save!
    redirect_to uri.to_s
  end

  def add_parameter(uri, key, value = nil)
    value = nil if value == ''
    new_params = parse_parameters(uri)
    new_params.delete_if {|param_pair| param_pair.first == key }
    new_params << [key, value]

    uri.query = URI.encode_www_form(new_params)
    uri
  end

  def parse_parameters(uri)
    URI.decode_www_form(uri.query || '').map {|key, value| value == '' ? [key] : [key, value]}
  end
end