require_relative '../../../lib/sprockets/commonjs'

module Sprockets
  describe CommonJS do

    let(:instance) { described_class.new {} }

    describe '#module_name' do
      let(:scope) { double(:scope, logical_path: logical_path) }
      subject     { instance.send(:module_name, scope) }

      context 'with "app"' do
        let(:logical_path) { 'app' }
        it { is_expected.to eq 'app' }
      end

      context 'with "./app"' do
        let(:logical_path) { './app' }
        it { is_expected.to eq 'app' }
      end

      context 'with "./one/two"' do
        let(:logical_path) { './one/two' }
        it { is_expected.to eq 'one/two' }
      end

      context 'with "/one/two"' do
        let(:logical_path) { '/one/two' }
        it { is_expected.to eq 'one/two' }
      end

      context 'with "one/two/_bla"' do
        let(:logical_path) { '/one/two/_bla' }
        it { is_expected.to eq 'one/two/bla' }
      end

      context 'with "one/two/_index"' do
        let(:logical_path) { '/one/two/_index' }
        it { is_expected.to eq 'one/two' }
      end

      context 'with "one/two/index"' do
        let(:logical_path) { '/one/two/index' }
        it { is_expected.to eq 'one/two' }
      end
    end
  end
end
