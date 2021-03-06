require File.expand_path("../helper", __FILE__)

class InitializationTest < ModelIterator::TestCase
  def setup
    @iter = ModelIterator.new(Model, :redis => RedisClient.new)
  end

  def test_sets_klass
    assert_equal Model, @iter.klass
  end

  def test_sets_current_id
    assert_equal 0, @iter.current_id
  end

  def test_sets_conditions
    assert_equal ['models.id > ?', @iter.current_id], @iter.conditions
  end

  def test_sets_limit
    assert_equal 100, @iter.limit
  end

  def test_sets_redis_prefix
    assert_equal 'ModelIterator:ModelIterator::TestCase::Model', @iter.prefix
  end
end

class InitializationTestWithOptions < ModelIterator::TestCase
  def setup
    @iter = ModelIterator.new Model, :redis => RedisClient.new,
      :start_id => 5, :limit => 10, :prefix => 'foo'
  end

  def test_sets_klass
    assert_equal Model, @iter.klass
  end

  def test_sets_current_id
    assert_equal 5, @iter.current_id
  end

  def test_sets_conditions
    assert_equal ['models.id > ?', @iter.current_id], @iter.conditions
  end

  def test_sets_limit
    assert_equal 10, @iter.limit
  end

  def test_sets_redis_prefix
    assert_equal 'foo:ModelIterator:ModelIterator::TestCase::Model', @iter.prefix
  end
end

class InitializationTestWithCustomWhereClause < ModelIterator::TestCase
  def setup
    @iter = ModelIterator.new Model,
      'public = ?',
      true,
      :redis => RedisClient.new, :start_id => 5, :limit => 10
  end

  def test_sets_klass
    assert_equal Model, @iter.klass
  end

  def test_sets_current_id
    assert_equal 5, @iter.current_id
  end

  def test_sets_conditions
    assert_equal ['models.id > ? AND (public = ?)', @iter.current_id, true], @iter.conditions
  end

  def test_sets_limit
    assert_equal 10, @iter.limit
  end
end

