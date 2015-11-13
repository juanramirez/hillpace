# HillPace

HillPace is a library for planning running races. It can take the GPX or TCX of a route and a reference pace (the pace you would go on ideal conditions) and generate planned paces by segments, based on configurable external factors like the climb grade of each segment.

_Note: This is a work in progress, but the core of the code is functional._

[![Code Climate](https://codeclimate.com/github/juanramirez/hillpace/badges/gpa.svg)](https://codeclimate.com/github/juanramirez/hillpace)

## Installation

Go to the root directory of the package and run:
```
bundle install
```

## Use

Add this to your gemfile:
```
gem 'hillpace'
```
And take a look at the [Example](README.md####example) section.

#### Main dependencies

* [Nokogiri](http://www.nokogiri.org/)
* [Geokit](https://github.com/geokit/geokit)
* [geoelevation](https://github.com/tkrajina/geoelevations)

**Important**: Notice that [geoelevation](https://github.com/tkrajina/geoelevations) needs the whole [SRTM database](https://en.wikipedia.org/wiki/Shuttle_Radar_Topography_Mission) to work and it will download it automatically on `~/.elevations.rb` on the first run (this can be hundreds of MB, but it is only necessary once).

#### Code organization

* [lib/hillpace](lib/hillpace): contains the core classes of the package, which manage paces, routes, segments and track points
* [lib/hillpace/input](lib/hillpace/input) contains classes for importing routes (at the moment, just GPX)
* [lib/hillpace/pace_adjuster](lib/hillpace/pace_adjuster) contains the pace adjuster and its strategies
* [lib/hillpace/race_planner](lib/hillpace/race_planner) contains a convenient race planner to, based on a strategy, just obtain the data for a combination of route, split distances and reference pace.
* [specs](specs) contains the specs :)
* [examples/race_planning.rb](example/race_planning.rb) contains an example of use (see the [Example](README.md####example) section)

#### Tests

All classes in the codebase are tested, and you can run those tests by typing:
```
bundle exec rake tests
```

#### Example

An example can be found in [examples/race_planning.rb](race_planning.rb), and it can be run this way:
```
bundle exec rake example
```

We use a GPX exported from [this Garmin Connect activity](https://connect.garmin.com/modern/activity/770166012) which maps the [2015 Granada Half Marathon](http://www.granada.es/inet/MediaMaraton.nsf/xnotweb/3F5884FDDFD1A9EDC1257E43004048B9?open).

The example is assumed to get that GPX and an input pace of 4:08 minutes per km, which is my theoretical pace for a flat course, and gives the following output:

```
Example: Granada Half Marathon (from flat surface pace: 4:08 min/km)
0.0Km - 1.0Km (incline 1.85%): 04:30 min/km
1.0Km - 2.0Km (incline 0.65%): 04:15 min/km
2.0Km - 3.0Km (incline -2.7%): 03:41 min/km
3.0Km - 4.0Km (incline 0.0%): 04:08 min/km
4.0Km - 5.0Km (incline -1.6%): 03:51 min/km
5.0Km - 6.0Km (incline 0.53%): 04:14 min/km
6.0Km - 7.0Km (incline -1.03%): 03:57 min/km
7.0Km - 8.0Km (incline 0.2%): 04:10 min/km
8.0Km - 9.0Km (incline -0.4%): 04:03 min/km
9.0Km - 10.0Km (incline 2.3%): 04:36 min/km
10.0Km - 11.0Km (incline -0.47%): 04:02 min/km
11.0Km - 12.0Km (incline -0.31%): 04:04 min/km
12.0Km - 13.0Km (incline 1.99%): 04:32 min/km
13.0Km - 14.0Km (incline -0.5%): 04:02 min/km
14.0Km - 15.0Km (incline 1.47%): 04:25 min/km
15.0Km - 16.0Km (incline 0.68%): 04:15 min/km
16.0Km - 17.0Km (incline -0.95%): 03:57 min/km
17.0Km - 18.0Km (incline 0.5%): 04:13 min/km
18.0Km - 19.0Km (incline -1.6%): 03:51 min/km
19.0Km - 20.0Km (incline -0.49%): 04:02 min/km
20.0Km - 21.0Km (incline 0.19%): 04:10 min/km
21.0Km - 21.23Km (incline -0.43%): 04:03 min/km
```
