module Generator
  class Task
    def self.defaults(locale)
      tasks = {
        en: JSON.parse(File.read(Dir[Rails.root.join('config', 'default', 'en.tasks.json')].first)),
        es: JSON.parse(File.read(Dir[Rails.root.join('config', 'default', 'es.tasks.json')].first))
      }

      tasks[locale.to_sym]
    end
  end
end
