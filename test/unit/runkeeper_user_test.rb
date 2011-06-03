require_relative '../test_helper'

class RunkeeperUserTest < Test::Unit::TestCase

  def test_should_get_user_info
    stub_get_profile
    runkeeper_user = RunKeeperActivities::User.find_by_username('kittensrule')
    assert_equal 'http://runkeeper.com/user/kittensrule/profile', runkeeper_user.profile_url
    assert_equal 'Arvid Andersson', runkeeper_user.name
    assert_equal 'http://s3.amazonaws.com/profilepic.runkeeper.com/5efrz7a3uZ9pZeCj0bDKiFUj_sm.jpg?', runkeeper_user.profile_image_url
    assert_equal 'km', runkeeper_user.distance_unit
    assert_equal 'h : m : s', runkeeper_user.duration_unit
    assert_equal 'min/km', runkeeper_user.pace_unit
    assert_equal 'km/h', runkeeper_user.speed_unit
    assert_equal 'calories', runkeeper_user.calories_unit
    assert_equal 'm', runkeeper_user.elevation_unit
  end

  def test_should_raise_on_404
    stub_get_non_existing_profile
    assert_raises(OpenURI::HTTPError) { RunKeeperActivities::User.find_by_username('non-existing') }
  end

  def test_should_get_user_activities
    stub_get_profile
    runkeeper_user = RunKeeperActivities::User.find_by_username('kittensrule')
    assert_kind_of Array, runkeeper_user.activities
    runkeeper_user.activities.first.tap do |activity|
      assert_equal 'http://runkeeper.com/user/arvida/activity/37709325', activity.url
      assert_equal '37709325', activity.id
      assert_equal '10.26', activity.distance
      assert_equal 'Running', activity.type
    end
  end
end
