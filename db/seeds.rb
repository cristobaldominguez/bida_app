# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

if Rails.env == 'development'

  # Users
  User.destroy_all
  users = [{ name: 'Cristóbal', lastname: 'Domínguez', email: 'cris@me.com', password: '123123' },
           { name: 'Matías', lastname: 'Sjogren', email: 'matias@bf.com', password: '123123' },
           { name: 'Ida', lastname: 'Hoffman', email: 'ida.hoffman87@example.com', password: '123123' },
           { name: 'Ellen', lastname: 'Sanders', email: 'ellen.sanders@example.com', password: '123123' },
           { name: 'Lester', lastname: 'Murray', email: 'lester.murray@example.com', password: '123123' },
           { name: 'Vicki', lastname: 'Hunter', email: 'vicki.hunter@example.com', password: '123123' },
           { name: 'Frank', lastname: 'Horton', email: 'frank.horton@example.com', password: '123123' },
           { name: 'Jorge', lastname: 'Berry', email: 'jorge.berry@example.com', password: '123123' },
           { name: 'Ethan', lastname: 'Fletcher', email: 'ethan.fletcher@example.com', password: '123123' },
           { name: 'Jane', lastname: 'Hansen', email: 'jane.hansen@example.com', password: '123123' },
           { name: 'Leonard', lastname: 'Crawford', email: 'leonard.crawford@example.com', password: '123123' }]
  users.each do |user|
    User.create!(name: user[:name], lastname: user[:lastname], email: user[:email], password: user[:password])
  end

  # Countries
  Country.destroy_all
  countries = ['Australia', 'Chile', 'United States', 'New Zealand', 'Peru']
  countries.sort { |a, b| a <=> b }.each do |country|
    Country.create!(name: country)
  end

  # Industries
  Industry.destroy_all
  industries = ['Beverage', 'Brewery', 'Dairy', 'Domestic Sewage', 'Energy', 'Food Processor',
                'Goverment', 'Grower', 'Milk Processor', 'Municipality', 'Real State',
                'Real State/Households/Hotels', 'Seafood Processor', 'Slaughterhouse',
                'University', 'Waste Management', 'Winery', 'WWT Provider']
  industries.sort { |a, b| a <=> b }.each do |industry|
    Industry.create!(name: industry)
  end

  # Discharge Points
  DischargePoint.destroy_all
  discharge_point = ['Irrigation', 'Stream', 'Land Application', 'Infiltration', 'Pond', 'Sewer', 'Other']
  discharge_point.sort { |a, b| a <=> b }.each do |point|
    DischargePoint.create!(name: point)
  end

  # Incident Types
  IncidentType.destroy_all
  incidents = ['ph Imbalance', 'Worms Mortality', 'Odors', 'Run off Chemicals', 'Flooding']
  incidents.each do |incident|
    IncidentType.create!(name: incident)
  end

  # Statuses
  Status.destroy_all
  statuses = ['Open', 'Fixed', 'Being Remedied']
  statuses.each do |status|
    Status.create!(name: status)
  end

  # Priorities
  Priority.destroy_all
  priorities = ['Within 24 Hours', 'Within 3 Days', 'Within 7 Days', 'Within 30 Days']
  priorities.each do |priority|
    Priority.create!(name: priority)
  end

  # Outlets
  Outlet.destroy_all
  outlets = %w[In Out]
  outlets.each do |outlet|
    Outlet.create!(name: outlet)
  end

  # Options
  Option.destroy_all
  options = ['Flow', 'Ph', 'Temp', 'EC', 'TDS', 'BOD', 'COD', 'TSS', 'FOG', 'TN', 'TKN',
             'Ammonia as N', 'Nitrate as N', 'Nitrite as N', 'TP', 'DO', 'Alkalinity as CaCo3',
             'Bicarbonate as CaCO3', 'Fecal Coliform', 'Foam Concentrate']
  options.each do |option|
    Option.create!(name: option)
  end

  # Access
  Access.destroy_all
  accesses = %w[Lab Internal]
  accesses.each do |access|
    Access.create!(name: access)
  end

  # Frecuency
  Frecuency.destroy_all
  frecuencies = %w[Weekly Monthly Annualy]
  frecuencies.each do |frecuency|
    Frecuency.create!(name: frecuency)
  end

  # Odor
  Odor.destroy_all
  odors = ['Typical', 'No Typical (Describe)']
  odors.each do |odor|
    Odor.create!(option: odor)
  end

  # Color
  Color.destroy_all
  colors = ['Typical', 'No Typical (Describe)']
  colors.each do |color|
    Color.create!(option: color)
  end

  # Screen
  Screen.destroy_all
  screens = ['Normal', 'Clogged', 'Film has Formed']
  screens.each do |screen|
    Screen.create!(option: screen)
  end

  # CollectionBin
  CollectionBin.destroy_all
  collection_bins = %w[Normal Full Spillage]
  collection_bins.each do |collection_bin|
    CollectionBin.create!(option: collection_bin)
  end

  # Noise
  Noise.destroy_all
  noises = ['Normal', 'Unnormal (Describe)']
  noises.each do |noise|
    Noise.create!(option: noise)
  end

  # SprinklersPressure
  SprinklersPressure.destroy_all
  sprinklers_pressures = %w[Low Normal High]
  sprinklers_pressures.each do |pressure|
    SprinklersPressure.create!(option: pressure)
  end

  # SprinklersHead
  SprinklersHead.destroy_all
  sprinklers_heads = %w[Normal Clogged Missing]
  sprinklers_heads.each do |head|
    SprinklersHead.create!(option: head)
  end

  # Piping
  Piping.destroy_all
  pipings = %w[Normal Leaking Broken]
  pipings.each do |piping|
    Piping.create!(option: piping)
  end

  # SystemSurface
  SystemSurface.destroy_all
  system_surfaces = ['Normal', 'Vegetation Growing', 'Trash']
  system_surfaces.each do |surface|
    SystemSurface.create!(option: surface)
  end

  # WormsColor
  WormsColor.destroy_all
  worms_colors = ['Normal', 'Unnormal (Describe)']
  worms_colors.each do |color|
    WormsColor.create!(option: color)
  end

  # WormsActivity
  WormsActivity.destroy_all
  worms_activities = ['Active', 'No Active (Describe)']
  worms_activities.each do |activity|
    WormsActivity.create!(option: activity)
  end

  # WormsDensity
  WormsDensity.destroy_all
  worms_densities = %w[Low Normal High]
  worms_densities.each do |activity|
    WormsDensity.create!(option: activity)
  end

  # BedCompaction
  BedCompaction.destroy_all
  bed_compactions = ['Normal', 'Compaction (Need Rototill)']
  bed_compactions.each do |compaction|
    BedCompaction.create!(option: compaction)
  end

  # Ponding
  Ponding.destroy_all
  pondings = ['No Ponding', 'High Ponding (Urgent Rototill)']
  pondings.each do |ponding|
    Ponding.create!(option: ponding)
  end

  # Fly
  Fly.destroy_all
  flies = %w[No Low High]
  flies.each do |fly|
    Fly.create!(option: fly)
  end

  # Output
  Output.destroy_all
  outputs = %w[Influent Effluent]
  outputs.each do |output|
    Output.create!(name: output)
  end

  puts 'Seeds Added!'
end
