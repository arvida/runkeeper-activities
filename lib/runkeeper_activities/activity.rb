module RunKeeperActivities
  class Activity
    attr_reader :user,
                :url,
                :type

    class << self
      def activities_from_user(user)
        user.page.css('#activityHistoryMenu .menuItem').collect do |_feed_item|
          RunKeeperActivities::Activity.new({
            :user => user,
            :url => Utils.runkeeper_url(_feed_item['link']),
            :distance => _feed_item.at_css('.distance').text,
            :type => _feed_item.at_css('.mainText').text
          })
        end
      end
    end

    def initialize(options = {})
      options.each { |k,v| instance_variable_set("@#{k}".to_sym, v) }
    end

    def id
      @id ||= (_match = @url.match(/\/(\d+)$/)) ? _match[1] : (raise "Need profile url to find user id")
    end

    def start_time
      @start_time ||= (raw_data[:points] and raw_data[:points].any?) ? Time.parse(raw_data[:points][0][:time]) : nil
    end

    def end_time
      @end_time ||= (raw_data[:points] and raw_data[:points].any?) ? Time.parse(raw_data[:points].last[:time]) : nil
    end

    def distance
      @distance ||= raw_data[:statsDistance]
    end

    def duration
      @duration ||= raw_data[:statsDuration]
    end

    def pace
      @pace ||= raw_data[:statsPace]
    end

    def speed
      @speed ||= raw_data[:statsSpeed]
    end

    def calories
      @calories ||= raw_data[:statsCalories]
    end

    def elevation
      @elevation ||= raw_data[:statsElevation]
    end

    def summery
      @summery ||= "#{user.name} completed a #{distance} #{user.distance_unit} #{type.downcase} activity"
    end

    def json_endpoint
      @json_endpoint ||= Utils.runkeeper_url("/ajax/pointData?activityId=#{id}")
    end

    def raw_data
      @raw_data ||= {}.tap do |_raw_data|
        Yajl::HttpStream.get(json_endpoint, :symbolize_keys => true) do |_data|
          _raw_data.merge!(_data)
        end
      end
    end
  end
end
