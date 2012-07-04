# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# Moogleサーバーで既に登録されているタグを検索する。無かった場合はそのまま追加できるようにする。
$ ->
  if $('#tags').size() > 0
    $('#tags').tokenInput('/tags.json', {
      crossDomain: false,
      addManually: true,
      beforeAdd: tagAddBefore,
      onDelete: tagDeleted,
      noResultsText: "No results. When you add, please press the enter key or click here.",
      prePopulate: $('#tags').data('pre'),
      tokenFormatter: tagsFormatToken,
      preventDuplicates: true
      })

# tokenInput callback
# 結果が選択された場合、サーバーに新規タグ名を送信
tagAddBefore = (item) ->
  console.log "Begin remote add tag: "+item.name
  $.ajax({
    type: "POST",
    url: "/tags.json",
    data: {
      movie: gon.movie_id
      name: item.name
      },
    success: completeRemoteAddTag
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

# サーバーで動画とタグの関連削除が完了した時
completeRemoteDeleteTag = (res) ->
  console.log "Complete delete relation: tag="+res.id

# 追加された時に表示する内容を加工
tagsFormatToken = (item) ->
  "<li><p>" + '<a href="/tags/' + item.id + '">' + item.name + "<a/></p></li>"
