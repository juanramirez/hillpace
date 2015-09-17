require_relative '../track_point'

module Hillpace
  module Input
    # See https://en.wikipedia.org/wiki/Kalman_filter
    # Based on this implementation by Stochastically: http://stackoverflow.com/a/15657798/1147175
    class KalmanFilter
      ACCURACY = 3.0

      def initialize
        @variance = -1.0
      end

      def filter(track_point, time)
        if @variance < 0
          @track_point = track_point
          @time = time
          @variance = ACCURACY ** 2
        else
          time_delta = time - @time
          if time_delta > 0
            @variance += time_delta * (get_speed(track_point, time_delta) ** 2)
            @time = time
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

      def get_speed(track_point, time_delta)
        distance_delta = @track_point.distance_meters_to track_point
        distance_delta / time_delta
      end
    end
  end
end
