require 'spec_helper'

describe Comment do

  before(:each) do
    @current_user = Factory(:omniuser)
    @movie = Factory(:movie)
    @attr = { :comment => "test comment"}
  end

  it "should create a new instance with valid attributes" do
    @comments = @movie.comments.build([@attr])
    @comments[0].omniuser = @current_user
    @comments[0].save
  end

  describe "user and movie associations" do

    before(:each) do
      @comments = @movie.comments.build([@attr])
      @comments[0].omniuser = @current_user
      @comments[0].save
      @comment = @comments[0]
    end

    it "should have an omniuser attribute" do
      @comment.should respond_to(:omniuser)
    end

    it "should have a movie attribute" do
      @comment.should respond_to(:movie)
    end

    it "should have the right associated user" do
      @comment.omniuser.should == @current_user
    end

    it "should have the right associated movie" do
      @comment.movie.should == @movie
    end
  end

  describe "validations" do
    
    it "should require nonblank content" do
      @comments = @movie.comments.build([{ :comment => "   "}])
      @comments[0].omniuser = @current_user
      @comments[0].should_not be_valid
    end
  end

end
