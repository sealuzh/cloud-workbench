require 'spec_helper'

describe 'String extension' do

  describe 'to_bool' do

    describe 'with true values' do
      true_values = %w(true True t 1)
      true_values.each do |true_value|
        it "should recognize the true value '#{true_value}'" do
          expect(true_value.to_bool).to be_truthy
        end
      end
    end

    describe 'with false values' do
      false_values = %w(false False f 0)
      false_values.each do |false_value|
        it "should recognize the false value '#{false_value}'" do
          expect(false_value.to_bool).to be_falsey
        end
      end
    end
  end
end