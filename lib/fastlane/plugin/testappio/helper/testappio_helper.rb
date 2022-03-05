require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class TestappioHelper
      # class methods that you define here become available in your action
      # as `Helper::TestappioHelper.your_method`
      #
      def self.check_ta_cli
        unless `which ta-cli`.include?('ta-cli')
          UI.error("ta-cli not found, installing")
          UI.command(`curl -Ls https://github.com/Massad/cli/releases/latest/download/install | bash`)
        end
      end
    end
  end
end
