module Utils
  class StaticFetcher
    attr_reader :hash

    def initialize(hash)
      @hash = hash
    end

    def [](key, **dynamic_values)
      text = hash.dig(*key.split('.'))

      text = format(text.to_s, **dynamic_values) if text

      text
    end
  end
end
