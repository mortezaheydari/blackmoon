require "spec_helper"

describe ModelMailer do
  describe "new_invitation_notification" do
    let(:mail) { ModelMailer.new_invitation_notification }

    it "renders the headers" do
      mail.subject.should eq("New invitation notification")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
