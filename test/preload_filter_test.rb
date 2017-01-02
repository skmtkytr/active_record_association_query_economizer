require 'helper'

describe 'preload' do
  before do
    @user_postable      = User.create postable:  true, activated: true
    @user_not_postable  = User.create postable: false, activated: true
    @user_not_activated = User.create postable:  true, activated: false
    2.times.map { |i|     @user_postable.posts.build(body: "sample body #{i}").save }
     @user_not_postable.posts.build(body: "sample body by not postable user" ).save
    @user_not_activated.posts.build(body: "sample body by not activated user").save
  end

  it 'got preloaded associations' do
    assert User.where(id: @user_postable.id).preload(:posts).first.posts.size.must_equal 2
  end

  it 'all associations are filtered' do
    assert User.where(id: @user_not_postable.id ).preload(:posts).first.posts.size.must_equal 0
    assert User.where(id: @user_not_activated.id).preload(:posts).first.posts.size.must_equal 0
  end
end