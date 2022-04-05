class Licensefinder < Formula
  desc "Find licenses for your project's dependencies"
  homepage "https://github.com/pivotal/LicenseFinder"
  url "https://github.com/pivotal/LicenseFinder.git",
      tag:      "v7.0.1",
      revision: "b938cbfb33e8ec4eb9f2a4abcfb6e3462d226621"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/licensefinder"
    sha256 cellar: :any_skip_relocation, mojave: "f84615e019d752a6ba8aad3baafa010e54d27e7afa77cdcff1311f303e24c4b1"
  end

  depends_on "ruby@2.7" if MacOS.version <= :mojave

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "license_finder.gemspec"
    system "gem", "install", "license_finder-#{version}.gem"
    bin.install libexec/"bin/license_finder"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    gem_home = testpath/"gem_home"
    ENV["GEM_HOME"] = gem_home
    system "gem", "install", "bundler"

    mkdir "test"
    (testpath/"test/Gemfile").write <<~EOS
      source 'https://rubygems.org'
      gem 'license_finder', '#{version}'
    EOS
    cd "test" do
      ENV.prepend_path "PATH", gem_home/"bin"
      system "bundle", "install"
      ENV.prepend_path "GEM_PATH", gem_home
      assert_match "license_finder, #{version}, MIT",
                   shell_output(bin/"license_finder", 1)
    end
  end
end
