##
# This concern extracts the data from an attached spreadsheet. Assumes the
# spreadsheet is in a PaperClip attachement attribute called spreadsheet.
#
module SpreadsheetExtractor
  extend ActiveSupport::Concern

  def to_data
    [{}]
  end

  def read_spreadsheet
    open_spreadsheet && open_spreadsheet.read
  end

  def open_spreadsheet
    return self.spreadsheet.queued_for_write[:original] unless self.persisted?

    open self.spreadsheet.path
  end
end