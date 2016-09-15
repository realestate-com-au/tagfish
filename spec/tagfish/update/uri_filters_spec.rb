require 'spec_helper'
require 'tagfish/update/uri_filters'
require 'tagfish/docker_uri'

module Tagfish::Update
  describe URIFilters do
    describe '.must_be_tagged' do
      context 'when tested against uri' do
        subject { URIFilters.must_be_tagged[uri] }
        context 'that was tagged' do
          let (:uri) {Tagfish::DockerURI.new(nil, nil, nil, 'tag') }
          it { is_expected.to be true }
        end
        context 'that was not tagged' do
          let (:uri) {Tagfish::DockerURI.new(nil, nil, nil, nil) }
          it { is_expected.to be false }
        end
      end
    end

    describe '.must_not_be_tagged_latest' do
      context 'when tested against uri' do
        subject { URIFilters.must_not_be_tagged_latest[uri] }
        context 'that was tagged latest' do
          let (:uri) {Tagfish::DockerURI.new(nil, nil, nil, 'latest') }
          it { is_expected.to be false }
        end
        context 'that was tagged something' do
          let (:uri) {Tagfish::DockerURI.new(nil, nil, nil, 'something') }
          it { is_expected.to be true }
        end
      end
    end
    
    describe '.must_match_repository' do
      context 'when tested against uri' do
        subject { URIFilters.must_match_repository(pattern)[uri] }

        context 'with a full docker uri specified' do
          let(:uri) {Tagfish::DockerURI.new(nil, 'realestate.com.au', 'gpde', 'tag') }

          context 'with pattern matching no part of the uri' do
            let(:pattern) {'elvis'}
            it { is_expected.to be false }
          end

          context 'with pattern matching tag' do
            let(:pattern) {'tag'}
            it { is_expected.to be false }
          end

          context 'with pattern matching registry name and partial repository' do
            let(:pattern) {'realestate.com.au/gp'}
            it { is_expected.to be true }
          end

          context 'with pattern matching registry name and repository' do
            let(:pattern) {'realestate.com.au/gpde'}
            it { is_expected.to be true }
          end

          context 'with pattern matching registry name' do
            let(:pattern) {'realestate.com.au'}
            it { is_expected.to be true }
          end

          context 'with pattern using wildcard for subdomains of registry tld' do
            let(:pattern) {'*.com.au'}
            it { is_expected.to be true }
          end

          context 'with pattern containing only latter part of registry name' do
            let(:pattern) {'com.au/gp'}
            it { is_expected.to be false }
          end
        end
      end
    end
  end
end
