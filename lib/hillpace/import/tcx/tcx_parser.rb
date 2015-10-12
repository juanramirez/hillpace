module Hillpace
  module Import
    module Tcx
      # Parser for TCX files (see https://en.wikipedia.org/wiki/Training_Center_XML).
      class TcxParser
        attr_reader :document

        # Initializes a TcxParser object.
        # @param tcx_content [string] The content of a TCX file.
        def initialize(tcx_content)
          @document = Nokogiri::XML tcx_content
          @kalman_filter = KalmanFilter.new
          @srtm = GeoElevation::Srtm.new
        end

        # Creates a new TcxParser object from a TCX file path.
        # @param tcx_path [string] The path of the file to be parsed.
        # @return [TcxParser]
        def self.from_file(tcx_path)
          new File.open tcx_path
        end

        # Creates a new TcxParser object from a TCX file URL.
        # @param tcx_url [string] The URL of the file to be parsed.
        # @return [TcxParser]
        def self.from_url(tcx_url)
          new open tcx_url
        end

        # Parses a TCX document.
        # Looks for route nodes inside the document and parses them.
        # @return [Route]
        def parse
          routes = Array.new
          document.search('Activity').each do |route_node|
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
          route_node.search('Lap').each_with_index do |segment_node, index|
            segment = parse_segment(segment_node)
            # Start new segment with last known point, as segments are not consecutive in TCX.
            segment.track_points.unshift(segments.last.track_points.last.clone) unless index == 0
            segments << segment
          end
          Route.new(segments)
        end

        # Parses a segment node.
        # Looks for track point nodes inside the segment node and parses them.
        # @param segment_node [Nokogiri::XML::Node] The XML node corresponding to the segment.
        # @return [Segment]
        def parse_segment(segment_node)
          @kalman_filter.reset
          track_points = Array.new

          segment_node.search('Trackpoint').each do |track_point_node|
            track_points << parse_track_point(track_point_node)
          end

          Segment.new track_points
        end

        # Parses a track point node.
        # Looks for the attributes of a track node (longitude, latitude and elevation) and creates a TrackPoint object
        # accordingly.
        #
        # Note: These attributes don't need to be exactly the ones the TCX provides.
        # For longitude and latitude, a Kalman filter is applied if the time is also provided.
        # Also, the elevation is not got from the TCX, but deduced from longitude and latitude.
        #
        # @param track_point_node [Nokogiri::XML::Node] The XML node corresponding to the track point.
        # @return [TrackPoint]
        def parse_track_point(track_point_node)
          longitude = track_point_node.at('Position').at('LongitudeDegrees').content.to_f
          latitude = track_point_node.at('Position').at('LatitudeDegrees').content.to_f

          # Yes, we could do
          # elevation = (track_point_node.at('ele').content).to_f
          # but elevation from GPX not reliable in some cases.
          # Google Maps API is expensive, so we get data from SRTM database
          # (see https://en.wikipedia.org/wiki/Shuttle_Radar_Topography_Mission)
          elevation = @srtm.get_elevation(latitude, longitude)

          track_point = TrackPoint.new longitude, latitude, elevation
          track_point.time = Time.parse track_point_node.at('Time').content
          @kalman_filter.apply track_point
        end

        private_class_method :new
      end
    end
  end
end
