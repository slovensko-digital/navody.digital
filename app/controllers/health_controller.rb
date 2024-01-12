class HealthController < ApplicationController

  def index
    database_check_results = check_db_connections
    if all_database_healthy?(database_check_results)
      render json: {status: "ok", databases: database_check_results}, status: :ok
    else
      render json: {status: "error", databases: database_check_results}, status: :internal_server_error
    end
  end

  private
  def all_database_healthy?(database_check_results)
    database_check_results.values.all? { |status| status[:status] == "ok" }
  end

  def check_db_connections
    db_status = {}
    databases.each do |role, connection|
      db_status[role] = perform_health_check(connection)
    ensure
      ActiveRecord::Base.clear_active_connections!
    end
    db_status
  end

  def databases
    {
      primary: ActiveRecord::Base.connected_to(role: :writing) { ApplicationRecord.connection },
      datahub: ActiveRecord::Base.connected_to(role: :reading) { DatahubRecord.connection }
    }
  end

  def perform_health_check(connection)
    if connection
      connection.execute('SELECT 1')
      {status: 'ok'}
    else
      {status: 'error', message: 'Connection not established'}
    end
  rescue => e
    {status: 'error', message: e.message}
  end
end
