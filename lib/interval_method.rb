require_relative 'math_f'
include MathF
class IntervalMethod
  def generate(lambda, k, n)
    hash = {}
    (0..k).each { |i| hash[i] = 0 }

    n.times do |_i|
      g = Random.new.rand(0.0..1.0)
      (0..k).each do |j|
        hash[j] += 1 if g < poisson_pmf(lambda, j)
      end
    end
    hash.each { |k,v| hash[k] = v / n.to_f }
  end
end
