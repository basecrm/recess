module Recess
  class Timeouts
    DEFAULT_TIMEOUT = 3
    DEFAULT_ATTEMPTS = 0

    def self.with_hard_timeout(max_attempts = DEFAULT_ATTEMPTS, timeout = DEFAULT_TIMEOUT, &block)
      self.with_scoped_timeout(Recess::HardTimeoutError, max_attempts, timeout, &block)
    end

    def self.with_timeout(max_attempts = DEFAULT_ATTEMPTS, timeout = DEFAULT_TIMEOUT, &block)
      self.with_scoped_timeout(Recess::TimeoutError, max_attempts, timeout, &block)
    end

    private

    def self.with_scoped_timeout(error_klass, max_attempts, timeout, &block)
      attempts ||= max_attempts
      Timeout.timeout timeout, error_klass do
        yield
      end
    rescue error_klass => e
      if attempts > 0
        attempts -= 1
        retry
      else
        raise
      end
    end
  end
end
