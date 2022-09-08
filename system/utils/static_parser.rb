module Utils
  class StaticParser
    def self.call(file_path)
      erb_result = ERB.new(File.read(file_path)).result

      YAML.safe_load(erb_result, aliases: true)
    end
  end
end
