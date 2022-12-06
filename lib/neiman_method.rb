require_relative 'math_f'
include MathF
class NeimanMethod
  def generate(lambda, k, n)
    max = max_f(lambda, k)
    hash = {}
    (0..k).each{ |k| hash[k] = 0 }
    n.times do |_i|
      element = neiman_random(max, k, lambda)
      if hash.has_key?(element)
        hash[element] += 1
      else
        hash[element] = 1
      end
    end
    (0..k).each { |k| hash[k] /= n.to_f }
    hash
  end

  private

  def max_f(lambda, k)
    max = poisson_pmf(lambda, 0)
    (1..k).each do |i|
      poisson_i = poisson_pmf(lambda, i)
      max = poisson_i if poisson_i > max
    end
    max
  end

  def neiman_random(max, k, lambda)
    while true
      gamma1 = Random.new.rand(0.0..1.0)
      gamma2 = Random.new.rand(0.0..1.0)
      x = random_discrete(k, gamma1)
      y = max * gamma2
      return x if poisson_pmf(lambda, x) > y
    end
  end
end
