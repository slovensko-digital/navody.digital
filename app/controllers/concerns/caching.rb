module Caching
  extend ActiveSupport::Concern

  included do
    def save_to_cache(args)
      raise ArgumentError unless args.is_a? Hash

      init_cache
      args.each_pair { |key, data| cache.write([uuid, key.to_sym], data, expires_in: 24.hours) }
    end

    def load_from_cache(*keys)
      return load_one(keys.first) if keys.length == 1

      keys.each_with_object({}) { |key, hash| hash[key] = load_one(key) }.compact
    end

    private

    def init_cache
      session[:user_uuid] = SecureRandom.uuid
    end

    def load_one(key)
      cache.read([uuid, key.to_sym])
    end

    def uuid
      raise 'Cache session data missing' unless session[:user_uuid]

      session[:user_uuid]
    end

    def cache
      Rails.cache
    end
  end
end
