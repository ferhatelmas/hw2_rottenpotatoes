class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings

    if params[:ratings].nil?
      @filter_ratings = session[:ratings].nil? ? [] : session[:ratings]
    else
      @filter_ratings = params[:ratings].respond_to?(:keys) ? params[:ratings].keys : params[:ratings]
    end
    session[:ratings] = @filter_ratings

    sort_field = params[:s].nil? ? session[:s] : params[:s]
    if sort_field == "t"
      @movies = Movie.find_all_by_rating(@filter_ratings, order: "title")
    elsif sort_field == "rd"
      @movies = Movie.find_all_by_rating(@filter_ratings, order: "release_date")
    else 
      @movies = Movie.find_all_by_rating(@filter_ratings)
    end
    session[:s] = sort_field

    if session[:toggle]
      session[:toggle] = false
      redirect_to movies_path(ratings: session[:ratings], s: session[:s])
    else
      session[:toggle] = true
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
