# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# FBのミューソグループのメンバーから検索する。ミューソグループ外の入力は追加しない。
$ ->
  $('#members').tokenInput('https://graph.facebook.com/224428787635384/members?access_token=' + gon.token, {
    jsonContainer: 'data',
    addManually: true,
    beforeAdd: memberAddBefore,
    onDelete: memberDelete,
    noResultsText: "No results. When you add, please press the enter key or click here.",
    prePopulate: $('#members').data('pre'),
    tokenFormatter: membersFormatToken,
    preventDuplicates: true
    })

# tokenInput callback
# 検索結果から選択された時
memberAddBefore = (item) ->
  console.log "Begin remote add member: "+item.name
  $.ajax({
    type: "POST",
    url: "/members.json",
    data: {
      movie: gon.movie_id
      name: item.name
      },
    success: completeRemoteAddMember
    })

# メンバーが削除された時、サーバーに情報を送信して動画とメンバーの関連づけを削除する
memberDelete = (item) ->
  console.log "Begin delete relation: movie="+gon.movie_id+" member="+item.id
  $.ajax({
    type: "DELETE",
    url: "/members/"+item.id+".json",
    data: {
      movie: gon.movie_id
      },
    success: completeRemoteDeleteMember
    })

# ajax callback
# サーバーでメンバーの追加が完了したらtokenInputに追加する。
completeRemoteAddMember = (res) ->
  console.log "Complete remote add: "+res.id
  $('#members').tokenInput('add', {id: res.id, name: res.name})

# サーバーで動画とメンバーの関連削除が完了した際の処理
completeRemoteDeleteMember = (res) ->
  console.log "Complete delete relation: member="+res.id

# 追加された時に表示する内容を加工
membersFormatToken = (item) ->
  "<li><p>" + '<a href="/members/' + item.id + '">' + item.name + "<a/></p></li>"