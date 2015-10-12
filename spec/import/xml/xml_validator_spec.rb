require 'rspec'

DEFAULT_GPX_SCHEMA_FILE = 'resources/schema/gpx.xsd'
DEFAULT_TCX_SCHEMA_FILE = 'resources/schema/tcx.xsd'
DEFAULT_GPX_SCHEMA_URL = 'http://www.topografix.com/gpx/1/1/gpx.xsd'
DEFAULT_TCX_SCHEMA_URL = 'http://www8.garmin.com/xmlschemas/TrainingCenterDatabasev2.xsd'
VALID_GPX_FILE = 'resources/gpx/GranadaHalfMarathon.gpx'
VALID_TCX_FILE = 'resources/tcx/2015-08-16_CarreraAtenasPlaya.tcx'
INVALID_GPX_FILE = 'resources/gpx/InvalidGranadaHalfMarathon.gpx'
INVALID_TCX_FILE = 'resources/tcx/InvalidCarreraAtenasPlaya.tcx'

describe XmlValidator do
  it 'should validate a valid gpx document when using default gpx schema' do
    expect_empty_result_for_valid_gpx_file XmlValidator.from_gpx_schema
  end

  it 'should validate a valid tcx document when using default tcx schema' do
    expect_empty_result_for_valid_tcx_file XmlValidator.from_tcx_schema
  end

  it 'should validate a valid gpx document when using gpx schema file' do
    validator = XmlValidator.from_file DEFAULT_GPX_SCHEMA_FILE
    expect_empty_result_for_valid_gpx_file validator
  end

  it 'should validate a valid tcx document when using tcx schema file' do
    validator = XmlValidator.from_file DEFAULT_TCX_SCHEMA_FILE
    expect_empty_result_for_valid_tcx_file validator
  end

  it 'should validate a valid gpx document when using gpx schema url' do
    validator = XmlValidator.from_url DEFAULT_GPX_SCHEMA_URL
    expect_empty_result_for_valid_gpx_file validator
  end

  it 'should validate a valid tcx document when using tcx schema url' do
    validator = XmlValidator.from_url DEFAULT_TCX_SCHEMA_URL
    expect_empty_result_for_valid_tcx_file validator
  end

  it 'should not validate an invalid gpx document' do
    validator = XmlValidator.from_gpx_schema
    validation_result = validator.validate File.open INVALID_GPX_FILE
    expect(validation_result).not_to be_empty
  end

  it 'should not validate an invalid tcx document' do
    validator = XmlValidator.from_tcx_schema
    validation_result = validator.validate File.open INVALID_TCX_FILE
    expect(validation_result).not_to be_empty
  end

  def expect_empty_result_for_valid_gpx_file(validator)
    validation_result = validator.validate File.open VALID_GPX_FILE
    expect(validation_result).to be_empty
  end

  def expect_empty_result_for_valid_tcx_file(validator)
    validation_result = validator.validate File.open VALID_TCX_FILE
    expect(validation_result).to be_empty
  end
end