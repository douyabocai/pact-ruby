require 'uri'

module Pact
  module Consumption
    class MockProducer

      attr_reader :uri, :pactfile_path

      def initialize(name, pactfile_path)
        @name = name
        @pactfile_path = pactfile_path
        @interactions = []
      end

      def at(url)
        @uri = URI(url)
        self
      end

      def upon_receiving(request)
        Interaction.new(self, request).tap { |int| @interactions << int }
      end

      def update_pactfile
        File.open(pactfile_path, 'w') do |f|
          f.write JSON.dump(@interactions.map(&:to_json))
        end
      end

    end
  end
end
