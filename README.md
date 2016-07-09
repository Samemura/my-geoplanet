# my-geoplanet
sample code for Yahoo geoplanet.<br>
https://developer.yahoo.com/geo/geoplanet/guide/

## Dependency
gem 'geoplanet' # wrapper for GeoPlanet API.
https://github.com/carlosparamio/geoplanet

## Installation
1. install gem 'geoplanet'
2. copy 'fetch_geoplanet_place.rb' into your project.
3. set environment variable:
  - GEOPLANET_APPID

## Usage
<pre>
ruby fetch_geoplanet_place.rb woeid filename
</pre>

E.g.
<pre>
ruby fetch_geoplanet_place.rb                          # fetch Japan into "geoplanet.yml" as default
ruby fetch_geoplanet_place.rb 23424856 Fukushima.yml   # fetch Fukushima into "Fukushima.yml"
</pre>


### Check country
<pre>
curl http://where.yahooapis.com/v1/countries?appid=[yourappidhere]
</pre>

### Check place type
Placetype is dependent to Country so need to check before you fetching country.

Eg. for Japan.
<pre>
curl http://where.yahooapis.com/v1/placetypes/jp?appid=[yourappidhere]

Response:
{"placeTypes":{"placeType":[
  {"placeTypeName":"Undefined",
  "placeTypeName attrs":{"code":0},
  "uri":"http:\/\/where.yahooapis.com\/v1\/placetype\/0\/jp",
  "lang":"en-US"},
  {"placeTypeName":"Town",
  "placeTypeName attrs":{"code":7},
  "uri":"http:\/\/where.yahooapis.com\/v1\/placetype\/7\/jp",
  "lang":"en-US"},
  {"placeTypeName":"Prefecture",
  "placeTypeName attrs":{"code":8},
  "uri":"http:\/\/where.yahooapis.com\/v1\/placetype\/8\/jp",
  "lang":"en-US"},
  {"placeTypeName":"Gun\/Ku",
  "placeTypeName attrs":{"code":9},
  "uri":"http:\/\/where.yahooapis.com\/v1\/placetype\/9\/jp",
  "lang":"en-US"},
  {"placeTypeName":"Local Administrative Area",
  "placeTypeName attrs":{"code":10},
  "uri":"http:\/\/where.yahooapis.com\/v1\/placetype\/10\/jp",
  "lang":"en-US"},
  {"placeTypeName":"Postal Code",
  "placeTypeName attrs":{"code":11},
  "uri":"http:\/\/where.yahooapis.com\/v1\/placetype\/11\/jp",
  "lang":"en-US"},
  {"placeTypeName":"Country",
  "placeTypeName attrs":{"code":12},
  "uri":"http:\/\/where.yahooapis.com\/v1\/placetype\/12\/jp",
  "lang":"en-US"},
  {"placeTypeName":"Island",
  "placeTypeName attrs":{"code":13},
  "uri":"http:\/\/where.yahooapis.com\/v1\/placetype\/13\/jp",
  "lang":"en-US"},
  {"placeTypeName":"Airport",
  "placeTypeName attrs":{"code":14},
  "uri":"http:\/\/where.yahooapis.com\/v1\/placetype\/14\/jp",
  "lang":"en-US"},
  {"placeTypeName":"Drainage",
  "placeTypeName attrs":{"code":15},
  "uri":"http:\/\/where.yahooapis.com\/v1\/placetype\/15\/jp",
  "lang":"en-US"},
  {"placeTypeName":"Land Feature",
  "placeTypeName attrs":{"code":16},
  "uri":"http:\/\/where.yahooapis.com\/v1\/placetype\/16\/jp",
  "lang":"en-US"},
  {"placeTypeName":"Miscellaneous",
  "placeTypeName attrs":{"code":17},
  "uri":"http:\/\/where.yahooapis.com\/v1\/placetype\/17\/jp",
  "lang":"en-US"},
  {"placeTypeName":"Supername",
  "placeTypeName attrs":{"code":19},
  "uri":"http:\/\/where.yahooapis.com\/v1\/placetype\/19\/jp",
  "lang":"en-US"},
  {"placeTypeName":"Point of Interest",
  "placeTypeName attrs":{"code":20},
  "uri":"http:\/\/where.yahooapis.com\/v1\/placetype\/20\/jp",
  "lang":"en-US"},
  {"placeTypeName":"Suburb",
  "placeTypeName attrs":{"code":22},
  "uri":"http:\/\/where.yahooapis.com\/v1\/placetype\/22\/jp",
  "lang":"en-US"},
  {"placeTypeName":"Colloquial",
  "placeTypeName attrs":{"code":24},
  "uri":"http:\/\/where.yahooapis.com\/v1\/placetype\/24\/jp",
  "lang":"en-US"},
  {"placeTypeName":"Zone",
  "placeTypeName attrs":{"code":25},
  "uri":"http:\/\/where.yahooapis.com\/v1\/placetype\/25\/jp",
  "lang":"en-US"},
  {"placeTypeName":"Historical State",
  "placeTypeName attrs":{"code":26},
  "uri":"http:\/\/where.yahooapis.com\/v1\/placetype\/26\/jp",
  "lang":"en-US"},
  {"placeTypeName":"Historical County",
  "placeTypeName attrs":{"code":27},
  "uri":"http:\/\/where.yahooapis.com\/v1\/placetype\/27\/jp",
  "lang":"en-US"},
  {"placeTypeName":"Continent",
  "placeTypeName attrs":{"code":29},
  "uri":"http:\/\/where.yahooapis.com\/v1\/placetype\/29\/jp",
  "lang":"en-US"},
  {"placeTypeName":"Time Zone",
  "placeTypeName attrs":{"code":31},
  "uri":"http:\/\/where.yahooapis.com\/v1\/placetype\/31\/jp",
  "lang":"en-US"},
  {"placeTypeName":"Estate",
  "placeTypeName attrs":{"code":33},
  "uri":"http:\/\/where.yahooapis.com\/v1\/placetype\/33\/jp",
  "lang":"en-US"},
  {"placeTypeName":"Historical Town",
  "placeTypeName attrs":{"code":35},
  "uri":"http:\/\/where.yahooapis.com\/v1\/placetype\/35\/jp",
  "lang":"en-US"},
  {"placeTypeName":"Ocean",
  "placeTypeName attrs":{"code":37},
  "uri":"http:\/\/where.yahooapis.com\/v1\/placetype\/37\/jp",
  "lang":"en-US"},
  {"placeTypeName":"Sea",
  "placeTypeName attrs":{"code":38},
  "uri":"http:\/\/where.yahooapis.com\/v1\/placetype\/38\/jp",
  "lang":"en-US"}],
  "start":0,
  "count":25,
  "total":25}}
</pre>