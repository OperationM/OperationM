# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# ボタン    
$ ->
  if $('#start_upload').size() > 0
    $('#start_upload').live('click', startUpload)

# ライブ名選択用のセレクトボックス
$ ->
  if $('#movie_concert_id').size() > 0
    $('#movie_concert_id').live('change', toggleCocertSelection)

# バンド名選択用のセレクトボックス
$ ->
  if $('#movie_band_id').size() > 0
    $('#movie_band_id').live('change', toggleBandSelection)

# document.ready
$ ->
  toggleCocertSelection()
  toggleBandSelection()
  $('.movie-list').popover({placement: 'top'})
  $('#graph_object').hide()
  $('.progress').hide()

$ ->
  if $('#thumbnail').size() > 0
    $('#movie-thumbnail')
      .live("ajax:complete", (xhr)->
      )
      .live("ajax:beforeSend", (xhr)->
      )
      .live("ajax:success", (event, data, status, xhr)->
        $('#movie-view').empty().append(data.html)
      )
      .live("ajax:error", (data, status, xhr)->
        console.log "error"
      )

# Concert入力用のセレクトボックスが選択された時
toggleCocertSelection = () ->
  select_box = $('#movie_concert_id')
  wrapper = $('#new_concert_wrapper')
  if select_box.size() > 0
    index = select_box.get(0).selectedIndex
    if index > 0
      wrapper.hide('fast')
    else
      wrapper.show('fast')

# Band入力用のセレクトボックスが選択された時  
toggleBandSelection = () ->
  select_box = $('#movie_band_id')
  wrapper = $('#new_band_wrapper')
  if select_box.size() > 0
    index = select_box.get(0).selectedIndex
    if index > 0
      wrapper.hide('fast')
    else
      wrapper.show('fast')

# MoogleへのPOSTのみにするかどうかのトグルスイッチ
changeVideoField = () ->
  checked = $('#only_sync').attr('checked')
  if checked
    $('#sync').hide()
    $('#graph_object').show()
  else
    $('#sync').show()
    $('#graph_object').hide()

# アップロードボタンが押された時の処理
startUpload = () ->
  console.log "post video before post moogle"
  $('.progress').show()
  $.ajax({
    type: 'GET'
    url: "https://graph.facebook.com/me/accounts?access_token="+gon.token
    dataType: 'json'
    success: (data, dataType) ->
      get_app_access_token(data, dataType)
    error: (XMLHttpRequest, textStatus, errorThrown) ->
      console.log XMLHttpRequest
      console.log textStatus
      console.log errorThrown
    })

get_app_access_token = (data, dataType) ->
  console.log data.data
  app_id = "253970248019703"
  for obj in data.data
    if obj.id == app_id
      moogle_access_token = obj.access_token

  if moogle_access_token    
    title = ""
    description = ""
    upload_url = "https://graph-video.facebook.com/"+app_id+"/videos?access_token="+moogle_access_token
    fd = new FormData()
    fd.append("fileToUpload", $('#file_upload').prop('files')[0])
    fd.append("title", title)
    fd.append("description", description)
    xhr = new XMLHttpRequest()
    xhr.upload.addEventListener("progress", uploadProgress, false)
    xhr.addEventListener("load", uploadComplete, false)
    xhr.addEventListener("error", uploadFailed, false)
    xhr.addEventListener("abort", uploadCanceled, false)
    xhr.open("POST", upload_url)
    xhr.send(fd)

# 動画をアップロードする際のブログレス表示
uploadProgress = (evt) ->
  if evt.lengthComputable
    percentComplete = Math.round(evt.loaded * 100 / evt.total)
    $('#progress_number').css('width', percentComplete.toString() + '%')
  else
    $('#progress_number').html('unable to compute')

# アップロードが完了した時の処理
uploadComplete = (evt) ->
  console.log evt
  $('#movie_video').val(parseID(evt.target.responseText))
  postForm()

# アップロードに失敗した時の処理
uploadFailed = (evt) ->
  console.log "There was an error attempting to upload the file."

# アップロードがキャンセルされた時の処理
uploadCanceled = (evt) ->
  console.log "The upload has been canceled by the user or the browser dropped the connection."

# アプリへのPOST
postForm = () ->
  $('#new_movie').submit()
  console.log "finish submit"

# ID取得
parseID = (jsData) ->
  data = eval("("+jsData+")")
  data.id

