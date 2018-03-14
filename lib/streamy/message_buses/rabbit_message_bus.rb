require "hutch"

module Streamy
  module MessageBuses
    class RabbitMessageBus
      def initialize(uri:, topic_prefix: Streamy::DEFAULT_TOPIC_PREFIX)
        @topic_prefix = topic_prefix
        Hutch::Config.set(:uri, uri)
        Hutch::Config.set(:enable_http_api_use, false)
      end

      def deliver(*args)
        deliver_now(*args)
      end

      def deliver_now(key:, topic:, type:, body:, event_time:)
        Hutch.connect
        Hutch.publish(
          "#{topic_prefix}.#{topic}.#{type}",
          topic: topic,
          key: key,
          body: body,
          type: type,
          event_time: event_time
        )
      end

      private

        attr_reader :topic_prefix
    end
  end
end
