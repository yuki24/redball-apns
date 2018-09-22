lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "redball/apns/version"

Gem::Specification.new do |spec|
  spec.name          = "redball-apns"
  spec.version       = Redball::Apns::VERSION
  spec.authors       = ["Yuki Nishijima"]
  spec.email         = ["yk.nishijima@gmail.com"]
  spec.summary       = %q{Production-ready client for APNs (Apple Push Notification Service)}
  spec.description   = %q{Production-ready client for APNs (Apple Push Notification Service) that fully utilizes HTTP/2's single persistent connection and multiplexing.}
  spec.homepage      = "https://github.com/yuki24/redball-apns"
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0").reject {|f| f.match(%r{^(test)/}) }
  spec.require_paths = ["lib"]

  spec.add_dependency "curb", ">= 0.9.6"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
