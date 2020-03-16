class SamplingListGenerator
  def initialize(plant)
    @plant = plant
    @access = Access.all
  end

  def build
    standard_bounds
    @access.map { |access| @plant.sampling_lists.build(access: access, per_cycle: 1) }
  end

  def create(sampling_list)
    create_samplings(sampling_list)
  end

  def edit(with_params: pms)
    # @sampling_list = sampling_list
    @params = with_params
    @external = @plant.sampling_lists.select { |sl| sl.access.name == 'External' }.first
    @current_samplings = select_current_samplings

    return nil unless need_to_edit_samplings?

    remove_samplings
    add_samplings
    update_samplings
  end

  private

  def update_samplings
    @to_update = current_samplings_arr & external_samplings_arr
    return nil unless @to_update.present?

    @to_update.map { |id| @external.samplings.includes(:standard).select { |sampling| sampling.standard.option_id == id } }.flatten.each(&:active!)
  end

  def remove_samplings
    @to_remove = external_samplings_arr - current_samplings_arr
    return nil unless @to_remove.present?

    @to_remove.map { |id| @external.samplings.includes(:standard).select { |sampling| sampling.standard.option_id == id } }.flatten.each(&:inactive!)
  end

  def add_samplings
    to_add = current_samplings_arr - external_samplings_arr
    return nil unless to_add.present?

    @options = Option.all
    to_add.each { |number| build_sampling(number) }
  end

  def build_sampling(number)
    standard = @plant.standards.select { |stndrd| stndrd.option_id == number }.last
    @plant.sampling_lists.first.samplings.build(standard: standard, active: true)
  end

  def create_samplings(sampling_list)
    sampling_list.access.name == 'External' ? create_extenal_samplings(sampling_list) : create_internal_samplings(sampling_list)
  end

  def create_extenal_samplings(sampling_list)
    @plant.standards
          .select(&:enabled)
          .each { |standard| sampling_list.samplings.build(standard: standard) }
  end

  def create_internal_samplings(sampling_list)
    @plant.standards.each { |standard| sampling_list.samplings.build(standard: standard) }
  end

  def need_to_edit_samplings?
    external_samplings_arr != current_samplings_arr
  end

  def current_samplings_arr
    @current_samplings.map { |cs| cs['option_attributes']['id'].to_i }
  end

  def external_samplings_arr
    @external.samplings.map { |s| s.standard.option_id }
  end

  def select_current_samplings
    keys_arr = []
    @params.each { |_, p| keys_arr.push p['enabled'] == '1' ? p : nil }
    keys_arr.compact!
  end

  def standard_bounds
    Option.all
          .map { |option| @plant.standards.build(option: option) }
          .each { |standard| Outlet.all.each { |outlet| standard.bounds.build(outlet: outlet) } }
  end
end
