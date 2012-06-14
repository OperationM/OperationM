# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# ボタン    
$ ->
  if $('#start_upload').size() > 0
    $('#start_upload').live('click', startUpload)

$ ->
  if $('#cancel_upload').size() > 0
    $('#cancel_upload').live('click', cancelUpload)

# ライブ名選択用のセレクトボックス
$ ->
  if $('#movie_concert_id').size() > 0
    $('#movie_concert_id').live('change', toggleCocertSelection)

# バンド名選択用のセレクトボックス
$ ->
  if $('#movie_band_id').size() > 0
    $('#movie_band_id').live('change', toggleBandSelection)

action_is_post = false

# document.ready
$ ->
  toggleCocertSelection()
  toggleBandSelection()
  $('.movie-list').popover({placement: 'top'})
  $('#graph_object').hide()
  $('.progress').hide()
  $("body").bind("ajaxSend",(c,xhr) ->
    $( window ).bind("beforeunload", (e) ->
      console.log action_is_post
      e = e || window.event
      if e && action_is_post == false
        e.returnValue = "Uploading now!"
        return "Uploading now!"
      else
        return null
    )
  )

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
  valid = validate()
  if valid
    $('#start_upload').attr('disabled', true)
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

# キャンセルボタンが押された時の処理
cancelUpload = () ->
  location.reload()

# アップロード時のバリデート
validate = () ->
  selected_concert = $('#movie_concert_id').get(0).selectedIndex
  movie_concert_name = $('#movie_concert_name').val()
  if selected_concert == 0 && movie_concert_name == ""
    alert "Please input a concert name!"
    return false

  selected_band = $('#movie_band_id').get(0).selectedIndex
  movie_band_name = $('#movie_band_name').val()
  if selected_band == 0 && movie_band_name == ""
    alert "Please input a band name!"
    return false

  upload_file = $('#file_upload').val()
  if upload_file == ""
    alert "Please select an upload file!"
    return false
    
  return true

# ユーザー情報からmoogleアプリ投稿用のアクセストークンを取得
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
  action_is_post = true
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

# ID取得
parseID = (jsData) ->
  data = eval("("+jsData+")")
  data.id

