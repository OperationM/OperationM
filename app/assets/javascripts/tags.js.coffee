# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $('#tag_form').bind('ajax:complete', completeTagPost)

$ ->
  $('.tag').liveDraggable({
    revert: 'invalid',
  })

$ ->
  $('#tag_trash').droppable({
    accept: '.tag',
    tolerance: 'touch',
    drop: deleteTag
  })

$.fn.liveDraggable = (opts) ->
  this.live('mouseover', ->
    if !$(this).data("init")
      $(this).data("init", true).draggable(opts))

completeTagPost = (evt, ajax) ->
  res = $.parseJSON(ajax.responseText)
  $('#tags').append(res.html)
  $('#tag_name').val('')

deleteTag = (evt, ui) ->
  tag_id = ui.draggable.attr('id').match(/[0-9]+/i)
  movie_id = ui.draggable.attr('movie_id').match(/[0-9]+/i)
  url = "/movies/" + movie_id + "/tags/" + tag_id + ".json"
  console.log url
  $.ajax({
    type: "DELETE",
    url: url,
    success: completeDelTag
  })

completeDelTag = (data, status, xhr) ->
  tag_id = "#tag_" + data.tag_id
  $(tag_id).remove()
