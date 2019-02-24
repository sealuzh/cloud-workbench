module TimeDiff
  module Matchers
    def remain_over_time
      RemainOverTime.new
    end

    def increase_over_time
      IncreaseOverTime.new
    end

    class RemainOverTime
      def matches?(block)
        @duration1 = block.call
        @duration2 = block.call
        @duration2.eql?(@duration1)
      end

      def failure_message
        compare_message(@duration1, @duration2, 'to be the same as')
      end

      def failure_message_when_negated
        compare_message(@duration1, @duration2, 'to differ from')
      end

      def description
        'check whether the result of two consecutive calls remains the same over time'
      end

      def supports_block_expectations?
        true
      end
    end

    class IncreaseOverTime
      def matches?(block)
        @duration1 = block.call
        @duration2 = block.call
        @duration2 > @duration1
      end

      def failure_message
        compare_message(@duration1, @duration2, 'to be greater than')
      end

      def failure_message_when_negated
        compare_message(@duration1, @duration2, 'to be less or equal than')
      end

      def description
        'check whether the result of two consecutive calls increases over time'
      end

      def supports_block_expectations?
        true
      end
    end

  private

    def compare_message(first, second, comparison)
      "expected the result of the first call #{comparison} the result of the second call\n      first: #{first}\n     second: #{second}"
    end
  end
end
