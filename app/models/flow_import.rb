class FlowImport < Import
  def load_imported_items
    spreadsheet = open_spreadsheet.sheet('Flow')
    grouped_rows = grouped_rows(spreadsheet)

    flow_reports(grouped_rows, plant)
  end

  def flow_reports(grouped_rows, plant)
    flow_reports_arr = []
    grouped_rows.each_with_index do |row, index|
      flow_reports_arr[index] = FlowReport.new(plant_id: plant, date: row.first.to_date)
      row.second.map do |data|
        flow_reports_arr[index].flows.build(plant_id: plant, date: data[:date], value: data[:value])
      end
    end

    flow_reports_arr
  end
end
