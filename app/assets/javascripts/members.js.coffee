# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# FBのミューソグループのメンバーから検索する。ミューソグループ外の入力は追加しない。
$ ->
  $('#members').tokenInput('https://graph.facebook.com/224428787635384/members?access_token=' + gon.token, {
    jsonContainer: 'data'
    onAdd: memberAdd,
    onDelete: memberDelete,
    newTokenAllow: false,
    prePopulate: $('#members_tokens').data('pre')
    })

# tokenInput callback
# メンバーが選択された時、サーバーに情報を送信して動画とメンバーを関連づける
memberAdd = (item) ->
  console.log "Begin update relation: movie="+gon.movie_id+" member="+item.id
  $.ajax({
    type: "POST",
    url: "/members.json",
    data: "movie=" + gon.movie_id + "&id=" + item.id + "&name=" + item.name
    success: completeRemoteEditMember
    })

# メンバーが削除された時、サーバーに情報を送信して動画とメンバーの関連づけを削除する
memberDelete = (item) ->
  console.log "Begin delete relation: movie="+gon.movie_id+" member="+item.id
  $.ajax({
    type: "DELETE",
    url: "/members/"+item.id+".json",
    data: "movie="+gon.movie_id,
    success: completeRemoteDeleteMember
    })

# ajax callback
# サーバーで動画とメンバーの関連づけが完了した際の処理
completeRemoteEditMember = (res) ->
  console.log "Complete update relation: member="+res.id

# サーバーで動画とメンバーの関連削除が完了した際の処理
completeRemoteDeleteMember = (res) ->
  console.log "Complete delete relation: member="+res.id
