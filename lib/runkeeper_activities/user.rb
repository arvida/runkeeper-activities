module RunKeeperActivities
  class User
    attr_reader :username,
                :name,
                :profile_url,
                :profile_image_url,
                :activities

    class << self
      def find_by_username(username)
        RunKeeperActivities::User.new(username).tap { |_user| _user.get_profile }
      end
    end

    def initialize(username)
      @username = username
      @profile_url = Utils.runkeeper_url("/user/#{username}/profile")
    end

    def activities_url
      @activities_url ||= Utils.runkeeper_url("/user/#{username}/activity")
    end

    def distance_unit
      @distance_unit ||= page.at_css('#statsDistance .unitText').text
    end

    def duration_unit
      @duration_unit ||= page.at_css('#statsDuration .unitText').text
    end

    def pace_unit
      @pace_unit ||= page.at_css('#statsPace .unitText').text
    end

    def speed_unit
      @speed_unit ||= page.at_css('#statsSpeed .unitText').text
    end

    def calories_unit
      @calories_unit ||= page.at_css('#statsCalories .unitText').text
    end

    def elevation_unit
      @elevation_unit ||= page.at_css('#statsElevation .unitText').text
    end

    def activities
      return @activities if defined?(@activities)
      @activities = RunKeeperActivities::Activity.activities_from_user(self)
    end

    def get_profile
      page.at_css('.profileBoxSmall img').tap do |_profile_image_tag|
        @name = _profile_image_tag['title']
        @profile_image_url = _profile_image_tag['src']
      end
    end

    def page
      @page ||= Nokogiri::HTML(open(activities_url))
    end
  end
end
