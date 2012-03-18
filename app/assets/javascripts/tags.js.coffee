# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# Moogleサーバーで既に登録されているタグを検索する。無かった場合はそのまま追加できるようにする。
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

# tokenInput callback
# 新規タグ追加が選択された場合、サーバーに新規タグ名を送信
tagNew = (value) ->
  console.log "Begin remote add tag: "+value
  $.ajax({
    type: "POST",
    url: "/tags.json",
    data: {
      name: value
      },
    success: completeRemoteAddTag
    })

# タグが追加されたら動画とタグをサーバーに送信して関連づけする
tagAdd = (item) ->
  console.log "Begin update relation: movie="+gon.movie_id+" tag="+item.id
  $.ajax({
    type: "PUT",
    url: "/tags/"+item.id+".json",
    data: {
      movie: gon.movie_id
      },
    success: completeRemoteEditTag
    })

# タグが削除されたら動画とタグをサーバーに送信して関連を削除
tagDeleted = (item) ->
  console.log "Begin delete relation: movie="+gon.movie_id+" tag="+item.id
  $.ajax({
    type: "DELETE",
    url: "/tags/"+item.id+".json",
    data: {
      movie: gon.movie_id
      },
    success: completeRemoteDeleteTag
    })

# ajax callback
# サーバーで新規タグの登録が完了したらtokenInputにそのタグを追加する
completeRemoteAddTag = (res) ->
  console.log "Complete remote add: "+res.id
  $('#tags').tokenInput('add', {id: res.id, name: res.name})

# サーバーで動画とタグの関連づけが完了した時
completeRemoteEditTag = (res) ->
  console.log "Complete update relation: tag="+res.id

# サーバーで動画とタグの関連削除が完了した時
completeRemoteDeleteTag = (res) ->
  console.log "Complete delete relation: tag="+res.id
