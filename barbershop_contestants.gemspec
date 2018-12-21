
lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "barbershop_contestants/version"

Gem::Specification.new do |spec|
  spec.name          = "barbershop_contestants"
  spec.version       = BarbershopContestants::VERSION
  spec.authors       = ["Paul Ashour"]
  spec.email         = ["paul.ashour@gmail.com"]

  spec.summary       = "A quick Ruby Gem that scrapes barbershopwiki.com for the Learn.co Ruby CLI project."
  spec.description   = "This Gem scrapes barbershopwiki.com and organizes the data for perusal via a simple CLI. Created for the Ruby CLI project in section one of Learn.co's Full Stack Web Development program."
  spec.homepage      = "https://github.com/artrexdenthur/Ruby-Gem-Project-Barbershop-Contestants"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  #
  #   spec.metadata["homepage_uri"] = spec.homepage
  #   spec.metadata["source_code_uri"] = "https://github.com/artrexdenthur/oo-student-scraper-online-web-pt-102218.git"
  #   spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = ["barbershop_contestants"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "github_changelog_generator", "~> 1.14.3"
  spec.add_development_dependency "pry", "~> 0.12.2"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_runtime_dependency "nokogiri", "~> 1.8.5"
  spec.add_runtime_dependency "require_all", "~> 2.0.0"

end
