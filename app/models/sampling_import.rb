class SamplingImport < Import
  def load_imported_items
    @spreadsheet = open_spreadsheet.sheet('Samplings')
    @rows = grouped_rows(@spreadsheet)

    sampling_lists
  end

  def group_structure(rows)
    rows.group_by { |r| r[:date] }
        .map { |k, v| { list: { date: k, access: v.first[:access] }, samplings: v.map { |s| { date: s[:date], option: s[:option], value_in: s[:value_in], value_out: s[:value_out] } } } }
  end

  def sampling_lists
    @plant = Plant.find(plant)
    sls = []

    @rows.each do |row|
      sls << SamplingListsController.api_new(@plant, row[:list][:access], row, row[:list][:date])
    end

    sls
  end

  def grouped_by_access(accesses)
    @plant.sampling_lists
          .group_by { |sl| accesses.find(sl.access).parameterize.underscore.to_sym }
          .map { |key, v| { key => v.max_by(&:created_at) } }.reduce({}, :merge)
  end
end
