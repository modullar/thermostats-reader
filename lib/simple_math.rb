module SimpleMath

  extend ActiveSupport::Concern

  def avg(arr)
    arr.inject{ |sum, el| sum + el }.to_f / arr.size
  end

  # incremental avg formula: https://ubuntuincident.wordpress.com/2012/04/25/calculating-the-average-incrementally/
  def incremental_avg(avg, arr, n)
    m = arr.size
    avg + ((arr.sum - (m * avg)) / (n + m))
  end
end
