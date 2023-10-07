class RemoveStaleBlobs < ApplicationJob
  queue_as :default

  # TODO: Setup this as a cron job and run once a week
  def perform
    # In `GeneralAgenda` user can upload a file which creates an `ActiveStorage::Blob`
    # if this form is not converted into `Uvps::Submission`, the file remains uploaded, but not attached anywhere
    # These files should be regularly purged
    ActiveStorage::Blob.unattached.where('created_at < ?', 3.days.ago).each(&:purge_later)
  end
end
