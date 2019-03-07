# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

if Rails.env == 'development'

  puts '----------- Adding Seeds! -----------'

  # Users
  puts 'Adding Users'
  User.destroy_all
  roles = [:client, :operator, :operations_manager, :bf_viewer, :administrative]
  users = [{ name: 'Cristóbal', lastname: 'Domínguez', email: 'cris@me.com', password: '123123', role: :admin },
           { name: 'Matías', lastname: 'Sjogren', email: 'matias@bf.com', password: '123123', role: :admin },
           { name: 'Ida', lastname: 'Hoffman', email: 'ida.hoffman87@example.com', password: '123123', role: roles.sample },
           { name: 'Ellen', lastname: 'Sanders', email: 'ellen.sanders@example.com', password: '123123', role: roles.sample },
           { name: 'Lester', lastname: 'Murray', email: 'lester.murray@example.com', password: '123123', role: roles.sample },
           { name: 'Vicki', lastname: 'Hunter', email: 'vicki.hunter@example.com', password: '123123', role: roles.sample },
           { name: 'Frank', lastname: 'Horton', email: 'frank.horton@example.com', password: '123123', role: roles.sample },
           { name: 'Jorge', lastname: 'Berry', email: 'jorge.berry@example.com', password: '123123', role: roles.sample },
           { name: 'Ethan', lastname: 'Fletcher', email: 'ethan.fletcher@example.com', password: '123123', role: roles.sample },
           { name: 'Jane', lastname: 'Hansen', email: 'jane.hansen@example.com', password: '123123', role: roles.sample },
           { name: 'Leonard', lastname: 'Crawford', email: 'leonard.crawford@example.com', password: '123123', role: roles.sample }]
  users.each do |user|
    User.create!(name: user[:name], lastname: user[:lastname], email: user[:email], password: user[:password], role: user[:role])
  end

  # Countries
  puts 'Adding Countries'
  Country.destroy_all
  countries = ['Australia', 'Chile', 'United States', 'New Zealand', 'Peru']
  countries.sort { |a, b| a <=> b }.each do |country|
    Country.create!(name: country)
  end

  # Industries
  puts 'Adding Industries'
  Industry.destroy_all
  industries = ['Beverage', 'Brewery', 'Dairy', 'Domestic Sewage', 'Energy', 'Food Processor',
                'Goverment', 'Grower', 'Milk Processor', 'Municipality', 'Real State',
                'Real State/Households/Hotels', 'Seafood Processor', 'Slaughterhouse',
                'University', 'Waste Management', 'Winery', 'WWT Provider']
  industries.sort { |a, b| a <=> b }.each do |industry|
    Industry.create!(name: industry)
  end

  # Discharge Points
  puts 'Adding Discharge Points'
  DischargePoint.destroy_all
  discharge_point = ['Irrigation', 'Stream', 'Land Application', 'Infiltration', 'Pond', 'Sewer', 'Other']
  discharge_point.sort { |a, b| a <=> b }.each do |point|
    DischargePoint.create!(name: point)
  end

  # Incident Types
  puts 'Adding Incident Types'
  IncidentType.destroy_all
  incidents = ['ph Imbalance', 'Worms Mortality', 'Odors', 'Run off Chemicals', 'Flooding']
  incidents.each do |incident|
    IncidentType.create!(name: incident)
  end

  # Statuses
  puts 'Adding Statuses'
  Status.destroy_all
  statuses = ['Open', 'Fixed', 'Being Remedied']
  statuses.each do |status|
    Status.create!(name: status)
  end

  # Priorities
  puts 'Adding Priorities'
  Priority.destroy_all
  priorities = ['Within 24 Hours', 'Within 3 Days', 'Within 7 Days', 'Within 30 Days']
  priorities.each do |priority|
    Priority.create!(name: priority)
  end

  # Outlets
  puts 'Adding Outlets'
  Outlet.destroy_all
  outlets = %w[In Out]
  outlets.each do |outlet|
    Outlet.create!(name: outlet)
  end

  # Options
  puts 'Adding Options'
  Option.destroy_all
  options = ['Flow', 'Ph', 'Temp', 'EC', 'TDS', 'BOD', 'COD', 'TSS', 'FOG', 'TN', 'TKN',
             'Ammonia as N', 'Nitrate as N', 'Nitrite as N', 'TP', 'DO', 'Alkalinity as CaCo3',
             'Bicarbonate as CaCO3', 'Fecal Coliform', 'Foam Concentrate']
  options.each do |option|
    Option.create!(name: option)
  end

  # Accesses
  puts 'Adding Accesses'
  Access.destroy_all
  accesses = %w[Lab Internal]
  accesses.each do |access|
    Access.create!(name: access)
  end

  # Frecuencies
  puts 'Adding Frecuencies'
  Frecuency.destroy_all
  frecuencies = %w[Daily Weekly Monthly Annualy]
  frecuencies.each do |frecuency|
    Frecuency.create!(name: frecuency)
  end

  # Odors
  puts 'Adding Odors'
  Odor.destroy_all
  odors = ['Typical', 'No Typical (Describe)']
  odors.each do |odor|
    Odor.create!(option: odor)
  end

  # Colors
  puts 'Adding Colors'
  Color.destroy_all
  colors = ['Typical', 'No Typical (Describe)']
  colors.each do |color|
    Color.create!(option: color)
  end

  # Screens
  puts 'Adding Screens'
  Screen.destroy_all
  screens = ['Normal', 'Clogged', 'Film has Formed']
  screens.each do |screen|
    Screen.create!(option: screen)
  end

  # Collection Bins
  puts 'Adding Collection Bins'
  CollectionBin.destroy_all
  collection_bins = %w[Normal Full Spillage]
  collection_bins.each do |collection_bin|
    CollectionBin.create!(option: collection_bin)
  end

  # Noises
  puts 'Adding Noises'
  Noise.destroy_all
  noises = ['Normal', 'Unnormal (Describe)']
  noises.each do |noise|
    Noise.create!(option: noise)
  end

  # Sprinklers Pressures
  puts 'Adding Sprinklers Pressures'
  SprinklersPressure.destroy_all
  sprinklers_pressures = %w[Low Normal High]
  sprinklers_pressures.each do |pressure|
    SprinklersPressure.create!(option: pressure)
  end

  # Sprinklers Heads
  puts 'Adding Sprinklers Heads'
  SprinklersHead.destroy_all
  sprinklers_heads = %w[Normal Clogged Missing]
  sprinklers_heads.each do |head|
    SprinklersHead.create!(option: head)
  end

  # Pipings
  puts 'Adding Pipings'
  Piping.destroy_all
  pipings = %w[Normal Leaking Broken]
  pipings.each do |piping|
    Piping.create!(option: piping)
  end

  # System Surfaces
  puts 'Adding System Surfaces'
  SystemSurface.destroy_all
  system_surfaces = ['Normal', 'Vegetation Growing', 'Trash']
  system_surfaces.each do |surface|
    SystemSurface.create!(option: surface)
  end

  # Worms Colors
  puts 'Adding Worms Colors'
  WormsColor.destroy_all
  worms_colors = ['Normal', 'Unnormal (Describe)']
  worms_colors.each do |color|
    WormsColor.create!(option: color)
  end

  # Worms Activities
  puts 'Adding Worms Activities'
  WormsActivity.destroy_all
  worms_activities = ['Active', 'No Active (Describe)']
  worms_activities.each do |activity|
    WormsActivity.create!(option: activity)
  end

  # Worms Densities
  puts 'Adding Worms Densities'
  WormsDensity.destroy_all
  worms_densities = %w[Low Normal High]
  worms_densities.each do |activity|
    WormsDensity.create!(option: activity)
  end

  # Bed Compactions
  puts 'Adding Bed Compactions'
  BedCompaction.destroy_all
  bed_compactions = ['Normal', 'Compaction (Need Rototill)']
  bed_compactions.each do |compaction|
    BedCompaction.create!(option: compaction)
  end

  # Pondings
  puts 'Adding Pondings'
  Ponding.destroy_all
  pondings = ['No Ponding', 'High Ponding (Urgent Rototill)']
  pondings.each do |ponding|
    Ponding.create!(option: ponding)
  end

  # Flies
  puts 'Adding Flies'
  Fly.destroy_all
  flies = %w[No Low High]
  flies.each do |fly|
    Fly.create!(option: fly)
  end

  # Outputs
  puts 'Adding Outputs'
  Output.destroy_all
  outputs = %w[Influent Effluent]
  outputs.each do |output|
    Output.create!(name: output)
  end

  # Log Types
  puts 'Adding Log Types'
  LogType.destroy_all
  log_types = ['1) Solid Separation',
               '2) pH Adjustement',
               '3) EQ tank',
               '4) Piping',
               '5) BIDA',
               '6) Telemetry',
               '7) Water Quality',
               '8) Upload Logbook to Dropbox']
  log_types.each do |category|
    LogType.create!(name: category)
  end

  # Input Types
  puts 'Adding Input Types'
  InputType.destroy_all
  input_types = ['checkbox', 'inches', 'pH record', 'date', 'PSI', 'boolean', '% of bed', 'Low/Medium/High Density', 'COD Record', 'Low/Medium/Strong Odor']
  input_types.each do |input_type|
    InputType.create!(option: input_type)
  end

  # Tasks
  puts 'Adding Tasks'
  Task.destroy_all
  tasks = [{ name: 'Check correct operation (1 wash cycle)', log_type_id: 1, input_type_id: 1, frecuency_id: 1, cycle: 1, responsible: 0 },
           { name: 'Clean screen and water jets of rotary screen', log_type_id: 1, input_type_id: 1, frecuency_id: 2, cycle: 1, responsible: 1 },
           { name: 'Remove solids from container bin', log_type_id: 1, input_type_id: 1, frecuency_id: 2, cycle: 1, responsible: 0 },
           { name: 'Check solids level on settling tanks (notify supervisor when more 1 ft)', log_type_id: 1, input_type_id: 2, frecuency_id: 2, cycle: 1, responsible: 1 },
           { name: 'Check pH chemical tank level (notify Supervisor when is 40% and 20% level)', log_type_id: 2, input_type_id: 1, frecuency_id: 1, cycle: 1, responsible: 1 },
           { name: 'Check pH onsite equipment (If pH is < 5.5 or > 8.5 call Supervisor)', log_type_id: 2, input_type_id: 3, frecuency_id: 2, cycle: 1, responsible: 1 },
           { name: 'Check in/out of EQ tank for leaks or blocks', log_type_id: 3, input_type_id: 1, frecuency_id: 2, cycle: 1, responsible: 1 },
           { name: 'Check all pumps for leaks and noise', log_type_id: 3, input_type_id: 1, frecuency_id: 2, cycle: 1, responsible: 1 },
           { name: 'Pump maintenance (open, clean and replace seals)', log_type_id: 3, input_type_id: 4, frecuency_id: 4, cycle: 1, responsible: 1 },
           { name: 'Check solids level (notify supervisor when more 1 ft)', log_type_id: 3, input_type_id: 2, frecuency_id: 2, cycle: 1, responsible: 1 },
           { name: 'Revise irrigation (ensure adequate pressure and dispersal - notify BF Supervisor if any problem)', log_type_id: 4, input_type_id: 1, frecuency_id: 1, cycle: 1, responsible: 1 },
           { name: 'Check main irrigation pipe pressure (range 14-20)', log_type_id: 4, input_type_id: 5, frecuency_id: 2, cycle: 1, responsible: 1 },
           { name: 'Check flies and add flies control product if neccesary (X gallons/day)', log_type_id: 5, input_type_id: 6, frecuency_id: 1, cycle: 1, responsible: 1 },
           { name: 'Add bacteria to EQ tank (0.5 pounds)', log_type_id: 5, input_type_id: 1, frecuency_id: 2, cycle: 1, responsible: 1 },
           { name: 'Till puddles', log_type_id: 5, input_type_id: 6, frecuency_id: 1, cycle: 1, responsible: 1 },
           { name: 'Unclog sprinklers head', log_type_id: 5, input_type_id: 1, frecuency_id: 2, cycle: 1, responsible: 1 },
           { name: 'Till the complete bed (out of season - Sunday in preference)', log_type_id: 5, input_type_id: 7, frecuency_id: 3, cycle: 1, responsible: 1 },
           { name: 'Till the complete bed (in season - Sunday in preference)', log_type_id: 5, input_type_id: 7, frecuency_id: 3, cycle: 3, responsible: 1 },
           { name: 'Check worms density (1 sample every 5,000 sqf)', log_type_id: 5, input_type_id: 8, frecuency_id: 3, cycle: 1, responsible: 1 },
           { name: 'Clean effluent sieve box', log_type_id: 5, input_type_id: 1, frecuency_id: 2, cycle: 2, responsible: 1 },
           { name: 'Validate pH sensor record onsite with paper/equipment', log_type_id: 6, input_type_id: 3, frecuency_id: 2, cycle: 1, responsible: 1 },
           { name: 'Calibrate Sensors', log_type_id: 6, input_type_id: 1, frecuency_id: 3, cycle: 2, responsible: 1 },
           { name: 'Replace Sensor', log_type_id: 6, input_type_id: 1, frecuency_id: 4, cycle: 2, responsible: 1 },
           { name: 'Water lab sample BOD/TSS (1st week of the month)', log_type_id: 7, input_type_id: 4, frecuency_id: 3, cycle: 1, responsible: 1 },
           { name: 'Water internal sample COD', log_type_id: 7, input_type_id: 9, frecuency_id: 3, cycle: 2, responsible: 1 },
           { name: 'Smell treated water', log_type_id: 7, input_type_id: 10, frecuency_id: 2, cycle: 1, responsible: 1 },
           { name: 'Upload picture: BioFiltro USA -> Active Accounts -> Fetzer -> Logbook', log_type_id: 8, input_type_id: 1, frecuency_id: 2, cycle: 1, responsible: 1 }]
  tasks.each do |task|
    Task.create!(name: task[:name],
                 log_type_id: task[:log_type_id],
                 input_type_id: task[:input_type_id],
                 frecuency_id: task[:frecuency_id],
                 cycle: task[:cycle],
                 responsible: task[:responsible])
  end

  # Metric Types
  puts 'Adding Metric Types'
  MetricType.destroy_all
  metric_types = ['Imperial', 'Metric']
  metric_types.each do |metric_type|
    MetricType.create!(option: metric_type)
  end

  # Metrics
  puts 'Adding Metrics'
  Metric.destroy_all
  metric_types = MetricType.all
  metrics = { Imperial: { length: 'Feet', volume: 'Gallon', area: 'Square Foot', mass: 'Pounds', temperature: 'Fahrenheit' },
              Metric: { length: 'Meters', volume: 'Liter', area: 'Square Meter', mass: 'Kilogram', temperature: 'Celsius' } }
  metrics.each do |k, metric|
    metric_type = metric_types.find_by(option: k.to_s)
    metric_type.metrics.create!(length: metric[:length], volume: metric[:volume], area: metric[:area], mass: metric[:mass], temperature: metric[:temperature])
  end

  # Charts
  puts 'Adding Charts'
  Chart.destroy_all
  charts = [
    { name: 'Monthly Flow', shape: 'column' },
    { name: 'Daily Flow', shape: 'bar' },
    { name: 'Monthly Water Analysis Samples', shape: 'datatable' },
    { name: 'Treated Water', shape: 'datatable' },
    { name: '12 Month Water Analysis Data', shape: 'datatable' },
    { name: 'Lifetime Water Analysis Overview', shape: 'datatable' }
  ]
  charts.each do |chart|
    Chart.create!(name: chart[:name], shape: chart[:shape])
  end

  puts '----------- Seeds Added! -----------'
end
