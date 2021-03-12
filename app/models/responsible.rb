class Responsible
  def initialize(plant)
    @plant = plant
  end

  def self.get_list(plant)
    User.filtered_by(plant).sort.map { |u| [u.id, u.full_name] }
  end

  def self.get_complete_list
    User.filtered.sort.map { |u| [u.id, u.full_name] }
  end

  def self.name(task)
    get_complete_list.select { |r| r.first == task.responsible }.last.last
  end

  def self.name_by_id(id)
    User.find(id)
  end
end
