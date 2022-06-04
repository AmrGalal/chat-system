class RedisHandler
    def incr_key(redis_key)
        $redis.watch(redis_key)
        new_number = $redis.incr(redis_key)
        $redis.unwatch()
        return new_number
    end
end
