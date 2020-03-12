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

  private

  def standard_bounds
    Option.all
          .map { |option| @plant.standards.build(option: option) }
          .each { |standard| Outlet.all.each { |outlet| standard.bounds.build(outlet: outlet) } }
  end
end
