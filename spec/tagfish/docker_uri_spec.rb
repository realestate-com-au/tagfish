require 'spec_helper'
require 'tagfish/docker_uri'

module Tagfish
  describe DockerURI do
    describe '.parse' do
      subject {DockerURI.parse(input)}
      context 'a docker string' do
        let(:input) do "#{protocol}#{registry}#{repository}#{tag}" end
        let(:protocol) do nil end
        let(:registry) do nil end
        let(:repository) do "ubuntu" end
        let(:tag) do nil end

        context 'with the protocol http' do
          let(:input) { "http://some.rego/repo" }
          it 'creates a uri with protocol http' do
            expect(subject.protocol).to eq "http://"
          end
        end

        context 'with protocol is https' do
          let(:protocol) do "https://" end
          it 'creates a uri with protocol https' do
            expect(subject.protocol).to eq "https://"
          end
        end

        context 'when protocol is missing' do
          let(:protocol) do nil end
          it 'defaults to https' do
            expect(subject.protocol).to eq "https://"
          end
        end

        context "with registry is CBDE docker registry" do
          let(:registry) do "docker-registry.delivery.realestate.com.au/" end
          it 'creates a uri with registry being the CBDE docker registry' do
            expect(subject.registry).to eq "docker-registry.delivery.realestate.com.au"
          end
        end

        context "without a registry" do
          let(:registry) do nil end
          it 'defaults to Docker Hub' do
            expect(subject.registry).to eq("index.docker.io")
          end
        end

        context "with repository that doesn't have an organisation" do
          let(:repository) do "ubuntu" end
          it "creates a uri with the same repository" do
            expect(subject.repository).to eq "ubuntu"
          end
        end

        context "with repository that has an organisation" do
          let(:repository) do "gpde/ubuntu-ruby2.2" end
          it "creates a uri with the same repository" do
            expect(subject.repository).to eq "gpde/ubuntu-ruby2.2"
          end
        end

        context "without a tag" do
          let(:tag) do nil end
          it "creates a uri without a tag" do
            expect(subject.tag).to be nil
          end
        end

        context "with a tag" do
          let(:tag) do ":latestv1-2.3" end
          it "creates a uri with a tag" do
            expect(subject.tag).to eq "latestv1-2.3"
          end
        end

      end
    end

    describe '#tag?' do
      subject { DockerURI.new(nil, nil, nil, tag).tag? }
      context 'when tag is present' do
        let(:tag) {'tag'}
        it 'returns true' do
          is_expected.to eq true
        end
      end
      context 'when tag is missing' do
        let(:tag) {nil}
        it 'returns false' do
          is_expected.to eq false
        end
      end
    end
    describe '#tagged_latest?' do
      subject { DockerURI.new(nil, nil, nil, tag).tagged_latest? }
      context 'when tag is latest' do
        let(:tag) {'latest'}
        it 'returns true' do
          is_expected.to eq true
        end
      end
      context 'when tag is not latest' do
        let(:tag) {'trusty'}
        it 'returns false' do
          is_expected.to eq false
        end
      end
    end
  end
end
