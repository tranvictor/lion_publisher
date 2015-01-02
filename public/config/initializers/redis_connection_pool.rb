require 'singleton'
require 'redis'

class RedisConnectionPool
  include Singleton

  def initialize
    @pool = ConnectionPool.new(size: 100, timeout: 2) do
      Redis.new
    end
  end

  def with(&block)
    @pool.with(&block)
  end
end
