require_relative '../test_helper'

class RunkeeperActivityTest < Test::Unit::TestCase

  def test_should_get_full_activity_info
    stub_get_profile
    stub_get_activity
    runkeeper_user = RunKeeperActivities::User.find_by_username('kittensrule')
    runkeeper_user.activities.first.tap do |_activity|
      assert_equal '37709325', _activity.id
      assert_equal 'Running', _activity.type
      assert_equal '2011-06-01 18:16:16 +0200', _activity.start_time.to_s
      assert_equal '2011-06-01 19:23:34 +0200', _activity.end_time.to_s
      assert_equal '10.26', _activity.distance
      assert_equal '1:07:18', _activity.duration
      assert_equal '6:34', _activity.pace
      assert_equal '9.15', _activity.speed
      assert_equal '919', _activity.calories
      assert_equal '76', _activity.elevation
    end
  end

  def test_should_generate_summery
    stub_get_profile
    runkeeper_user = RunKeeperActivities::User.find_by_username('kittensrule')
    assert_equal "Arvid Andersson completed a 10.26 km running activity", runkeeper_user.activities.first.summery
  end

end
