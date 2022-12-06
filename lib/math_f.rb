module MathF
  def factorial(n)
    return 1 if n == 1 || n == 0

    factorial(n - 1) * n
  end

  def poisson_pmf(lambda, k)
    (Math.exp(-lambda) * (lambda**k)) / factorial(k)
  end

  def get_pmf_distribution(lambda, k)
    hash = {}
    (0..k).each do |i|
      hash[i] = poisson_pmf(lambda, i)
    end
    hash
  end
  def random_discrete(k, gamma)
    prob = 1.0 / (k + 1)
    value = 0
    (1..k).each do |i|
      return value if gamma < (prob * i)

      value += 1
    end
    value
  end

  def get_expected_value_theory(lambda)
    lambda
  end

  def get_expected_value(hash)
    expected_value = 0.0
    (0...hash.length).each { |i| expected_value += i * hash[i]  }
    expected_value
  end

  def get_dispersion_theory(lambda)
    lambda
  end

  def get_dispersion(hash, expected_value)
    dispersion = 0.0
    (0...hash.length).each { |i| dispersion += hash[i] * (i - expected_value)**2 }
    dispersion
  end

  def get_mode_theory(lambda)
    lambda.floor if lambda.is_a? Float
  end

  def get_mode(hash)
    moda = 0
    max_value = hash[0]
    (1...hash.length).each do |i|
      if max_value < hash[i]
        moda = i
        max_value = hash[i]
      end
    end
    moda
  end
end
