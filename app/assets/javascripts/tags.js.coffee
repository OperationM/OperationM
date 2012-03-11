# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $('#tag_form').bind('ajax:complete', completeTagPost)

completeTagPost = (evt, ajax) ->
  res = $.parseJSON(ajax.responseText)
  $('#tags').append(res.html)
  $('#tag_name').val('')

