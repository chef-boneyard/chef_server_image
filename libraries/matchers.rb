# cookbook/libraries/matchers.rb

if defined?(ChefSpec)
  def setup_chef_server_image(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:chef_server_image, :setup, resource_name)
  end
end
