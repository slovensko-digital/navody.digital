require 'rails_helper'

describe Enums do
  class TestClass
    include Enums

    class << self
      attr_reader :enum_definition

      def enum(name, values)
        @enum_definition = [name, values]
      end
    end

    enumerates :status, with: %w{IDLE WORKING FINISHED}
  end

  subject do
    TestClass.new
  end

  it 'defines enum' do
    expect(subject.class.enum_definition).to eq([:status, {
      'IDLE' => 'IDLE',
      'WORKING' => 'WORKING',
      'FINISHED' => 'FINISHED',
    }])
  end
end
