defmodule LiveSupWeb.Live.Welcome.Components.GoogleMapComponent do
  use LiveSupWeb, :component

  def render(assigns) do
    assigns =
      assigns
      |> Map.put(:google_map_key, LiveSup.Config.google_map_key!())

    ~H"""
    <input
      id="pac-input"
      class="absolute z-10 controls text-black min-w-1/5"
      type="text"
      placeholder="Search Box"
    />
    <div id="gmap" class="min-h-[300px] md:min-h-[500px] h-full" phx-update="ignore"></div>
    <!-- Async script executes immediately and must be after any DOM elements used in callback. -->
    <script
      src={"https://maps.googleapis.com/maps/api/js?key=#{@google_map_key}&callback=initMap&v=weekly&channel=2&libraries=places"}
      async
    >
    </script>

    <script>
        (function(exports) {
          "use strict";

          function initMap() {
              const initLatlng = { lat: -25.363, lng: 131.044 };
              const geocoder = new google.maps.Geocoder();

              const input = document.getElementById("pac-input");
              const searchBox = new google.maps.places.SearchBox(input);

              // Styles a map in night mode.
              const map = new google.maps.Map(document.getElementById("gmap"), {
                  center: initLatlng,
                  zoom: 12,
                  mapTypeControl: false,
                  styles: [{
                          elementType: "geometry",
                          stylers: [{
                              color: "#242f3e"
                          }]
                      },
                      {
                          elementType: "labels.text.stroke",
                          stylers: [{
                              color: "#242f3e"
                          }]
                      },
                      {
                          elementType: "labels.text.fill",
                          stylers: [{
                              color: "#746855"
                          }]
                      },
                      {
                          featureType: "administrative.locality",
                          elementType: "labels.text.fill",
                          stylers: [{
                              color: "#d59563"
                          }],
                      },
                      {
                          featureType: "poi",
                          elementType: "labels.text.fill",
                          stylers: [{
                              color: "#d59563"
                          }],
                      },
                      {
                          featureType: "poi.park",
                          elementType: "geometry",
                          stylers: [{
                              color: "#263c3f"
                          }],
                      },
                      {
                          featureType: "poi.park",
                          elementType: "labels.text.fill",
                          stylers: [{
                              color: "#6b9a76"
                          }],
                      },
                      {
                          featureType: "road",
                          elementType: "geometry",
                          stylers: [{
                              color: "#38414e"
                          }],
                      },
                      {
                          featureType: "road",
                          elementType: "geometry.stroke",
                          stylers: [{
                              color: "#212a37"
                          }],
                      },
                      {
                          featureType: "road",
                          elementType: "labels.text.fill",
                          stylers: [{
                              color: "#9ca5b3"
                          }],
                      },
                      {
                          featureType: "road.highway",
                          elementType: "geometry",
                          stylers: [{
                              color: "#746855"
                          }],
                      },
                      {
                          featureType: "road.highway",
                          elementType: "geometry.stroke",
                          stylers: [{
                              color: "#1f2835"
                          }],
                      },
                      {
                          featureType: "road.highway",
                          elementType: "labels.text.fill",
                          stylers: [{
                              color: "#f3d19c"
                          }],
                      },
                      {
                          featureType: "transit",
                          elementType: "geometry",
                          stylers: [{
                              color: "#2f3948"
                          }],
                      },
                      {
                          featureType: "transit.station",
                          elementType: "labels.text.fill",
                          stylers: [{
                              color: "#d59563"
                          }],
                      },
                      {
                          featureType: "water",
                          elementType: "geometry",
                          stylers: [{
                              color: "#17263c"
                          }],
                      },
                      {
                          featureType: "water",
                          elementType: "labels.text.fill",
                          stylers: [{
                              color: "#515c6d"
                          }],
                      },
                      {
                          featureType: "water",
                          elementType: "labels.text.stroke",
                          stylers: [{
                              color: "#17263c"
                          }],
                      },
                  ],
              });

              map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);
              // Bias the SearchBox results towards current map's viewport.
              map.addListener("bounds_changed", () => {
                searchBox.setBounds(map.getBounds());
              });

              let markers = [];

              // Listen for the event fired when the user selects a prediction and retrieve
              // more details for that place.
              searchBox.addListener("places_changed", () => {
                const places = searchBox.getPlaces();

                if (places.length == 0) {
                  return;
                }

                const address_types = [
                    "administrative_area_level_1", "administrative_area_level_2", "administrative_area_level_3",
                    "administrative_area_level_4", "administrative_area_level_5", "administrative_area_level_6",
                    "administrative_area_level_7", "locality", "sublocality"
                ]

                // TODO: This is ugly as hell
                places[0].address_components.find(address_component =>  {
                    if (address_types.includes(address_component.types[0])) {
                        document.getElementById("location-form_address_state").value = address_component.long_name;
                    }

                    if (address_component.types[0] == "country") {
                        document.getElementById("location-form_address_country").value = address_component.long_name;
                    }
                });

                document.getElementById("location-form_address_lat").value = places[0].geometry.location.lat();
                document.getElementById("location-form_address_lng").value = places[0].geometry.location.lng();

                // Clear out the old markers.
                markers.forEach((marker) => {
                  marker.setMap(null);
                });
                markers = [];

                // For each place, get the icon, name and location.
                const bounds = new google.maps.LatLngBounds();

                places.forEach((place) => {
                  if (!place.geometry || !place.geometry.location) {
                    console.log("Returned place contains no geometry");
                    return;
                  }
                  const icon = {
                    url: place.icon,
                    size: new google.maps.Size(71, 71),
                    origin: new google.maps.Point(0, 0),
                    anchor: new google.maps.Point(17, 34),
                    scaledSize: new google.maps.Size(25, 25),
                  };

                  // Create a marker for each place.
                  markers.push(
                    new google.maps.Marker({
                      map,
                      icon,
                      title: place.name,
                      position: place.geometry.location,
                    })
                  );
                  if (place.geometry.viewport) {
                    // Only geocodes have viewport.
                    bounds.union(place.geometry.viewport);
                  } else {
                    bounds.extend(place.geometry.location);
                  }
                });
                map.fitBounds(bounds);
              });
          }

          exports.initMap = initMap;
      })((this.window = this.window || {}));
    </script>
    """
  end
end
