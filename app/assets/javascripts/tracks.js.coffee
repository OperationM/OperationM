# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# iTunes Web APIを使って動画で演奏されている曲名を設定する。オリジナルバンドの登録にも対応できるようにする。
$ ->
  $('#tracks').tokenInput('http://itunes.apple.com/search?limit=50&country=jp&media=music&entity=song', {
    queryParam: 'term',
    propertyToSearch: 'artist',
    addManually: true,
    beforeAdd: trackAddBefore,
    onDelete: trackDeleted,
    prePopulate: $('#tracks').data('pre'),
    onResult: tracksResults,
    noResultsText: "No results. When you add, please press the enter key or click here.",
    resultsFormatter: tracksFormatResults,
    tokenFormatter: tracksFormatToken,
    searchDelay: 1000
    })

# tokenInput callbacks
# 検索結果から選択された時。新規登録時の記入フォーマットは"曲名@アーティスト名"
trackAddBefore = (item) ->
  console.log "Begin remote add track: "+item.name
  if item.id == null
    div = item.name.split("@")
    data = {
      movie: gon.movie_id
      track: div[0]
      artist: div[1]
      artwork: "/assets/no_art_work.png"
    }
  else
    data = {
      movie: gon.movie_id
      track: item.name
      artist: item.artist
      artwork: item.art_work_url_30
    }  
  $.ajax({
    type: "POST",
    url: "/tracks.json",
    data: data,
    success: completeRemoteAddTrack
    })

# トラックが削除されたら、サーバーにその情報を送信して動画とトラックの関連削除をする
trackDeleted = (item) ->
  console.log "Begin delete relation: movie="+gon.movie_id+" track="+item.id
  $.ajax({
    type: "DELETE",
    url: "/tracks/"+item.id+".json",
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
    id: res.id, 
    name: res.name, 
    artist_id: res.artist.id, 
    artist: res.artist.name, 
    art_work_url_30: res.art_work_url_30
    })

# サーバーで動画とトラックの関連削除が完了した時
completeRemoteDeleteTrack = (res) ->
  console.log "Complete delete relation: track="+res.id

# tokenInput formatter
# iTunesAPIのレスポンスを加工
tracksResults = (res) ->
  ret = []
  for item in res.results
    data = {
      id: item.trackId
      name: item.trackName
      artist_id: item.artistId
      artist: item.artistName
      art_work_url_30: item.artworkUrl30
    }
    ret.push(data)
  ret

# ドロップダウンに表示する内容を加工
tracksFormatResults = (item) ->
  "<li>" + '<img src="'+ item.art_work_url_30 + '"/>&nbsp;' + item.name + " - " + item.artist + " - " + "</li>"

# 追加された時に表示する内容を加工
tracksFormatToken = (item) ->
  "<li><p>" + '<img src="'+ item.art_work_url_30 + '"/>&nbsp;' + item.name + " - " + item.artist + " - " + "</p></li>"
