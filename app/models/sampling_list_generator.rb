class SamplingListGenerator
  def initialize(plant, access)
    @plant = plant
    @access = access
  end

  def build
    standards = Option.all.map { |option| @plant.standards.build(option: option) }
    standards.each { |standard| Outlet.all.each { |outlet| standard.bounds.build(outlet: outlet) } }
    @sampling_list = @plant.sampling_lists.build(access: @access, per_cycle: 1)
    standards.each { |standard| @sampling_list.samplings.build(standard: standard) }

    @sampling_list
  end

  def create; end
end
