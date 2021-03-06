# frozen_string_literal: true

module Rack
  module BlastWave::Utilities::Cache::Adapters
    # @api private
    # @since 0.1.0
    class Dalli < Basic
      class << self
        # @param driver [Object]
        # @return [Boolean]
        #
        # @api private
        # @since 0.1.0
        def supported_driver?(driver)
          defined?(::Dalli::Client) && driver.is_a?(::Dalli::Client)
        end
      end

      # @return [Integer]
      #
      # @api private
      # @since 0.1.0
      NO_EXPIRATION_TTL = 0

      # @return [Integer]
      #
      # @api private
      # @since 0.1.0
      DEFAULT_INCR_DECR_AMOUNT = 1

      # @return [Integer]
      #
      # @api private
      # @since 0.1.0
      MIN_DECRESEAD_VAL = 0

      # @since 0.1.0
      def_delegators :driver,
                     :get,
                     :set,
                     :incr,
                     :decr,
                     :multi,
                     :touch,
                     :flush

      # @param key [String]
      # @param options [Hash]
      # @return [Object]
      #
      # @api private
      # @since 0.1.0
      def read(key, **options)
        get(key)
      end

      def write(key, value, **options)
        expires_in = options.fetch(:expires_in, NO_EXPIRATION_TTL)

        set(key, value, expires_in, raw: true)
      end

      # @param key [String]
      # @param options [Hash]
      # @return [void]
      #
      # @api private
      # @since 0.1.0
      def delete(key, **options)
        driver.delete(key)
      end

      # @param key [String]
      # @param amount [Integer]
      # @option expires_in [NilClass, Integer]
      # @return [NilClass, Integer]
      #
      # @api private
      # @since 0.1.0
      def increment(key, amount = DEFAULT_INCR_DECR_AMOUNT, **options)
        expires_in = options.fetch(:expires_in, NO_EXPIRATION_TTL)

        # TODO: think about #cas and Concurrent::ReentrantReadWriteLock
        incr(key, amount, expires_in, amount).tap do |new_amount|
          touch(key, expires_in) if new_amount && expires_in.positive?
        end
      end

      # @param key [String]
      # @param amount [Integer]
      # @option expires_in [NilClass, Integer]
      # @return [NilClass, Integer]
      #
      # @api private
      # @since 0.1.0
      def decrement(key, amount = DEFAULT_INCR_DECR_AMOUNT, **options)
        expires_in = options.fetch(:expires_in, NO_EXPIRATION_TTL)

        # TODO: think about #cas and Concurrent::ReentrantReadWriteLock
        decr(key, amount, expires_in, MIN_DECRESEAD_VAL).tap do |new_amount|
          touch(key, expires_in) if new_amount && expires_in.positive?
        end
      end

      # @param key [String]
      # @option expires_in [Integer]
      # @return [void]
      #
      # @api private
      # @since 0.1.0
      def re_expire(key, expires_in: NO_EXPIRATION_TTL)
        touch(key, expires_in)
      end

      # @param options [Hash]
      # @return [void]
      #
      # @api private
      # @since 0.1.0
      def clear(**options)
        flush(0) # NOTE: 0 is a flush delay
      end
    end
  end
end
