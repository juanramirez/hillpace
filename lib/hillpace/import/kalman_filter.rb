module Hillpace
  module Import
    # See https://en.wikipedia.org/wiki/Kalman_filter
    # Based on this implementation by Stochastically: http://stackoverflow.com/a/15657798/1147175
    class KalmanFilter
      ACCURACY = 3.0

      # Initializes a KalmanFilter object.
      def initialize
        reset
      end

      # Resets a KalmanFilter object.
      def reset
        @variance = -1.0
      end

      # Applies the filter to a track point
      # @param track_point [TrackPoint] The track point which will be filtered.
      # @return [TrackPoint]
      def apply(track_point)
        if track_point.time.nil?
          return track_point
        elsif @variance < 0
          @track_point = track_point
          @variance = ACCURACY ** 2
        else
          time_delta = track_point.time - @track_point.time
          if time_delta > 0
            @variance += time_delta * (get_speed(@track_point, track_point, time_delta) ** 2)
            @track_point.time = track_point.time
          end

          k = @variance / (@variance + ACCURACY ** 2)
          @track_point.longitude += k * (track_point.longitude - @track_point.longitude)
          @track_point.latitude += k * (track_point.latitude - @track_point.latitude)
          @track_point.elevation += k * (track_point.elevation - @track_point.elevation)

          @variance = (1.0 - k) * @variance
        end

        @track_point.clone
      end

      private

      # Gets the speed from two trackpoints with their time difference.
      # @param previous_track_point [TrackPoint] The previous track point.
      # @param track_point [TrackPoint] The current track point
      # @param time_delta [Number] The time difference between the track points.
      # @return [Number]
      def get_speed(previous_track_point, track_point, time_delta)
        distance_delta = previous_track_point.distance_meters_to track_point
        distance_delta / time_delta
      end
    end
  end
end
