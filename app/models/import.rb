class Import
  include ActiveModel::Model
  require 'roo'

  attr_accessor :file, :plant

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
    @rows = []
  end

  def persisted?
    false
  end

  def open_spreadsheet
    case File.extname(file.original_filename)
    when '.xls' then Roo::Excel.new(file.path, nil, :ignore)
    when '.xlsx' then Roo::Excelx.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def imported_items
    @imported_items ||= load_imported_items
  end

  def grouped_rows(spreadsheet)
    header = spreadsheet.row(1).map { |h| h.parameterize.underscore.to_sym }
    rows_arr = rows(spreadsheet, header)
    group_structure(rows_arr)
  end

  def group_structure(rows)
    rows.group_by { |r| r[:date].beginning_of_month.strftime('%Y-%m-%d') }
  end

  def rows(spreadsheet, header)
    (2..spreadsheet.last_row).map do |index|
      create_row_data(index, spreadsheet, header)
    end
  end

  def create_row_data(index, spreadsheet, header)
    row_data = spreadsheet.row(index).map { |r| r.instance_of?(String) ? r.strip : r }
    row_data = row_data.map { |r| r == '-' ? nil : r }
    Hash[[header, row_data].transpose]
  end

  def save
    if imported_items.map(&:valid?).all?
      imported_items.each(&:save!)
      true
    else
      handle_errors(imported_items)
      false
    end
  end

  def handle_errors(imported_items)
    imported_items.each_with_index do |item, index|
      item.errors.full_messages.each do |msg|
        errors.add :base, "Row #{index + 6}: #{msg}"
      end
    end
  end
end
