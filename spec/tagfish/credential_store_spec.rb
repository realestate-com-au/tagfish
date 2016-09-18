require 'spec_helper'

require 'base64'
require 'tagfish/credential_store'
require 'tagfish/registry_credentials'

describe Tagfish::CredentialStore do

  subject(:cred_store) do
    Tagfish::CredentialStore.new(stored_credentials)
  end

  let(:stored_credentials) do
    {}
  end

  def b64_creds(username, password)
    plaintext = [username, password].join(":")
    Base64.encode64(plaintext)
  end

  context "when there are no credentials saved" do

    describe "#credentials_for" do

      context "any registry" do
        it "returns nil" do
          expect(cred_store.credentials_for("any.rego")).to be_nil
        end
      end

    end

  end

  context "with credentials saved for my.registry" do

    let(:stored_credentials) do
      {
	"auths" => {
		"my.registry" => {
			"auth" => b64_creds("UUU", "PPP")
		}
        }
      }
    end

    describe "#credentials_for" do

      context "my.registry" do
        it "returns the stored credentials" do
          expected_credentials = Tagfish::RegistryCredentials.new("UUU", "PPP")
          expect(cred_store.credentials_for("my.registry")).to eq(expected_credentials)
        end
      end

    end

  end

end
