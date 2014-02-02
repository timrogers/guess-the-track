class ArtistsController < ApplicationController
  before_filter :fetch_songs
  rescue_from RapGenius::NotFoundError, with: :not_found

  def show
    @songs_to_guess_from = @songs.sample(4)

    @correct_song = @songs_to_guess_from.shuffle.first
    @correct_lyric = @correct_song.lines.sample

    session[:correct_song] = {
      id: @correct_song.id,
      title: @correct_song.title,
      url: @correct_song.url
    }
  end

  def answer
    if params[:song_id] 
      if params[:song_id].to_i == session[:correct_song][:id]
        flash[:notice] = "That's absolutely correct - that lyric is from " +
          "'#{session[:correct_song][:title]}'. You can check out the rest" +
          " of the lyrics and listen " +
          "<a href='#{session[:correct_song][:url]}'>here</a>."
      else
        flash[:alert] = "Sorry, that's not quite right. That lyric is from " +
          "'#{session[:correct_song][:title]}'. You can check out the rest" +
          " of the lyrics and listen " +
          "<a href='#{session[:correct_song][:url]}'>here</a>."
      end
    end

    redirect_to artist_path(params[:id])
  end

  private

  def artist
    @artist ||= RapGenius::Artist.find(params[:id])
  end

  def fetch_songs
    page_number = 1 + rand(5)
    @songs ||= artist.songs(page: page_number)
  end
end
