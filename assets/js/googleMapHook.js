export default {
  mounted() {
    const handleNewSightingFunction = ({ sighting }) => {
      var markerPosition = { lat: sighting.latitude, lng: sighting.longitude }

      const marker = new google.maps.Marker({
        position: markerPosition,
        animation: google.maps.Animation.DROP,
      })

      // To add the marker to the map, call setMap();
      marker.setMap(window.map)
    }

    // handle new sightings as they show up
    this.handleEvent('new_sighting', handleNewSightingFunction)
  },
}