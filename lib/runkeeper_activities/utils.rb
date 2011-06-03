module RunKeeperActivities
  module Utils
    class << self
      def runkeeper_url(path)
        "http://runkeeper.com#{path}"
      end
    end
  end
end
