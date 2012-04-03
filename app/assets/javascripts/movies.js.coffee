# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# ファイル選択
$ ->
  $('#file_upload').live('change', fileInfo)

# ボタン    
$ ->
  $('#start_upload').live('click', startUpload)

# チェックボックス
$ -> 
  $('#only_sync').live('change', changeVideoField)

# ライブ名選択用のセレクトボックス
$ ->
  $('#movie_concert_id').live('change', toggleCocertSelection)

# バンド名選択用のセレクトボックス
$ ->
  $('#movie_band_id').live('change', toggleBandSelection)

# document.ready
$ ->
  toggleCocertSelection()
  toggleBandSelection()
  $('.movie-list').popover({placement: 'top'})
  $('#graph_object').hide()
  $('.progress').hide()

$ ->
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

# ファイルが選択された時にファイルの情報を表示
fileInfo = () ->
  file = $("#file_upload").prop('files')[0]
  if file
    fileSize = 0
    if file.size > 1024 * 1024
      fileSize = (Math.round(file.size * 100 / (1024 * 1024)) / 100).toString() + 'MB';
    else
      fileSize = (Math.round(file.size * 100 / 1024) / 100).toString() + 'KB';

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
  checked = $('#only_sync').attr('checked')
  if checked
    console.log "post moogle"
    postForm()
  else
    console.log "post video before post moogle"
    $('.progress').show()
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

# 動画をアップロードする際のブログレス表示
uploadProgress = (evt) ->
  if evt.lengthComputable
    percentComplete = Math.round(evt.loaded * 100 / evt.total)
    $('#progress_number').css('width', percentComplete.toString() + '%')
  else
    $('#progress_number').html('unable to compute')

# アップロードが完了した時の処理
uploadComplete = (evt) ->
  $('#sync').empty()
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

# UUID作成
uuid = () ->
  S4 = () ->
    (((1+Math.random())*0x10000)|0).toString(16).substring(1)
  (S4()+S4()+"-"+S4()+"-"+S4()+"-"+S4()+"-"+S4()+S4()+S4())

