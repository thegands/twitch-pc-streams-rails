require 'test_helper'

class StreamsControllerTest < ActionController::TestCase
  setup do
    @stream = streams(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:streams)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stream" do
    assert_difference('Stream.count') do
      post :create, stream: { game_id: @stream.game_id, name: @stream.name, preview: @stream.preview, title: @stream.title, url: @stream.url, viewers: @stream.viewers }
    end

    assert_redirected_to stream_path(assigns(:stream))
  end

  test "should show stream" do
    get :show, id: @stream
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @stream
    assert_response :success
  end

  test "should update stream" do
    patch :update, id: @stream, stream: { game_id: @stream.game_id, name: @stream.name, preview: @stream.preview, title: @stream.title, url: @stream.url, viewers: @stream.viewers }
    assert_redirected_to stream_path(assigns(:stream))
  end

  test "should destroy stream" do
    assert_difference('Stream.count', -1) do
      delete :destroy, id: @stream
    end

    assert_redirected_to streams_path
  end
end