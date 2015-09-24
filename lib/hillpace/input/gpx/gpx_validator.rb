require 'nokogiri'
require 'open-uri'

module Hillpace
  module Input
    module Gpx
      # Validator for GPX files (see http://www.topografix.com/gpx.asp).
      class GpxValidator
        DEFAULT_SCHEMA_URL = 'http://www.topografix.com/gpx/1/1/gpx.xsd'

        attr_reader :schema

        # Initializes a GpxValidator object.
        # @param schema_content [string] The content of a GPX schema file.
        def initialize(schema_content)
          @schema = Nokogiri::XML::Schema schema_content
        end

        # Creates a new GpxValidator object from a GPX schema file path.
        # @param schema_path [string] The path of the GPX schema file to use.
        # @return [GpxParser]
        def self.from_file(schema_path)
          new File.open(schema_path)
        end

        # Creates a new GpxValidator object from a GPX schema file URL.
        # @param schema_path [string] The URL of the GPX schema file to use.
        # @return [GpxParser]
        def self.from_url(schema_url)
          new open(schema_url)
        end

        # Creates a new GpxValidator object using the default GPX schema.
        # @return [GpxParser]
        def self.from_default_schema
          new open(DEFAULT_SCHEMA_URL)
        end

        # Validates a GPX file content and return errors found.
        # @return [Array<Nokogiri::XML::SyntaxError>]
        def validate(gpx_content)
          document = Nokogiri::XML gpx_content
          schema.validate document
        end

        private_class_method :new
      end
    end
  end
end
