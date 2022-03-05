require 'fastlane/action'
require_relative '../helper/testappio_helper'

module Fastlane
  module Actions
    class TestappioAction < Action
      def self.run(params)
        UI.message("The testappio plugin is working!")
        UI.message("Thanks for using testappio " + params[:name])
      end

      def self.description
        "Plugin to use for testappio"
      end

      def self.authors
        ["Abrar Mohammed"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "Plugin for testappio"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :name,
                                  env_name: "TESTAPPIO_NAME",
                               description: "A description of your option",
                                  optional: false,
                                      type: String)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
