module Generator
  class Task
    def self.defaults(locale)
      tasks = {
        en: [
          { name: 'Maintenance of the float pump', comment: '', responsible: '0', season: 'no', frecuency: 'every_x_months', cycle: '{"months":[{"month":"12"},{"month":"6"}],"days":[{"day":"mon","week":"1","num":"1"}]}', input_type: 'number', data_type: 'hours' },
          { name: 'Check correct operation', comment: '1 wash cycle', responsible: '-1', season: 'no', frecuency: 'weekly', cycle: '{"days":[{"day":"mon","week":1,"num":1},{"day":"fri","week":1,"num":5}],"months":[]}', input_type: 'checkbox', data_type: 'other' }
        ],
        es: [
          { name: 'Aspirar sólidos de la línea', comment: 'Disposse in DRY AREA', responsible: '-1', season: 'no', frecuency: 'daily', cycle: '{"days":[],"months":[]}', input_type: 'number', data_type: 'trucks' },
          { name: 'Arar la cama completa', comment: '', responsible: '0', season: 'in_season', frecuency: 'every_2_weeks', cycle: '{"days":[{"day":"mon","week":1,"num":1}],"months":[]}', input_type: 'yes/no', data_type: 'other' }
        ]
      }

      tasks[locale.to_sym]
    end
  end
end
