require 'spec_helper'

describe Movie do
  
  def valid_attributes
    {}
  end

  describe "comment associations" do
    before(:each) do
      @movie = Movie.create! valid_attributes
      @user = Factory(:omniuser)
      @cm1 = Factory(:comment, :omniuser => @user, :movie => @movie, :created_at => 1.day.ago)
      @cm2 = Factory(:comment, :omniuser => @user, :movie => @movie, :created_at => 1.hour.ago)
    end

    it "should have a comments attribute" do
      @movie.should respond_to(:comments)
    end

    it "should have the right comments in the right order" do
      @movie.comments.should == [@cm2, @cm1]
    end

    it "should destroy associated comments" do
      @movie.destroy
      [@cm1, @cm2].each do |comment|
        Comment.find_by_id(comment.id).should be_nil
      end
    end
  end
end
