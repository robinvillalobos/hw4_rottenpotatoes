require 'spec_helper'

describe MoviesController do
  describe 'edit page for appropriate Movie' do
    
    it 'When I go to the edit page for the Movie, it should be loaded' do
      @mov = mock('Movie')
      Movie.should_receive(:find).with('1').and_return(@mov)
      get :edit, {:id => '1'}
      response.should be_success
    end

    it 'And I fill in "Director" with "Ridley Scott", And  I press "Update Movie Info", it should save the director' do
      @mov = mock('Movie')	
      @mov.should_receive(:update_attributes!).and_return(true)
      put :update, {:id => '1', :movie => @mov }
    end

    it 'When I follow "Find Movies With Same Director", I should be on the Similar Movies page for the Movie' do
      @mov = mock('Movie')
      @mov.stub!(:director).and_return('fake director')
      @mov.stub!(:title).and_return('fake title')
      @fake_results = [mock('Movie'), mock('Movie')]
      Movie.should_receive(:find).with('1').and_return(@mov)
      Movie.should_receive(:find_all_by_director).with(@mov.director).and_return(@fake_results)
      get :similar, {:director => 'fake director'}
    end

    it 'should show Movie by id' do
      @mov = mock('Movie')
      Movie.should_receive(:find).with('1').and_return(@mov)
      get :show, {:id => '1'}
    end

    it 'should redirect to index if movie does not have a director' do
      @mov = mock('Movie')
      @mov.stub!(:director).and_return(nil)
      @mov.stub!(:title).and_return('fake title')
      
      Movie.should_receive(:find).with('1').and_return(@mov)
      get :similar, {:id => '1'}
      response.should redirect_to(movies_path)
    end

    it 'should be possible to create movie' do
      @mov = mock('Movie')
      @mov.stub!(:title)      
      Movie.should_receive(:create!).and_return(@mov)
      post :create, {:movie => @mov}
      response.should redirect_to(movies_path)
    end

    it 'should be possible to destroy movie' do
      @mov = mock('Movie')
      @mov.stub!(:title)      
      Movie.should_receive(:find).with('1').and_return(@mov)
      Movie.should_receive(:destroy)
      post :destroy, {:id => '1'}
      response.should redirect_to(movies_path)
    end

    it 'should redirect if sort order has been changed' do
      session[:sort] = 'release_date'
      get :index, {:sort => 'title'}
      response.should redirect_to(movies_path(:sort => 'title'))
    end
    it 'should be possible to order by release date' do
      get :index, {:sort => 'release_date'}
      response.should redirect_to(movies_path(:sort => 'release_date'))
    end
    it 'should redirect if selected ratings are changed' do
      get :index, {:ratings => {:G => 1}}
      response.should redirect_to(movies_path(:ratings => {:G => 1}))
    end
    it 'should remove noDirector message from session' do
      session[:noDirector] = 'test'
      get :index
      session[:noDirector].should == nil
    end
    it 'should call database to get movies' do
      Movie.should_receive(:find_all_by_rating)
      get :index
    end
  end
end
