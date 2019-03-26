# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

if Rails.env == 'development'

  puts '----------- Adding Seeds! -----------'

  # Users
  puts 'Adding Users'
  User.destroy_all
  roles = [:no_role, :admin, :client, :operator, :operations_manager, :viewer]
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
    u = User.create!(name: user[:name], lastname: user[:lastname], email: user[:email], password: user[:password], role: user[:role])
    puts "- #{u.full_name} was added"
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
  metrics_final = {}
  metrics = { Imperial: { length: 'Feet', volume: 'Gallon', area: 'Square Foot', mass: 'Pounds', temperature: 'Fahrenheit' },
              Metric: { length: 'Meters', volume: 'Liter', area: 'Square Meter', mass: 'Kilogram', temperature: 'Celsius' } }
  metrics.each do |k, metric|
    metric_type = metric_types.find_by(option: k.to_s)
    metrics_final[k.to_sym] = metric_type.metrics.create!(length: metric[:length], volume: metric[:volume], area: metric[:area], mass: metric[:mass], temperature: metric[:temperature])
  end

  # Countries
  puts 'Adding Countries'
  Country.destroy_all
  countries = [{ name: 'Australia', metric: metrics_final[:Metric] },
               { name: 'Chile', metric: metrics_final[:Metric] },
               { name: 'United States', metric: metrics_final[:Imperial] },
               { name: 'New Zealand', metric: metrics_final[:Metric] },
               { name: 'Peru', metric: metrics_final[:Metric] }]
  countries.each do |country|
    Country.create!(name: country[:name], metric: country[:metric])
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

  # Add Default data
  puts 'Adding Fake Data'
  flow_history = {
    "_2016": {
      "_08": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 596, 486],
      "_09": [0, 612, 759, 0, 471, 675, 1132, 977, 925, 1008, 860, 960, 250, 0, 269, 278, 0, 0, 559, 1045, 738, 669, 826, 151, 0, 606, 1016, 942, 680, 1043],
      "_10": [996, 667, 590, 837, 1053, 1040, 1022, 734, 612, 1040, 795, 978, 1005, 118, 1021, 993, 406, 581, 680, 0, 473, 757, 984, 849, 677, 517, 967, 795, 393, 619, 551],
      "_11": [1144, 401, 0, 213, 483, 1, 167, 125, 382, 498, 668, 249, 0, 1, 188, 2, 153, 105, 706, 3, 358, 437, 885, 314, 3, 149, 23, 206, 332, 278],
      "_12": [577, 308, 2, 1, 208, 1, 1, 306, 1, 628, 1, 400, 315, 4, 1117, 228, 1, 4, 2, 449, 2, 11, 239, 1, 1, 2, 1, 68, 1, 1, 1]
    },
    "_2017": {
      "_01": [2, 1, 578, 1344, 933, 188, 879, 1178, 901, 1089, 1047, 1051, 1136, 263, 1, 649, 1216, 1112, 1271, 1267, 536, 1087, 266, 206, 1, 0, 609, 0, 0, 718, 686],
      "_02": [745, 1021, 1174, 516, 258, 1139, 966, 1034, 1060, 1057, 145, 1, 79, 281, 223, 203, 220, 209, 71, 459, 789, 360, 700, 87, 315, 2, 78, 213],
      "_03": [1, 240, 446, 645, 2, 835, 1006, 0, 241, 168, 533, 1, 639, 1753, 1034, 778, 155, 558, 1, 144, 698, 252, 488, 438, 1, 82, 244, 424, 1, 581, 228],
      "_04": [1, 0, 115, 269, 503, 987, 1652, 1008, 2, 0, 73, 928, 679, 482, 1, 68, 518, 1323, 641, 638, 875, 0, 62, 235, 421, 381, 347, 1, 1, 0],
      "_05": [0, 55, 0, 2, 1, 1, 1, 0, 0, 652, 0, 1, 1, 0, 2, 299, 119, 714, 1, 0, 0, 1751, 78, 143, 1, 1, 1, 0, 0, 1131, 1655],
      "_06": [1608, 1710, 1858, 2083, 1769, 1880, 1160, 45, 2, 1, 1, 1534, 1675, 1196, 601, 576, 0, 1, 1191, 618, 227, 137, 1150, 0, 0, 823, 829, 1517, 840, 1],
      "_07": [0, 0, 0, 0, 1, 1139, 580, 1, 0, 791, 871, 657, 1205, 763, 0, 0, 2937, 506, 719, 1455, 727, 0, 0, 364, 696, 550, 877, 1, 0, 0, 923],
      "_08": [1391, 1, 115, 1, 0, 0, 1, 245, 129, 1, 893, 0, 0, 1354, 1844, 1130, 824, 240, 1, 1, 793, 879, 485, 1, 445, 0, 0, 156, 0, 1441, 607],
      "_09": [842, 1, 0, 1, 1848, 380, 673, 1387, 659, 111, 93, 2445, 1144, 416, 303, 1050, 286, 470, 456, 1548, 1145, 1894, 156, 490, 1443, 1414, 1934, 986, 1142, 664],
      "_10": [1207, 1597, 1837, 1405, 1434, 1090, 1009, 1557, 723, 1402, 2158, 1364, 1623, 1201, 1941, 1448, 582, 2, 0, 1, 0, 0, 0, 1780, 2832, 1613, 1496, 1318, 1750, 1370, 327],
      "_11": [1101, 856, 1134, 1513, 1308, 1003, 1302, 894, 1327, 1067, 0, 142, 909, 1535, 1291, 5684, 293, 7, 0, 158, 161, 464, 0, 0, 0, 0, 4113, 1394, 1828, 683],
      "_12": [364, 260, 0, 0, 0, 0, 0, 129, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 422, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    },
    "_2018": {
      "_01": [0, 139, 230, 6, 397, 0, 1, 1732, 1032, 300, 349, 739, 0, 0.4625, 893.725, 881.125, 800, 734, 157, 139, 0, 134, 681, 729, 1065, 0, 0, 0, 0, 482, 730],
      "_02": [352, 150, 1, 0.25, 245.7125, 767.5, 801, 699, 460, 0, 0, 1311, 840, 680, 316, 638, 0, 0, 0, 837, 287, 413, 0, 0, 0, 1057, 1238, 680],
      "_03": [1032, 1137, 0, 122, 325, 1276, 172, 1080, 536, 0, 0, 250.125, 479, 304, 360, 811, 0, 0, 1721, 1412, 740, 1212, 417, 0, 0, 1978, 348, 0, 0, 114, 0],
      "_04": [0, 239, 168, 189, 147, 433, 302, 0, 434, 0, 0, 187, 0, 0, 0, 637, 466, 0, 435, 0, 1, 0, 0, 1, 0, 130, 167, 0, 0.075, 147],
      "_05": [1, 0, 124, 1, 0, 0, 0, 119, 0, 0, 0, 0.075, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 178, 0, 0, 0, 0, 173, 527, 173],
      "_06": [0, 0, 0, 1, 0, 114, 136, 137, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 124, 0, 0],
      "_07": [0, 0, 0, 0, 0.2125, 0, 0.2125, 0, 0, 0, 0, 0, 126.8, 0.0625, 0, 0, 0, 188.9, 0, 0, 0, 0, 0, 0, 381.9125, 353.55, 533.675, 0, 0, 460.675, 411.3],
      "_08": [598, 575, 0, 0, 0, 655, 170, 910, 915, 519, 0, 0, 1269, 314, 0, 0, 0, 0, 0, 246, 0, 143, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      "_09": [0, 0, 0, 0.1, 0.0125, 318.0125, 409.225, 0, 0, 368.3875, 306.7375, 222.6625, 0.4625, 119.575, 0.25, 0, 1078.725, 1066.675, 737.375, 722.2375, 419.1, 1159.025, 846.975, 880.275, 2148.175, 812.55, 798.6, 1183.875, 1625.45, 1276.325],
      "_10": [453, 1977, 1694, 620, 1144, 1923, 1151, 1318, 1141, 1212, 690, 945, 995, 620, 1963, 1168, 1897, 1099, 1056, 1658, 1217, 556, 1090, 1319, 1129, 641, 943, 1508, 969, 85, 4],
      "_11": [4, 5, 5, 7, 9, 11, 9, 8, 1261, 1820, 734, 968, 339, 1132, 968, 1, 149, 1139, 452, 418, 1198, 171, 211, 987, 183, 785, 455, 615, 1591, 1551],
      "_12": [132, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 5, 0, 129, 128, 3, 0, 1467, 530, 0, 0, 0, 121, 7, 1, 0, 0, 0, 0, 1]
    },
    "_2019": {
      "_01": [1, 129, 0, 0, 0, 961, 264, 548, 252, 165, 123, 0, 0, 0, 255.775, 1186.625, 1586, 316, 0, 132, 681, 811, 494, 599, 162, 0, 0, 634, 738, 718, 650],
      "_02": [639, 1245, 776, 532, 731, 984, 1411, 1313, 126, 960, 455, 995, 1199, 609, 511, 1226, 382, 614, 380, 634, 1263, 653, 95, 494, 1443, 130, 1333, 153],
      "_03": [817, 1107, 1148, 1456, 1457, 533, 615, 84, 1235, 704, 376, 1063, 158, 18, 1453, 1211, 293, 537, 174, 1211, 429, 9, 152, 371, 1437, 928, 447, 341, 606, 1445, 290],
      "_04": [743, 646, 1346, 1321, 263, 782, 1006, 1320, 1112, 1184, 321, 432, 843, 912, 682, 1251, 1091, 128, 32, 836, 960, 656, 131, 486, 722, 393, 926, 1004, 865, 499],
      "_05": [164, 58, 1214, 881, 568, 261, 670, 428, 583, 254, 470, 754, 675, 824, 316, 1168, 281, 1288, 6, 1105, 325, 687, 943, 1472, 107, 307, 118, 1339, 627, 867, 582]
    }
  }

  plant_id = Plant.first.id
  flow_history.each do |data_key, data_value|
    year = data_key.to_s.delete!('_').to_i
    data_value.each do |hash_key, hash_value|
      month = hash_key.to_s.delete!('_').to_i
      fr = FlowReport.create!(plant_id: plant_id, date: Date.new(year, month, 1))
      hash_value.each_with_index do |value_key, i|
        fr.flows.create!(plant_id: plant_id, value: value_key, date: Date.new(year, month, (i + 1)))
      end
    end
  end

  Sampling.destroy_all
  SamplingList.destroy_all
  plant = Plant.first
  accesses = Access.all
  standards_arr = plant.standards.select(&:enabled)

  accesses.each do |access|
    (2016..2019).each do |year|
      (1..12).each do |month|
        sampling_list = SamplingList.create!(plant: plant,
                                             access: access,
                                             frecuency_id: 3,
                                             per_cycle: 1,
                                             created_at: "#{year}-#{month}-1 08:00:00",
                                             updated_at: "#{year}-#{month}-1 08:00:00")
        total_days_month = Date.new(year, month, 1).end_of_month.day
        (1..total_days_month).each do |day|
          standards_arr.each do |st|
            sampling_list.samplings.create!(standard: st,
                                            value_in: Random.rand(0...5400),
                                            value_out: Random.rand(0...100),
                                            created_at: "#{year}-#{month}-#{day} 08:00:00",
                                            updated_at: "#{year}-#{month}-#{day} 08:00:00")
          end
        end
      end
    end
  end

  puts 'End Fake Data'

  puts '----------- Seeds Added! -----------'
end
