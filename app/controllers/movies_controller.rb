class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G','PG','PG-13','R']
    
    if params[:ratings]
      @ratings = params[:ratings].keys
      session[:ratings] = @ratings
    elsif session[:ratings]
      @ratings = session[:ratings]
      redirect = true
    else
      @ratings = @all_ratings
    end
    
    if params[:sort]
      @sort = params[:sort]
      session[:sort] = @sort
    elsif session[:sort]
      @sort = session[:sort]
      redirect = true
    end
    
    if redirect
      ratings_hash = {}
      @ratings.each {|r| ratings_hash[r] = 1}
      if @sort
        redirect_to movies_path(sort: @sort, ratings: ratings_hash)
      else
        redirect_to movies_path(ratings: ratings_hash)
      end
    end
      
    @movies = Movie.where(rating: @ratings).order(@sort)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
