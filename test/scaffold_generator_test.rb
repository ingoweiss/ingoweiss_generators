require File.join(File.dirname(__FILE__), 'helpers/test_helper')

class ScaffoldGeneratorTest < Test::Unit::TestCase
  
  def setup
  end

  def test_generated_controllers
    assert_generated_files('app/controllers')
  end
  
  def test_generated_models
    assert_generated_files('app/models')
  end
  
  def test_generated_views
    assert_generated_files('app/views')
  end
  
  private
  
  def assert_generated_files(dir)
    Dir.glob(File.join(INGOWEISS_GENERATORS_ROOT, 'test/reference_app', dir, '**/*')).collect{|f| f.sub(File.join(INGOWEISS_GENERATORS_ROOT, 'test/reference_app'), '')}.each do |generated_file|
      next if File.directory?(File.join(INGOWEISS_GENERATORS_ROOT, 'test/reference_app', generated_file))
      assert_generated_file(generated_file)
    end
  end
  
  def assert_generated_file(file)
    reference_file = File.join(INGOWEISS_GENERATORS_ROOT, 'test/reference_app', file)
    generated_file = File.join(HOST_APP_ROOT, file)
    assert File.exists?(generated_file), "File #{file} was not generated"
    assert_equal IO.read(reference_file), IO.read(generated_file), "File #{file} did not match the reference file"
  end
    
  
end