class HardcodeExternalLink < ActiveRecord::Migration[5.2]
  def change
    ExternalLinkTask.update_all url: 'https://navody-prototype.herokuapp.com/zalozenie-zivnosti/ohlasenie/start'
  end
end
