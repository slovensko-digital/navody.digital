require 'rails_helper'

describe Enums do
  class TestClass
    include Enums

    class << self
      attr_reader :enum_definition

      def enum(enum_definition)
        @enum_definition = enum_definition
      end
    end


    enumerates :status, with: %w{IDLE WORKING FINISHED}
  end

  subject do
    TestClass.new
  end

  it 'should define enum' do
    expect(subject.class.enum_definition).to eq({
        status: {
            'IDLE' => 'IDLE',
            'WORKING' => 'WORKING',
            'FINISHED' => 'FINISHED',
        }
    })
  end
end
