# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{g_sectioned_shower}
  s.version = "1.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["C. Jason Harrelson (midas)"]
  s.date = %q{2009-03-18}
  s.description = %q{A Guilded (http://github.com/midas/guilded/tree/master) component that creates adaptaple show (detail) views of a single  ActiveRecord object.}
  s.email = ["jason@lookforwardenterprises.com"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc"]
  s.files = [".git/COMMIT_EDITMSG", ".git/HEAD", ".git/config", ".git/description", ".git/hooks/applypatch-msg.sample", ".git/hooks/commit-msg.sample", ".git/hooks/post-commit.sample", ".git/hooks/post-receive.sample", ".git/hooks/post-update.sample", ".git/hooks/pre-applypatch.sample", ".git/hooks/pre-commit.sample", ".git/hooks/pre-rebase.sample", ".git/hooks/prepare-commit-msg.sample", ".git/hooks/update.sample", ".git/index", ".git/info/exclude", ".git/logs/HEAD", ".git/logs/refs/heads/master", ".git/logs/refs/remotes/origin/HEAD", ".git/logs/refs/remotes/origin/master", ".git/objects/01/4e4cef8bc6ed225fdb2984351553c8d372b732", ".git/objects/12/6f155a4da3ee50917d8fc93106f9ad462a0f56", ".git/objects/14/23b83c79ddfcd13db161c4ede6d18935ccf31c", ".git/objects/23/86fad65b32a8af9c72b55463af32d75f63e6f9", ".git/objects/32/5b363b4c0bb6bec3e35c02007ffe4ba72195b7", ".git/objects/3a/629ca438c405eda2b0cdadb08838a7db452237", ".git/objects/3e/af4e449ad34e4a556007c66bd09a968d24a2b6", ".git/objects/3f/2b561090f7e36519ae7c3fdb3f4feacd4cd96d", ".git/objects/41/a1347a878ab199886cc5784df1beb00cdb2b64", ".git/objects/50/83c599ccd6ee67e593f55ae494055849865d99", ".git/objects/5e/4d8cc8aa9a9d4294d0fb5d225d44dca81d4e4e", ".git/objects/65/b8d1f9b54e6ed4426569d07679c76a88b08d9a", ".git/objects/8c/a19f3cd6d098f9aee23458fe6ab01405b2a61c", ".git/objects/9e/e6d84d58d9c202ce70674cc722883cac21ea47", ".git/objects/a3/34747e49d99855eae3f93981f1943ab120ac1c", ".git/objects/ac/4b5c9f87ff284ef8b88c45a84227f5f2fe16f2", ".git/objects/b5/7a9b1323902bffbbbf73c5293e4e0d1d4dddd3", ".git/objects/c1/9dc2173ebf9ecd78641ed5dd59b63e0f1a7003", ".git/objects/c2/0a9349107f31d9452dfd52303f050efb6569a7", ".git/objects/e8/89ef7d4e2b18abc600a2b11b6313d94f9f27c0", ".git/objects/pack/pack-ce2afd6f34c40084a79f752a5182003b9a433316.idx", ".git/objects/pack/pack-ce2afd6f34c40084a79f752a5182003b9a433316.pack", ".git/packed-refs", ".git/refs/heads/master", ".git/refs/remotes/origin/HEAD", ".git/refs/remotes/origin/master", "History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc", "Rakefile", "g_sectioned_shower.gemspec", "lib/g_sectioned_shower.rb", "lib/g_sectioned_shower/view_helpers.rb", "script/console", "script/destroy", "script/generate", "spec/g_sectioned_shower_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "tasks/rspec.rake"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/midas/g_sectioned_shower/tree/master}
  s.post_install_message = %q{PostInstall.txt}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{g_sectioned_shower}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A Guilded (http://github.com/midas/guilded/tree/master) component that creates adaptaple show (detail) views of a single  ActiveRecord object.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<newgem>, [">= 1.2.3"])
      s.add_development_dependency(%q<rails>, [">= 2.2.0"])
      s.add_development_dependency(%q<midas-guilded>, [">= 0.1.4"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.0"])
    else
      s.add_dependency(%q<newgem>, [">= 1.2.3"])
      s.add_dependency(%q<rails>, [">= 2.2.0"])
      s.add_dependency(%q<midas-guilded>, [">= 0.1.4"])
      s.add_dependency(%q<hoe>, [">= 1.8.0"])
    end
  else
    s.add_dependency(%q<newgem>, [">= 1.2.3"])
    s.add_dependency(%q<rails>, [">= 2.2.0"])
    s.add_dependency(%q<midas-guilded>, [">= 0.1.4"])
    s.add_dependency(%q<hoe>, [">= 1.8.0"])
  end
end
