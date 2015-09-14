# HillPace

HillPace is a library for planning running races. It can take the GPX of a route and a reference pace (the pace you would go on a flat course of the same distance) and generate planned paces by segments, based on the incline of each segment.

### Status

This is a work in progress, but the core of the code is functional.

#### Installation

Go to the root directory of the package and run:
```bundle install --path vendor/bundle --binstubs```

#### Dependencies

* [Nokogiri](http://www.nokogiri.org/)
* [Geokit](https://github.com/geokit/geokit)
* [geoelevation](https://github.com/tkrajina/geoelevations)

**Important**: Notice that [geoelevation](https://github.com/tkrajina/geoelevations) needs the whole [SRTM database](https://en.wikipedia.org/wiki/Shuttle_Radar_Topography_Mission) to work and it will download it automatically on `~/.elevations.rb` on the first run (this can be hundreds of MB, but it is only necessary once).

#### Code organization

* [src/route](src/route): contains the core classes of the package, which manage routes, segments and track points
* [src/input](src/input) contains classes for importing routes (at the moment, just GPX)
* [src/pace](src/pace) contains the classes for calculating and converting paces
* [specs](specs) contains the specs :)
* [example.rb](example.rb) contains the example (see the [Example](README.md####Example) section)

#### Tests

You can run the tests typing:
```bundle exec rake```

#### Example

An example can be found in [example.rb](example.rb), and it can be run this way:
```bundle exec rake example```

We use a GPX exported from [this Garmin Connect activity](https://connect.garmin.com/modern/activity/770166012) which maps the [2015 Granada Half Marathon](http://www.granada.es/inet/MediaMaraton.nsf/xnotweb/3F5884FDDFD1A9EDC1257E43004048B9?open).

The example is assumed to get that GPX and an input pace of 4:00 minutes per km, which is the theoretical pace for a flat course, and gives the following output:

```
Example: Granada Half Marathon (from flat surface pace: 4:00 min/km)
Km 1 (incline 1.85%): 04:21 min/km
Km 2 (incline 0.65%): 04:07 min/km
Km 3 (incline -2.7%): 03:33 min/km
Km 4 (incline 0.0%): 04:00 min/km
Km 5 (incline -1.6%): 03:43 min/km
Km 6 (incline 0.53%): 04:05 min/km
Km 7 (incline -1.03%): 03:49 min/km
Km 8 (incline 0.2%): 04:02 min/km
Km 9 (incline -0.4%): 03:55 min/km
Km 10 (incline 2.3%): 04:27 min/km
Km 11 (incline -0.47%): 03:55 min/km
Km 12 (incline -0.31%): 03:56 min/km
Km 13 (incline 1.99%): 04:23 min/km
Km 14 (incline -0.5%): 03:54 min/km
Km 15 (incline 1.47%): 04:16 min/km
Km 16 (incline 0.68%): 04:07 min/km
Km 17 (incline -0.95%): 03:50 min/km
Km 18 (incline 0.5%): 04:05 min/km
Km 19 (incline -1.6%): 03:43 min/km
Km 20 (incline -0.49%): 03:54 min/km
Km 21 (incline 0.19%): 04:02 min/km
Km 22 (incline -0.43%): 03:55 min/km
```
