require 'geocoder'

Geocoder.configure(:lookup => :yandex)

coordinates = Hash[ *ARGF.lines.map(&:strip).map do |line|
    [line, Geocoder.coordinates(line)]
end.flatten(1) ]
valid_coordinates = coordinates.reject { |_, value| value.nil? }

puts JSON.pretty_generate({
    :type => "FeatureCollection",
    :features => valid_coordinates.map { |location, coordinates|
        {
            :type => "Feature",
            :geometry => {
                :type => "Point",
                :coordinates => coordinates.reverse
            },
            :properties => {
                :title => location
            }
        }
    }
})
