describe Fastlane::Actions::UploadToTestappioAction do
  describe '#run' do
    it 'upload an apk file' do
      expect do
        Fastlane::FastFile.new.parse("lane :test do
          # upload both
          upload_to_testappio(
            api_token: '580dddfba-2b98-4b5c-937c-fc2382f54b1a',
            app_id: 'zmyozV25M',
            release: 'both',
            apk_file: './fastlane/sample/sample-app.apk',
            ipa_file: './fastlane/sample/sample-app.ipa',
            release_notes: 'For test only',
            notify: 'false'
          )
        end").runner.execute(:test)
      end.to raise_error(anything)
    end
  end
end
