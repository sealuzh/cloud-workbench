# Add deep_merge method to Hash. Code based on: http://stackoverflow.com/a/9381776
class ::Hash
  def deep_merge!(second)
    result = deep_merge(second)
    self.replace(result)
  end

  def deep_merge(second)
    merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
    self.merge(second, &merger)
  end
end
