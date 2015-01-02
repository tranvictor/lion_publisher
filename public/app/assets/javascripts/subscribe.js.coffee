# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  $('.subscribe').on("ajax:success", (e, data, status, xhr) ->
    console.log(data)
    window.Alert.removeAll()
    window.Alert.add(data)
  ).on('ajax:error', (e, xhr, status, error) ->
    console.log(xhr.responseText)
    window.Alert.removeAll()
    window.Alert.add(xhr.responseText)
  )
