require 'nokogiri'
require 'geoelevation'

module Hillpace
  module Input
    module Gpx
      # Parser for GPX files (see http://www.topografix.com/gpx.asp).
      class GpxParser
        attr_reader :document

        # Initializes a GpxParser object.
        # @param gpx_content [string] The content of a GPX file.
        def initialize(gpx_content)
          @document = Nokogiri::XML gpx_content
          @srtm = GeoElevation::Srtm.new
        end

        # Creates a new GpxParser object from a GPX file path.
        # @param gpx_path [string] The path of the file to be parsed.
        # @return [GpxParser]
        def self.from_file(gpx_path)
          new File.open gpx_path
        end

        # Creates a new GpxParser object from a GPX file URL.
        # @param gpx_url [string] The URL of the file to be parsed.
        # @return [GpxParser]
        def self.from_url(gpx_url)
          new open gpx_url
        end

        # Parses a GPX document.
        # Looks for route nodes inside the document and parses them.
        # @return [Route]
        def parse
          routes = Array.new
          document.search('trk').each do |route_node|
            routes << parse_route(route_node)
          end
          routes
        end

        private

        # Parses a route node.
        # Looks for segment nodes inside the route node and parses them.
        # @param route_node [Nokogiri::XML::Node] The XML node corresponding to the route.
        # @return [Route]
        def parse_route(route_node)
          segments = Array.new
          route_node.search('trkseg').each do |segment_node|
            segments << parse_segment(segment_node)
          end
          Route.new(segments)
        end

        # Parses a segment node.
        # Looks for track point nodes inside the segment node and parses them.
        # @param segment_node [Nokogiri::XML::Node] The XML node corresponding to the segment.
        # @return [Segment]
        def parse_segment(segment_node)
          kalman_filter = KalmanFilter.new
          track_points = Array.new

          segment_node.search('trkpt').each do |track_point_node|
            track_point = parse_track_point track_point_node
            time = parse_track_point_time track_point_node
            track_point = kalman_filter.filter track_point, time unless time.nil?
            track_points << track_point
          end

          Segment.new track_points
        end

        # Parses a track point node.
        # Looks for the attributes of a track node (longitude, latitude and elevation) and creates a TrackPoint object
        # accordingly.
        #
        # Note: These attributes don't need to be exactly the ones the GPX provides.
        # For longitude and latitude, a Kalman filter is applied if the time is also provided.
        # Also, the elevation is not got from the GPX, but deduced from longitude and latitude.
        #
        # @param track_point_node [Nokogiri::XML::Node] The XML node corresponding to the track point.
        # @return [TrackPoint]
        def parse_track_point(track_point_node)
          longitude = (track_point_node ['lon']).to_f
          latitude = (track_point_node ['lat']).to_f

          # Yes, we could do
          # elevation = (track_point_node.at('ele').content).to_f
          # but elevation from GPX not reliable in some cases.
          # Google Maps API is expensive, so we get data from SRTM database
          # (see https://en.wikipedia.org/wiki/Shuttle_Radar_Topography_Mission)
          elevation = @srtm.get_elevation(latitude, longitude)

          TrackPoint.new longitude, latitude, elevation
        end

        def parse_track_point_time(track_point_node)
          unless track_point_node.search('time').empty?
            Time.parse track_point_node.at('time').content
          else
            nil
          end
        end

        private_class_method :new
      end
    end
  end
end
