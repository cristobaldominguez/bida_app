class Responsible
  def initialize(plant)
    @plant = plant
  end

  def self.get_list(plant)
    [[-1, 'BioFiltro'], [0, plant.company.name]] + User.filtered_by(plant).sort.map {|u| [u.id, u.full_name] }
  end

  def self.get_complete_list(plant)
    [[-1, 'BioFiltro'], [0, plant.company.name]] + User.filtered.sort.map {|u| [u.id, u.full_name] }
  end

  def self.name(task)
    get_list(task.task_list.plant).select {|r| r.first == task.responsible }.last.last
  end
end
