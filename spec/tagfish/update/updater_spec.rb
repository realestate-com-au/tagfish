require 'spec_helper'
require 'tagfish/docker_registry_client'
require 'tagfish/update/updater'
require 'tagfish/tokeniser'
require 'tagfish/tags'

module Tagfish::Update

  describe Updater do

    subject(:updater) { Updater.new(filters) }

    let(:filters) {[]}

    let(:registry_client) { double }

    before do
      allow(Tagfish::DockerRegistryClient).to receive(:for).and_return(registry_client)
      allow(registry_client).to receive(:tags).and_return(tags)
    end

    context 'when registry returns tags for yesterday and today' do

      let(:tags) {Tagfish::Tags.new({'latest' => '2', 'today' => '2', 'yesterday' => '1'})}

      describe '#update' do

        subject(:updated_tokens) {updater.update(tokens)}

        context 'with no filters' do

          context "with tokens that have yesterday's uri" do
            let(:tokens) {[Tagfish::Tokeniser::URI.new('repo:yesterday')]}
            it 'updates to todays uri' do
              expect(updated_tokens).to eq [Tagfish::Tokeniser::URI.new('repo:today')]
            end
          end

          context "with tokens that have today's uri" do
            let(:tokens) {[Tagfish::Tokeniser::URI.new('repo:today')]}
            it 'is still todays uri' do
              expect(updated_tokens).to eq [Tagfish::Tokeniser::URI.new('repo:today')]
            end
          end

          context "with tokens of just text" do
            let(:tokens) {[Tagfish::Tokeniser::Text.new('foo')]}
            it 'is the same' do
              expect(updated_tokens).to eq [Tagfish::Tokeniser::Text.new('foo')]
            end
          end

        end

        context "with tokens that have an updatable uri" do

          let(:tokens) {[Tagfish::Tokeniser::URI.new('repo:yesterday')]}

          context 'with a filter that blocks everything' do

            let(:filters) {[lambda do |_|false end]}

            it 'does not update' do
              expect(updated_tokens).to eq [Tagfish::Tokeniser::URI.new('repo:yesterday')]
            end

          end

          context 'with a filter that allows everything' do
            let(:filters) {[lambda do |_|true end]}
            it 'updates the token' do
              expect(updated_tokens).to eq [Tagfish::Tokeniser::URI.new('repo:today')]
            end
          end

          context "with a filter that allows only yesterday's tag" do
            let(:filters) {[lambda do |uri| uri.tag == 'yesterday' end]}
            it 'updates the token' do
              expect(updated_tokens).to eq [Tagfish::Tokeniser::URI.new('repo:today')]
            end
          end

        end

      end

    end

    context 'when registry returns tags and does not have latest' do

      let(:tags) {Tagfish::Tags.new({'today' => '2', 'yesterday' => '1'})}

      describe '#update' do

        subject(:updated_tokens) {updater.update(tokens)}

        context "with tokens that have yesterday's uri" do
          let(:tokens) {[Tagfish::Tokeniser::URI.new('repo:yesterday')]}
          it 'does not update uri' do
            expect(updated_tokens).to eq [Tagfish::Tokeniser::URI.new('repo:yesterday')]
          end
        end

      end

    end

  end

end
