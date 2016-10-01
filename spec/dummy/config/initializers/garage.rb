Garage.configure {}

Garage::TokenScope.configure do
  register :public do
    access :read, Post
  end

  register :read_private_post do
    access :read, PrivatePost
  end

  register :write_post do
    access :write, Post
  end

  register :read_post_body do
    access :read, PostBody
  end

  register :sudo, hidden: true do
    access :read, PrivatePost
    access :read, PostBody
  end

  register :meta do
    access :read, Garage::Meta::RemoteService
    access :read, Garage::Docs::Document
  end

  namespace :foobar do
    register :read_post do
      access :read, NamespacedPost
    end
  end
end

Garage.configuration.strategy = Garage::Strategy::Jwt

Garage::Jwt.configure do |c|
  c.algorithm = Garage::Jwt::Algorithm.hs256
  c.common_key = "testkey"
end

Garage::Meta::RemoteService.configure do
  service do
    namespace nil
    name "Main API"
    endpoint "http://api.example.com/v1"
    alternate_endpoint :internal, "http://api-internal.example.amazonaws.com/v1"
  end

  service do
    namespace :foo
    name "Foo API"
    endpoint "http://foo.api.example.com/v1"
    alternate_endpoint :internal, "http://foo.api-internal.example.amazonaws.com/v1"
  end
end
