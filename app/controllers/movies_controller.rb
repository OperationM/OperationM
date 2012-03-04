class MoviesController < ApplicationController
  # GET /movies
  # GET /movies.json
  def index
    @movies = Movie.all
    current_user = Omniuser.find(session[:user_id])

    # feed更新時のpush通知に対応までの暫定対処
    https = Net::HTTP.new("graph.facebook.com", 443)
    https.use_ssl = true
    https.ca_file = "#{$RAILS_ROOT}/cacert.pem"
    https.verify_mode = OpenSSL::SSL::VERIFY_PEER
    https.verify_depth = 5
    https.start do |w|
      response = w.get("/387659801250930/feed?fields=id,object_id,picture,source,properties&access_token=#{current_user.access_token}")
      feed = JSON.parse(response.body)
      video_meta_id = Hash.new
      feed.each do |rk, rh|
        if rk == "data"
          rh.each do |item|
            if item.has_key?("object_id")
              video_meta_id[item["object_id"]] = item["id"]
            end
          end
        end
      end
      logger.debug "video_meta_id: #{video_meta_id}"
      @movies.each do |movie|
        if video_meta_id.has_key?(movie.video)
          response = w.get("/#{video_meta_id[movie.video]}?access_token=#{current_user.access_token}")
          video_info = JSON.parse(response.body)
          logger.debug "#{movie.video}->meta: #{video_meta_id[movie.video]}"
          movie.meta = video_meta_id[movie.video]
          logger.debug "#{movie.video}->picture: #{video_info["picture"]}"
          movie.picture = video_info["picture"]
          # logger.debug "#{movie.video}->source: #{video_info["source"]}"
          # movie.source = video_info["source"]
          logger.debug "#{movie.video}->source: http://www.facebook.com/v/#{movie.video}"
          movie.source = "http://www.facebook.com/v/#{movie.video}"
          logger.debug "#{movie.video}->length: #{video_info["properties"][0]["text"]}"
          movie.length = video_info["properties"][0]["text"]
          movie.save
        end
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @movies }
    end
  end

  # GET /movies/1
  # GET /movies/1.json
  def show
    @movie = Movie.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @movie }
    end
  end

  # GET /movies/new
  # GET /movies/new.json
  def new
    @movie = Movie.new
    current_user = Omniuser.find(session[:user_id])
    gon.token = current_user.access_token

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @movie }
    end
  end

  # GET /movies/1/edit
  def edit
    @movie = Movie.find(params[:id])
  end

  # POST /movies
  # POST /movies.json
  def create
    @movie = Movie.new(params[:movie])

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: 'Movie was successfully created.' }
        format.json { render json: @movie, status: :created, location: @movie }
      else
        format.html { render action: "new" }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /movies/1
  # PUT /movies/1.json
  def update
    @movie = Movie.find(params[:id])

    respond_to do |format|
      if @movie.update_attributes(params[:movie])
        format.html { redirect_to @movie, notice: 'Movie was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.json
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy

    respond_to do |format|
      format.html { redirect_to movies_url }
      format.json { head :ok }
    end
  end
end
