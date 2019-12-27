class FlowImport < Import
  def load_imported_items
    spreadsheet = open_spreadsheet.sheet('Flow')
    header = spreadsheet.row(1)
    flow_report = FlowReport.new(plant_id: plant, date: date)

    (2..spreadsheet.last_row).map do |index|
      create_row_data(index, spreadsheet, header, flow_report)
    end
  end

  def create_row_data(index, spreadsheet, header, flow_report)
    row_data = spreadsheet.row(index).map { |r| r.instance_of?(String) ? r.strip : r }
    row_data = row_data.map { |r| r == '-' ? nil : r }
    current_row = Hash[[header, row_data].transpose]
    flow_report.flows.build(plant_id: plant, date: current_row['Date'], value: current_row['Value'])
  end
end
