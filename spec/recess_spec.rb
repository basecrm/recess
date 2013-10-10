require "rubygems"
require "bundler/setup"
require "recess"
require "spec_helper"

describe Recess::Timeouts do
  let(:timeout) { 0.1 }
  let(:attempts) { 0 }

  describe '.with_timeout' do
    subject { described_class.with_timeout(attempts, timeout, &action) }
    before { RecessTest::Performer.should_receive(:perform).exactly(attempts + 1).times }

    context 'normal operation' do
      let(:action) { lambda { RecessTest::Performer.perform } }

      it 'invokes the timeout with the Timeout error' do
        Timeout.should_receive(:timeout).with(timeout, Recess::TimeoutError).and_yield
        subject
      end
    end

    context 'timing out' do
      let(:action) { lambda { RecessTest::Performer.slow_perform } }
      let(:timeout) { 0.005 }

      it 'raises a timeout error when it times out' do
        expect { subject }.to raise_error(Recess::TimeoutError)
      end

      context 'multiple attempts' do
        let(:attempts) { 2 }

        it 'tries twice before raising a timeout error' do
          expect { subject }.to raise_error(Recess::TimeoutError)
        end
      end
    end
  end

  describe '.with_hard_timeout' do
    context 'no nested timeouts' do
      subject { described_class.with_hard_timeout(attempts, timeout, &action) }
      before { RecessTest::Performer.should_receive(:perform).exactly(attempts + 1).times }

      context 'normal operation' do
        let(:action) { lambda { RecessTest::Performer.perform } }

        it 'invokes the timeout with the HardTimeout error' do
          Timeout.should_receive(:timeout).with(timeout, Recess::HardTimeoutError).and_yield
          subject
        end
      end

      context 'timing out' do
        let(:action) { lambda { RecessTest::Performer.slow_perform } }
        let(:timeout) { 0.005 }

        it 'raises a timeout error when it times out' do
          expect { subject }.to raise_error(Recess::HardTimeoutError)
        end

        context 'multiple attempts' do
          let(:attempts) { 2 }

          it 'tries twice before raising a timeout error' do
            expect { subject }.to raise_error(Recess::HardTimeoutError)
          end
        end
      end
    end

    context 'with nested_timeouts' do
      subject { described_class.with_hard_timeout(attempts, timeout, &action) }
      let(:nested_timeout) { 0.07 }

      let(:action) do
        lambda {
          Recess::Timeouts.with_timeout(nested_attempts, nested_timeout) do
            RecessTest::Performer.slow_perform
          end
        }
      end

      context 'slow timeout' do
        let(:nested_attempts) { 1 }
        let(:timeout) { 2 }

        it 'throws a TimeoutError after trying once within the nested block' do
          RecessTest::Performer.should_receive(:perform).twice
          expect { subject }.to raise_error(Recess::TimeoutError)
        end
      end

      context 'hard timeout' do
        let(:nested_attempts) { 4 }

        it 'throws a HardTimeoutError after trying twice within the nested block' do
          RecessTest::Performer.should_receive(:perform).exactly(2).times
          expect { subject }.to raise_error(Recess::HardTimeoutError)
        end
      end
    end
  end
end
