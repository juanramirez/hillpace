require 'nokogiri'
require 'open-uri'

module Hillpace
  module Import
    module Xml
      # Validator for XML files
      class XmlValidator
        DEFAULT_GPX_SCHEMA_URL = 'http://www.topografix.com/gpx/1/1/gpx.xsd'
        DEFAULT_TCX_SCHEMA_URL = 'http://www8.garmin.com/xmlschemas/TrainingCenterDatabasev2.xsd'

        attr_reader :schema

        # Initializes a XmlValidator object.
        # @param schema_content [string] The content of an XML schema file.
        def initialize(schema_content)
          @schema = Nokogiri::XML::Schema schema_content
        end

        # Creates a new XmlValidator object from an XML schema file path.
        # @param schema_path [String] The path of the XML schema file to use.
        # @return [XmlValidator]
        def self.from_file(schema_path)
          new File.open(schema_path)
        end

        # Creates a new XmlValidator object from an XML schema file URL.
        # @param schema_url [String] The URL of the XML schema file to use.
        # @return [XmlValidator]
        def self.from_url(schema_url)
          new open(schema_url)
        end

        # Creates a new XmlValidator object using the default GPX schema.
        #   (see http://www.topografix.com/gpx.asp)
        # @return [XmlValidator]
        def self.from_gpx_schema
          new open(DEFAULT_GPX_SCHEMA_URL)
        end

        # Creates a new XmlValidator object using the default TCX schema.
        #   (see https://en.wikipedia.org/wiki/Training_Center_XML)
        # @return [XmlValidator]
        def self.from_tcx_schema
          new open(DEFAULT_TCX_SCHEMA_URL)
        end

        # Validates an XML file content and return errors found.
        # @return [Array<Nokogiri::XML::SyntaxError>]
        def validate(xml_content)
          document = Nokogiri::XML xml_content
          schema.validate document
        end

        private_class_method :new
      end
    end
  end
end
