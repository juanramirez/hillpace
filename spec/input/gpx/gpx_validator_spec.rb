require 'rspec'

DEFAULT_SCHEMA_FILE = 'spec/resources/schema/gpx.xsd'
DEFAULT_SCHEMA_URL = 'http://www.topografix.com/gpx/1/1/gpx.xsd'
VALID_GPX_FILE = 'spec/resources/gpx/GranadaHalfMarathon.gpx'
INVALID_GPX_FILE = 'spec/resources/gpx/GranadaHalfMarathonInvalid.gpx'

describe GpxValidator do
  it 'should validate a valid gpx document when using default schema' do
    expect_empty_result_for_valid_gpx_file GpxValidator.from_default_schema
  end

  it 'should validate a valid gpx document when using schema file' do
    validator = GpxValidator.from_file DEFAULT_SCHEMA_FILE
    expect_empty_result_for_valid_gpx_file validator
  end

  it 'should validate a valid gpx document when using url' do
    validator = GpxValidator.from_url DEFAULT_SCHEMA_URL
    expect_empty_result_for_valid_gpx_file validator
  end

  it 'should not validate an invalid gpx document' do
    validator = GpxValidator.from_default_schema
    validation_result = validator.validate File.open INVALID_GPX_FILE
    expect(validation_result).not_to be_empty
  end

  def expect_empty_result_for_valid_gpx_file(validator)
    validation_result = validator.validate File.open VALID_GPX_FILE
    expect(validation_result).to be_empty
  end
end