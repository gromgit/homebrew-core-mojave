class HasteClient < Formula
  desc "CLI client for haste-server"
  homepage "https://hastebin.com/"
  license "MIT"
  revision 6
  head "https://github.com/toptal/haste-client.git", branch: "master"

  stable do
    url "https://github.com/toptal/haste-client/archive/v0.2.3.tar.gz"
    sha256 "becbc13c964bb88841a440db4daff8e535e49cc03df7e1eddf16f95e2696cbaf"

    # Remove for > 0.2.3
    # Upstream commit from 19 Jul 2017 "Bump version to 0.2.3"
    patch do
      url "https://github.com/toptal/haste-client/commit/1037d89.patch?full_index=1"
      sha256 "1e9c47f35c65f253fd762c673b7677921b333c02d2c4e4ae5f182fcd6a5747c6"
    end
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/haste-client"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "a1ce23c5c8ba3ebcd24beb16930560d84ad7ed3ac747ec5564a9eaed63d4864e"
  end

  depends_on "ruby" if MacOS.version <= :sierra

  resource "faraday" do
    url "https://rubygems.org/gems/faraday-0.17.4.gem"
    sha256 "11677b5b261fbbfd4d959f702078d81c0bb66006c00ab2f329f32784778e4d9c"
  end

  if MacOS.version <= :sierra
    resource "json" do
      url "https://rubygems.org/gems/json-2.5.1.gem"
      sha256 "918d8c41dacb7cfdbe0c7bbd6014a5372f0cf1c454ca150e9f4010fe80cc3153"
    end
  end

  resource "multipart-post" do
    url "https://rubygems.org/gems/multipart-post-2.1.1.gem"
    sha256 "d2dd7aa957650e0d99e0513cd388401b069f09528441b87d884609c8e94ffcfd"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--no-document",
             "--install-dir", libexec
    end
    system "gem", "build", "haste.gemspec"
    system "gem", "install", "--ignore-dependencies", "haste-#{version}.gem"
    bin.install libexec/"bin/haste"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    output = pipe_output("#{bin}/haste", "testing", 0)
    assert_match(%r{^https://hastebin\.com/.+}, output)
  end
end
