module Logbook
  module Helpers
    class DataGenerator
      include Enumerable

      DATA = YAML.load_file (Path.dir/'data.yml').to_s

      def initialize(fields, size)
        @fields = fields
        @size   = size
      end

      def each
        @size.times{|i| yield generate(i) }
      end

      private

        def generate(id)
          h = {:id => id}
          @fields.each do |field|
            h[field] = \
            case values = DATA[field.to_s]
            when Array    then values.sample
            when Range    then values.to_a.sample
            when NilClass then rand(1000)
            else
              raise ArgumentError, "Unexpected field candidates: #{values.inspect}"
            end
          end
          h
        end

    end # DataGenerator
  end # module Helpers
end # module Logbook
