# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
	$('#file_upload').change ->
	  file = document.getElementById("file_upload").files[0]
	  if file
	    fileSize = 0
	    if file.size > 1024 * 1024
	      fileSize = (Math.round(file.size * 100 / (1024 * 1024)) / 100).toString() + 'MB';
	    else
	      fileSize = (Math.round(file.size * 100 / 1024) / 100).toString() + 'KB';
	    document.getElementById('file_name').innerHTML = 'Name: ' + file.name;
	    document.getElementById('file_size').innerHTML = 'Size: ' + fileSize;
	    document.getElementById('file_type').innerHTML = 'Type: ' + file.type;

$(document).ready ->
	$('#start_upload').click ->
		fd = new FormData()
		fd.append("fileToUpload", document.getElementById("file_upload").files[0])
		xhr = new XMLHttpRequest()
		xhr.upload.addEventListener("progress", uploadProgress, false)
		xhr.addEventListener("load", uploadComplete, false)
		xhr.addEventListener("error", uploadFailed, false)
		xhr.addEventListener("abort", uploadCanceled, false)
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
    document.getElementById('progress_number').innerHTML = percentComplete.toString() + '%'
  else
    document.getElementById('progress_number').innerHTML = 'unable to compute'

uploadComplete = (evt) ->
	document.getElementById("movie_video").value = parseID(evt.target.responseText)
	form = document.getElementById("new_movie")
	form.submit()

uploadFailed = (evt) ->
	console.log "There was an error attempting to upload the file."

uploadCanceled = (evt) ->
	console.log "The upload has been canceled by the user or the browser dropped the connection."

parseID = (jsData) ->
	data = eval("("+jsData+")")
	data.id

uuid = () ->
  S4 = () ->
    (((1+Math.random())*0x10000)|0).toString(16).substring(1)
  (S4()+S4()+"-"+S4()+"-"+S4()+"-"+S4()+"-"+S4()+S4()+S4())
