# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# iTunes Web APIを使って動画で演奏されている曲名を設定する。オリジナルバンドの登録にも対応できるようにする。
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

# tokenInput callbacks
# 新規曲名＆アーティスト名登録が選択されたら、サーバーにその情報を送信する。新規登録時の記入フォーマットは"曲名@アーティスト名"
trackNew = (value) ->
  console.log "Begin remote add track: "+value
  div = value.split("@")
  $.ajax({
    type: "POST",
    url: "/tracks.json",
    data: {
      track: div[0]
      artist: div[1]
      art_work_url_30: "/assets/no_art_work.png"
      },
    success: completeRemoteAddTrack
    })

# トラックが追加されたら、サーバーのその情報を送信して動画とトラックの関連づけをする
trackAdd = (item) ->
  console.log "Begin update relation: movie="+gon.movie_id+" track="+item.trackId
  $.ajax({
    type: "POST",
    url: "/tracks.json",
    data: {
      movie: gon.movie_id
      track: item.trackName
      artist: item.artistName
      track_id: item.trackId
      artist_id: item.artistId
      art_work_url_30: item.artworkUrl30
      },
    success: completeRemoteEditTrack
    })

# トラックが削除されたら、サーバーにその情報を送信して動画とトラックの関連削除をする
trackDeleted = (item) ->
  console.log "Begin delete relation: movie="+gon.movie_id+" track="+item.trackId
  $.ajax({
    type: "DELETE",
    url: "/tracks/"+item.trackId+".json",
    data: {
      movie: gon.movie_id
      },
    success: completeRemoteDeleteTrack
    })

# ajax callback
# サーバーで新規トラックの追加が完了したらkeyを変更してtokenInputに追加する。
completeRemoteAddTrack = (res) ->
  console.log "Complete remote add: "+res.id
  $('#tracks').tokenInput('add', {
    trackId: res.id, 
    trackName: res.name, 
    artistId: res.artist.id, 
    artistName: res.artist.name, 
    artworkUrl30: res.art_work_url_30
    })

# サーバーで動画とトラックの関連づけが完了した時
completeRemoteEditTrack = (res) ->
  console.log "Complete update relation: track="+res.id

# サーバーで動画とトラックの関連削除が完了した時
completeRemoteDeleteTrack = (res) ->
  console.log "Complete delete relation: track="+res.id

# tokenInput formatter
# iTunesAPIのレスポンスを加工
tracksResults = (res) ->
  res.results

# ドロップダウンに表示する内容を加工
tracksFormatResults = (item) ->
  "<li>" + '<img src="'+ item.artworkUrl30 + '"/>&nbsp;' + item.trackName + " - " + item.artistName + " - " + "</li>"

# 追加された時に表示する内容を加工
tracksFormatToken = (item) ->
  "<li><p>" + '<img src="'+ item.artworkUrl30 + '"/>&nbsp;' + item.trackName + " - " + item.artistName + " - " + "</p></li>"
