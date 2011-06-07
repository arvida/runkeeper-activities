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
      @start_time ||= (data[:points] and data[:points].any?) ? Time.parse(data[:points][0][:time]) : nil
    end

    def end_time
      @end_time ||= (data[:points] and data[:points].any?) ? Time.parse(data[:points].last[:time]) : nil
    end

    def distance
      @distance ||= data[:statsDistance]
    end

    def duration
      @duration ||= data[:statsDuration]
    end

    def pace
      @pace ||= data[:statsPace]
    end

    def speed
      @speed ||= data[:statsSpeed]
    end

    def calories
      @calories ||= data[:statsCalories]
    end

    def elevation
      @elevation ||= data[:statsElevation]
    end

    def message
      @message ||= data[:feedData][:message]
    end

    def summery
      @summery ||= "#{user.name} completed a #{distance} #{user.distance_unit} #{type.downcase} activity"
    end

    def data
      @data ||= Yajl::Parser.parse(raw_json_data, :symbolize_keys => true)
    end

    def json_endpoint
      @json_endpoint ||= Utils.runkeeper_url("/ajax/pointData?activityId=#{id}")
    end

    def raw_json_data
      @raw_json_data ||= open(json_endpoint).readlines.join("\n").encode('UTF-8')
    end
  end
end
