require "rails_helper"
require 'simple_math'

class DummyClass
  include SimpleMath
end

RSpec.describe SimpleMath do
  let(:dc) { DummyClass.new }
  let(:arr){ [1,2,3,4] }

  describe '.avg' do
    it 'shoulr returns the average of an array' do
      expect(dc.avg(arr)).to eq 2.5
    end
  end

  describe '.incremental_avg' do
    let(:extra_arr){ [5,6,7] }

    it 'should return the incremental average' do
      n = arr.size
      avg = dc.avg(arr)
      expect(dc.incremental_avg(avg, extra_arr, n)).to eq 4
    end
  end
end
