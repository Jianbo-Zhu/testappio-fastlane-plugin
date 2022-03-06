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

      def self.handle_error(errors)
        fatal = false
        for error in errors do
          if error
            if error =~ /Error/
              UI.error(error.to_s)
              fatal = true
            else
              UI.verbose(error.to_s)
            end
          end
        end
        UI.user_error!('Error while calling ta-cli') if fatal
      end
    end
  end
end
