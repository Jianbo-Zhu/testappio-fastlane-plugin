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
        apk_file = params[:apk_file]
        ipa_file = params[:ipa_file]
        release = params[:release]
        release_notes = params[:release_notes]
        git_release_notes = params[:git_release_notes]
        git_commit_id = params[:git_commit_id]
        notify = params[:notify]

        
        validate_file_path(apk_file)
        validate_file_path(ipa_file)

        command = ["ta-cli"]
        command.push("publish")
        command.push("--api_token=#{api_token}")
        command.push("--app_id=#{app_id}")
        command.push("--release=#{release}")
        command.push("--apk=#{apk_file}") unless release == "ios"
        command.push("--ipa=#{ipa_file}") unless release == "android"
        command.push("--release_notes=#{release_notes}")
        command.push("--git_release_notes=#{git_release_notes}")
        command.push("--git_commit_id=#{git_commit_id}")
        command.push("--notify=#{notify}")
        command.push("--source=Fastlane")

        UI.message "Uploading to testapp.io"
        require 'open3'
        if FastlaneCore::Globals.verbose?
          UI.verbose("ta-cli command:\n\n")
          UI.command(command.to_s)
          UI.verbose("\n\n")
        end
        final_command = command.map { |arg| Shellwords.escape(arg) }.join(" ")
        out = []
        error = []
        Open3.popen3(final_command) do |stdin, stdout, stderr, wait_thr|
          while (line = stdout.gets)
            out << line
            UI.message(line.strip!)
          end
          while (line = stderr.gets)
            error << line.strip!
          end
          exit_status = wait_thr.value
          unless exit_status.success? && error.empty?
            Helper::TestappioHelper.handle_error(error)
          end
        end
        UI.success("Successfully uploaded to TestAppIO!")

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
        "Official fastlane plugin for TestApp.io."
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
        "This Fastlane plugin uploads your Android (APK) and iOS (IPA) package to TestApp.io and notify your team members about the new releases if you enable it."
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
                                       env_name: "FL_UPLOAD_TO_TESTAPPIO_APP_ID",
                                       description: "You can get it from your app page in https://portal.testapp.io/apps",
                                       is_string: false), # true: verifies the input is a string, false: every kind of value
          FastlaneCore::ConfigItem.new(key: :release,
                                       env_name: "FL_UPLOAD_TO_TESTAPPIO_RELEASE",
                                       description: "It can be either both or android or ios",
                                       is_string: true,
                                      default_value: Actions.lane_context[Actions::SharedValues::PLATFORM_NAME]), # true: verifies the input is a string, false: every kind of value
          FastlaneCore::ConfigItem.new(key: :apk_file,
                                      description: "Path to the android apk file",
                                      optional: true,
                                      is_string: true,
                                      default_value: default_file_path),# the default value if the user didn't provide one                              
          FastlaneCore::ConfigItem.new(key: :ipa_file,
                                      description: "Path to the ios ipa file",
                                      optional: true,
                                      is_string: true,
                                      default_value: default_file_path),# the default value if the user didn't provide one                              
          FastlaneCore::ConfigItem.new(key: :release_notes,
                                      description: "Manually add the release notes to be displayed for the testers",
                                      optional: true,
                                      is_string: true),# the default value if the user didn't provide one                              
          FastlaneCore::ConfigItem.new(key: :git_release_notes,
                                      description: "Collect release notes from the latest git commit message to be displayed for the testers: true or false",
                                      optional: true,
                                      is_string: false,
                                      default_value: true),# the default value if the user didn't provide one
          FastlaneCore::ConfigItem.new(key: :git_commit_id,
                                      description: "Include the last commit ID in the release notes (works with both release notes option): true or false",
                                      optional: true,
                                      is_string: false,
                                      default_value: false),# the default value if the user didn't provide one
          FastlaneCore::ConfigItem.new(key: :notify,
                                      description: "Send notificaitons to your team members about this release: true or false",
                                      optional: true,
                                      is_string: false,
                                      default_value: false),# the default value if the user didn't provide one
          ]
      end

      def self.output
        nil
      end

      def self.return_value
        nill
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["Jianbo Zhu"]
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
        [:ios, :android].include?(platform)
        # platform == :ios
      end
    end
  end
end
