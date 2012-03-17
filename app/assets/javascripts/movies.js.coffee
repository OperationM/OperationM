# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $('#file_upload').live('change', fileInfo)
    
$ ->
  $('#start_upload').live('click', startUpload)

$ -> 
  $('#only_sync').live('change', changeVideoField)

$ ->
  $('#tags').tokenInput('/tags.json', {
    crossDomain: false,
    newTokenConfirmed: tagNew,
    onAdd: tagAdd,
    onDelete: tagDeleted,
    newTokenAllow: true,
    confirmNewTokenText: "Add it?",
    prePopulate: $('#tags_tokens').data('pre')
    })

$ ->
  $('#tracks').tokenInput('http://itunes.apple.com/search?limit=50&country=jp&media=music&entity=song', {
    queryParam: 'term',
    propertyToSearch: 'artistName',
    newTokenConfirmed: trackNew,
    onAdd: trackAdd,
    onDelete: trackDeleted,
    newTokenAllow: true,
    confirmNewTokenText: "Add it?",
    prePopulate: $('#tracks_tokens').data('pre'),
    onResult: tracksResults,
    resultsFormatter: tracksFormatResults,
    tokenFormatter: tracksFormatToken,
    searchDelay: 2000
    })

$ ->
  $('#members').tokenInput('https://graph.facebook.com/387659801250930/members?access_token=' + gon.token, {
    jsonContainer: 'data'
    onAdd: memberAdd,
    onDelete: memberDelete,
    newTokenAllow: false,
    prePopulate: $('#members_tokens').data('pre')
    })

# Member callbacks
memberAdd = (item) ->
  console.log "Begin update relation: movie="+gon.movie_id+" member="+item.id
  $.ajax({
    type: "POST",
    url: "/members.json",
    data: "movie=" + gon.movie_id + "&id=" + item.id + "&name=" + item.name
    success: completeRemoteEditMember
    })

completeRemoteEditMember = (res) ->
  console.log "Complete update relation: member="+res.id

memberDelete = (item) ->
  console.log "Begin delete relation: movie="+gon.movie_id+" member="+item.id
  $.ajax({
    type: "DELETE",
    url: "/members/"+item.id+".json",
    data: "movie="+gon.movie_id,
    success: completeRemoteDeleteMember
    })

completeRemoteDeleteMember = (res) ->
  console.log "Complete delete relation: member="+res.id

# Tag callbacks
tagNew = (value) ->
  console.log "Begin remote add tag: "+value
  $.ajax({
    type: "POST",
    url: "/tags.json",
    data: "name="+value,
    success: completeRemoteAddTag
    })

completeRemoteAddTag = (res) ->
  console.log "Complete remote add: "+res.id
  $('#tags').tokenInput('add', {id: res.id, name: res.name})

tagAdd = (item) ->
  console.log "Begin update relation: movie="+gon.movie_id+" tag="+item.id
  $.ajax({
    type: "PUT",
    url: "/tags/"+item.id+".json",
    data: "movie=" + gon.movie_id,
    success: completeRemoteEditTag
    })

completeRemoteEditTag = (res) ->
  console.log "Complete update relation: tag="+res.id

tagDeleted = (item) ->
  console.log "Begin delete relation: movie="+gon.movie_id+" tag="+item.id
  $.ajax({
    type: "DELETE",
    url: "/tags/"+item.id+".json",
    data: "movie="+gon.movie_id,
    success: completeRemoteDeleteTag
    })

completeRemoteDeleteTag = (res) ->
  console.log "Complete delete relation: tag="+res.id

# Track callbacks
trackNew = (value) ->
  console.log "Begin remote add track: "+value
  div = value.split("@")
  $.ajax({
    type: "POST",
    url: "/tracks.json",
    data: "track="+div[0]+"&artist="+div[1]+"&art_work_url_30="+"/assets/no_art_work.png",
    success: completeRemoteAddTrack
    })

completeRemoteAddTrack = (res) ->
  console.log "Complete remote add: "+res.id
  $('#tracks').tokenInput('add', {
    trackId: res.id, 
    trackName: res.name, 
    artistId: res.artist.id, 
    artistName: res.artist.name, 
    artworkUrl30: res.art_work_url_30
    })

trackAdd = (item) ->
  console.log "Begin update relation: movie="+gon.movie_id+" track="+item.trackId
  $.ajax({
    type: "POST",
    url: "/tracks.json",
    data: "movie="+gon.movie_id+"&track="+item.trackName+"&artist="+item.artistName+"&track_id="+item.trackId+"&artist_id="+item.artistId+"&art_work_url_30="+item.artworkUrl30,
    success: completeRemoteEditTrack
    })

completeRemoteEditTrack = (res) ->
  console.log "Complete update relation: track="+res.id

trackDeleted = (item) ->
  console.log "Begin delete relation: movie="+gon.movie_id+" track="+item.trackId
  $.ajax({
    type: "DELETE",
    url: "/tracks/"+item.trackId+".json",
    data: "movie="+gon.movie_id,
    success: completeRemoteDeleteTrack
    })

completeRemoteDeleteTrack = (res) ->
  console.log "Complete delete relation: track="+res.id

tracksResults = (res) ->
  res.results

tracksFormatResults = (item) ->
  "<li>" + '<img src="'+ item.artworkUrl30 + '"/>&nbsp;' + item.trackName + " - " + item.artistName + " - " + "</li>"


tracksFormatToken = (item) ->
  "<li><p>" + '<img src="'+ item.artworkUrl30 + '"/>&nbsp;' + item.trackName + " - " + item.artistName + " - " + "</p></li>"

# Movie register
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

