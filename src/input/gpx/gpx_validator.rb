require 'rubygems'
require 'nokogiri'
require 'open-uri'

class GpxValidator
  DEFAULT_SCHEMA_URL = 'http://www.topografix.com/gpx/1/1/gpx.xsd'

  attr_reader :schema

  def initialize(schema_content)
    @schema = Nokogiri::XML::Schema schema_content
  end

  def self.from_file(schema_path)
    new File.open(schema_path)
  end

  def self.from_url(schema_url)
    new open(schema_url)
  end

  def self.from_default_schema
    new open(DEFAULT_SCHEMA_URL)
  end

  def validate(gpx_content)
    document = Nokogiri::XML gpx_content
    schema.validate document
  end

  private_class_method :new
end