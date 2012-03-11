# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $('#file_upload').live('change', fileInfo)
    
$ ->
  $('#start_upload').live('click', startUpload)

$ -> 
  $('#only_sync').live('change', changeVideoField)

fileInfo = () ->
  file = $("#file_upload").prop('files')[0]
  if file
    fileSize = 0
    if file.size > 1024 * 1024
      fileSize = (Math.round(file.size * 100 / (1024 * 1024)) / 100).toString() + 'MB';
    else
      fileSize = (Math.round(file.size * 100 / 1024) / 100).toString() + 'KB';
    $('#file_name').html('Name: ' + file.name)
    $('#file_size').html('Size: ' + fileSize)
    $('#file_type').html('Type: ' + file.type)

startUpload = () ->
  checked = $('#only_sync').attr('checked')
  if checked
    console.log "post moogle"
    postForm()
  else
    console.log "post video before post moogle"
    xhr = new XMLHttpRequest()
    xhr.upload.addEventListener("progress", uploadProgress, false)
    xhr.addEventListener("load", uploadComplete, false)
    xhr.addEventListener("error", uploadFailed, false)
    xhr.addEventListener("abort", uploadCanceled, false)
    fd = new FormData()
    fd.append("fileToUpload", $('#file_upload').prop('files')[0])
    base_url = "https://graph-video.facebook.com/387659801250930/videos"
    title = uuid()
    description = "moogle"
    post_url = base_url + "?title=" + title + "&description=" + description + "&access_token=" + gon.token
    console.log post_url
    xhr.open("POST", post_url)
    xhr.send(fd)

uploadProgress = (evt) ->
  if evt.lengthComputable
    percentComplete = Math.round(evt.loaded * 100 / evt.total)
    $('#progress_number').html(percentComplete.toString() + '%')
  else
    $('#progress_number').html('unable to compute')

uploadComplete = (evt) ->
  $('#sync').empty().append('<div class="field"><label for="graph_object">Graph object</label><br><input id="movie_video" name="movie[video]" type="text" value=""></div>');
  $('#movie_video').val(parseID(evt.target.responseText))
  postForm

uploadFailed = (evt) ->
  console.log "There was an error attempting to upload the file."

uploadCanceled = (evt) ->
  console.log "The upload has been canceled by the user or the browser dropped the connection."

postForm = () ->
  $('#movie_form').submit()
  console.log "finish submit"

parseID = (jsData) ->
  data = eval("("+jsData+")")
  data.id

uuid = () ->
  S4 = () ->
    (((1+Math.random())*0x10000)|0).toString(16).substring(1)
  (S4()+S4()+"-"+S4()+"-"+S4()+"-"+S4()+"-"+S4()+S4()+S4())

changeVideoField = () ->
  checked = $('#only_sync').attr('checked')
  $('#sync').empty()
  if checked
    $('#sync').append('<div class="field"><label for="graph_object">Graph object</label><br><input id="movie_video" name="movie[video]" type="text" value=""></div>');
  else
    $('#sync').append('<div class="field"><label for="attachment">Attachment</label><br><input id="file_upload" name="file[upload]" type="file"></div>');
    $('#sync').append('<div id="file_name"></div>');
    $('#sync').append('<div id="file_size"></div>');
    $('#sync').append('<div id="file_type"></div>');
    $('#sync').append('<div id="progress_number"></div>');

