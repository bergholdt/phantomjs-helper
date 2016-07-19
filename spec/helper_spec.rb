require 'spec_helper'

describe Phantomjs::Helper do
  let(:helper) { Phantomjs::Helper.new }

  describe '#binary_path' do
    context 'on 32bit platform' do
      before { allow(helper).to receive(:platform) { 'windows' } }
      it { expect(helper.binary_path).to match(/\.phantomjs-helper\/windows\/phantomjs.exe$/) }
    end

    context 'on x64 platform' do
      before { allow(helper).to receive(:platform) { 'macosx' } }
      it { expect(helper.binary_path).to match(/\.phantomjs-helper\/macosx\/phantomjs$/) }
    end
  end
end
