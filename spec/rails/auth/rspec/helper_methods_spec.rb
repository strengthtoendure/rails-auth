RSpec.describe Rails::Auth::RSpec::HelperMethods, acl_spec: true do
  let(:example_cn) { "127.0.0.1" }
  let(:example_ou) { "ponycopter" }

  describe "#x509_principal" do
    subject { x509_principal(cn: example_cn, ou: example_ou) }

    it "creates instance doubles for Rails::Auth::X509::Principals" do
      # Method syntax
      expect(subject.cn).to eq example_cn
      expect(subject.ou).to eq example_ou

      # Hash-like syntax
      expect(subject[:cn]).to eq example_cn
      expect(subject[:ou]).to eq example_ou
    end
  end

  describe "#x509_principal_hash" do
    subject { x509_principal_hash(cn: example_cn, ou: example_ou) }

    it "creates a principal hash with an Rails::Auth::X509::Principal double" do
      expect(subject["x509"].cn).to eq example_cn
    end
  end

  Rails::Auth::ACL::Resource::HTTP_METHODS.each do |method|
    describe "##{method.downcase}_request" do
      it "returns a Rack environment" do
        # These methods introspect self.class.description to find the path
        allow(self.class).to receive(:description).and_return("/")
        env = method("#{method.downcase}_request").call

        expect(env["REQUEST_METHOD"]).to eq method
      end

      it "raises ArgumentError if the description doesn't start with /" do
        expect { method("#{method.downcase}_request").call }.to raise_error(ArgumentError)
      end
    end
  end
end
