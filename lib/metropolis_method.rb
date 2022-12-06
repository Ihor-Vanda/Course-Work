require_relative 'math_f'
include MathF
class MetropolisMethod
  def generate(lambda, k, n)
    hash = {}
    (0..k).each { |i| hash[i] = 0}
    element = random_discrete(k, Random.new.rand(0.0..1.0))
    n.times do |i|
      element = calculate(lambda, k, element)
      if hash.has_key?(element)
        hash[element] += 1
      else
        hash[element] = 1
      end
    end
    hash.each { |k, v| hash[k] = v / n.to_f }
  end

  def calculate(lambda,right_boundary, previous_x)
    gamma1 = random_discrete(right_boundary,Random.new.rand(0.0..1.0))
    gamma2 = random_discrete(right_boundary,Random.new.rand(0.0..1.0))
    delta = ((1.0/3.0) * right_boundary)
    x1 = previous_x + (delta * (-1.0 + 2.0 * gamma1)).floor

    if x1 < 0 || x1 > right_boundary
      return previous_x
    end

    previous_x_calculation = poisson_pmf(lambda,previous_x)
    alpha = poisson_pmf(lambda,x1) / previous_x_calculation

    if alpha >= 1.0 || alpha > gamma2
      return x1
    end

    previous_x
  end
end
