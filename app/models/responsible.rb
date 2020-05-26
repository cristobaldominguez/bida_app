class Responsible
  def initialize(plant)
    @plant = plant
  end

  def self.get_list(plant)
    @plant = plant
    [[-1, 'BioFiltro'], [0, plant.company.name]] + User.filtered_by(plant).map {|u| [u.id, u.full_name] }
  end

  def self.name(task)
    get_list(task.task_list.plant).select {|r| r.first == task.responsible }.last.last
  end
end
