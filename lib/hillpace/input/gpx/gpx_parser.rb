require 'nokogiri'
require 'geoelevation'

module Hillpace
  module Input
    module Gpx
      class GpxParser
        attr_reader :document

        def initialize(gpx_content)
          @document = Nokogiri::XML gpx_content
          @kalman_filter = KalmanFilter.new
          @srtm = GeoElevation::Srtm.new
        end

        def self.from_file(gpx_path)
          new File.open gpx_path
        end

        def self.from_url(gpx_url)
          new open gpx_url
        end

        def parse
          routes = Array.new
          document.search('trk').each do |route_node|
            routes << parse_route(route_node)
          end
          routes
        end

        private

        def parse_route(route_node)
          segments = Array.new
          route_node.search('trkseg').each do |segment_node|
            segments << parse_segment(segment_node)
          end
          Route.new(segments)
        end

        def parse_segment(segment_node)
          @kalman_filter.reset
          track_points = Array.new

          segment_node.search('trkpt').each do |track_point_node|
            track_points << parse_track_point(track_point_node)
          end

          Segment.new track_points
        end

        def parse_track_point(track_point_node)
          longitude = (track_point_node ['lon']).to_f
          latitude = (track_point_node ['lat']).to_f

          # Yes, we could do
          # elevation = (track_point_node.at('ele').content).to_f
          # but elevation from GPX not reliable in some cases.
          # Google Maps API is expensive, so we get data from SRTM database
          # (see https://en.wikipedia.org/wiki/Shuttle_Radar_Topography_Mission)
          elevation = @srtm.get_elevation(latitude, longitude)

          track_point = TrackPoint.new longitude, latitude, elevation

          unless track_point_node.search('time').empty?
            time = Time.parse track_point_node.at('time').content
            track_point = @kalman_filter.filter track_point, time
          end

          track_point
        end

        private_class_method :new
      end
    end
  end
end
