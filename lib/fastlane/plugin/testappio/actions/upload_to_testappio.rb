module Fastlane
  module Actions
    module SharedValues
      UPLOAD_TO_TESTAPPIO_CUSTOM_VALUE = :UPLOAD_TO_TESTAPPIO_CUSTOM_VALUE
    end

    class UploadToTestappioAction < Action
      SUPPORTED_FILE_EXTENSIONS = ["apk", "ipa"]
      def self.run(params)

        # Check if ta-cli is installed
        Helper::TestappioHelper.check_ta_cli


        # fastlane will take care of reading in the parameter and fetching the environment variable:
        api_token = params[:api_token]
        app_id = params[:app_id]
        file_path = params[:file_path].to_s

        validate_file_path(file_path)

        UI.message "Uploading to testapp.io"

        # sh "shellcommand ./path"

        # Actions.lane_context[SharedValues::UPLOAD_TO_TESTAPPIO_CUSTOM_VALUE] = "my_val"
      end

      # Validate file_path.
      def self.validate_file_path(file_path)
        UI.user_error!("No file found at '#{file_path}'.") unless File.exist?(file_path)

        # Validate file extension.
        file_path_parts = file_path.split(".")
        unless file_path_parts.length > 1 && SUPPORTED_FILE_EXTENSIONS.include?(file_path_parts.last)
          UI.user_error!("file_path is invalid, only files with extensions " + SUPPORTED_FILE_EXTENSIONS.to_s + " are allowed to be uploaded.")
        end
      end

      def self.description
        "A short description with <= 80 characters of what this action does"
      end

      def self.default_file_path
        platform = Actions.lane_context[Actions::SharedValues::PLATFORM_NAME]
        if platform == :ios
          # Shared value for ipa path if it was generated by gym https://docs.fastlane.tools/actions/gym/.
          return Actions.lane_context[Actions::SharedValues::IPA_OUTPUT_PATH]
        else
          # Shared value for apk if it was generated by gradle.
          return Actions.lane_context[Actions::SharedValues::GRADLE_APK_OUTPUT_PATH]
        end
      end
      
      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        "You can use this action to do cool things..."
      end

      def self.available_options
        # Define all options your action supports.

        # Below a few examples
        [
          FastlaneCore::ConfigItem.new(key: :api_token,
                                       env_name: "FL_UPLOAD_TO_TESTAPPIO_API_TOKEN", # The name of the environment variable
                                       description: "API Token for UploadToTestappioAction", # a short description of this parameter
                                       verify_block: proc do |value|
                                          UI.user_error!("No API token for UploadToTestappioAction given, pass using `api_token: 'token'`") unless (value and not value.empty?)
                                          # UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
                                       end),
          FastlaneCore::ConfigItem.new(key: :app_id,
                                       env_name: "FL_UPLOAD_TO_TESTAPPIO_DEVELOPMENT",
                                       description: "Create a development certificate instead of a distribution one",
                                       is_string: false, # true: verifies the input is a string, false: every kind of value
                                       default_value: false), # the default value if the user didn't provide one
          FastlaneCore::ConfigItem.new(key: :file_path,
                                      description: "Path to the app file",
                                      optional: true,
                                      is_string: true,
                                      default_value: default_file_path)# the default value if the user didn't provide one                              
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['UPLOAD_TO_TESTAPPIO_CUSTOM_VALUE', 'A description of what this value contains']
        ]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["Your GitHub/Twitter Name"]
      end

      def self.is_supported?(platform)
        # you can do things like
        #
        #  true
        #
        #  platform == :ios
        #
        #  [:ios, :mac].include?(platform)
        #

        platform == :ios
      end
    end
  end
end
