describe Fastlane::Actions::TestappioAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The testappio plugin is working!")

      Fastlane::Actions::TestappioAction.run(nil)
    end
  end
end
