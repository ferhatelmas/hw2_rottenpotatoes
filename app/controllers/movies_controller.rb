class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    puts params[:ratings].class

    if params[:ratings].nil?
      @filter_ratings = []
    else
      @filter_ratings = params[:ratings]
      @filter_ratings = @filter_ratings.keys if @filter_ratings.respond_to?(:keys)
    end

    sort_field = params[:s]
    if sort_field == "t"
      @movies = Movie.find_all_by_rating(@filter_ratings, order: "title")
    elsif sort_field == "rd"
      @movies = Movie.find_all_by_rating(@filter_ratings, order: "release_date")
    else 
      @movies = Movie.find_all_by_rating(@filter_ratings)
    end

    @all_ratings = Movie.ratings
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
