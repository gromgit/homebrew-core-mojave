class Licensed < Formula
  desc "Cache and verify the licenses of dependencies"
  homepage "https://github.com/github/licensed"
  url "https://github.com/github/licensed.git",
      tag:      "4.0.2",
      revision: "1068f972a1a8994ef0c08ad89d7a5a746f4eb28c"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/licensed"
    sha256 cellar: :any, mojave: "7d57bd930babf2fe7dd85cd9ae500bd7a65e122573d442980f241452feb712f8"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ruby@2.7"
  depends_on "xz"
  uses_from_macos "libffi"

  # Runtime dependencies of licensed
  # https://rubygems.org/gems/licensed/versions/4.0.0/dependencies

  # cocoapods-core 1.11.3 -> activesupport 6.1.7 -> concurrent-ruby 1.1.10
  resource "concurrent-ruby-1.1.10" do
    url "https://rubygems.org/gems/concurrent-ruby-1.1.10.gem"
    sha256 "244cb1ca0d91ec2c15ca2209507c39fb163336994428e16fbd3f465c87bd8e68"
  end

  # cocoapods-core 1.11.3 -> activesupport 6.1.7 -> i18n 1.12.0
  resource "i18n-1.12.0" do
    url "https://rubygems.org/gems/i18n-1.12.0.gem"
    sha256 "91e3cc1b97616d308707eedee413d82ee021d751c918661fb82152793e64aced"
  end

  # cocoapods-core 1.11.3 -> activesupport 6.1.7 -> minitest 5.17.0
  resource "minitest-5.17.0" do
    url "https://rubygems.org/gems/minitest-5.17.0.gem"
    sha256 "c0dfaa3e99ed5ee3500c92bb114cf9d0d3c1e6995e162dd7b49970a9f0315ece"
  end

  # cocoapods-core 1.11.3 -> activesupport 6.1.7 -> tzinfo 2.0.5
  resource "tzinfo-2.0.5" do
    url "https://rubygems.org/gems/tzinfo-2.0.5.gem"
    sha256 "c5352fd901544d396745d013f46a04ae2ed081ce806d942099825b7c2b09a167"
  end

  # cocoapods-core 1.11.3 -> activesupport 6.1.7 -> zeitwerk 2.6.6
  resource "zeitwerk-2.6.6" do
    url "https://rubygems.org/gems/zeitwerk-2.6.6.gem"
    sha256 "bb397b50c31127f8dab372fa9b21da1e7c453c5b57da172ed858136c6283f826"
  end

  # cocoapods-core 1.11.3 -> activesupport 6.1.7
  resource "active-support-6.1.7" do
    url "https://rubygems.org/gems/activesupport-6.1.7.gem"
    sha256 "f9dee8a4cc315714e29228328428437c8779f58237749339afadbdcfb5c0b74c"
  end

  # cocoapods-core 1.11.3 -> addressable 2.8.1 -> public_suffix 5.0.1
  resource "public_suffix-5.0.1" do
    url "https://rubygems.org/gems/public_suffix-5.0.1.gem"
    sha256 "65603917ff4ecb32f499f42c14951aeed2380054fa7fc51758fc0a8d455fe043"
  end

  # cocoapods-core 1.11.3 -> addressable 2.8.1
  resource "addressable-2.8.1" do
    url "https://rubygems.org/gems/addressable-2.8.1.gem"
    sha256 "bc724a176ef02118c8a3ed6b5c04c39cf59209607ffcce77b91d0261dbadedfa"
  end

  # cocoapods-core 1.11.3 -> algoliasearch 1.27.5 -> httpclient 2.8.3
  resource "httpclient-2.8.3" do
    url "https://rubygems.org/gems/httpclient-2.8.3.gem"
    sha256 "2951e4991214464c3e92107e46438527d23048e634f3aee91c719e0bdfaebda6"
  end

  # cocoapods-core 1.11.3 -> algoliasearch 1.27.5 -> json 2.6.3
  resource "json-2.6.3" do
    url "https://rubygems.org/gems/json-2.6.3.gem"
    sha256 "86aaea16adf346a2b22743d88f8dcceeb1038843989ab93cda44b5176c845459"
  end

  # cocoapods-core 1.11.3 -> algoliasearch 1.27.5
  resource "algoliasearch-1.27.5" do
    url "https://rubygems.org/gems/algoliasearch-1.27.5.gem"
    sha256 "26c1cddf3c2ec4bd60c148389e42702c98fdac862881dc6b07a4c0b89ffec853"
  end

  # cocoapods-core 1.11.3 -> concurrent-ruby 1.1.10
  resource "concurrent-ruby-1.1.10" do
    url "https://rubygems.org/gems/concurrent-ruby-1.1.10.gem"
    sha256 "244cb1ca0d91ec2c15ca2209507c39fb163336994428e16fbd3f465c87bd8e68"
  end

  # cocoapods-core 1.11.3 -> fuzzy_match 2.0.4
  resource "fuzzy_match-2.0.4" do
    url "https://rubygems.org/gems/fuzzy_match-2.0.4.gem"
    sha256 "b5de4f95816589c5b5c3ad13770c0af539b75131c158135b3f3bbba75d0cfca5"
  end

  # cocoapods-core 1.11.3 -> nap 1.1.0
  resource "nap-1.1.0" do
    url "https://rubygems.org/gems/nap-1.1.0.gem"
    sha256 "949691660f9d041d75be611bb2a8d2fd559c467537deac241f4097d9b5eea576"
  end

  # cocoapods-core 1.11.3 -> netrc 0.11.0
  resource "netrc-0.11.0" do
    url "https://rubygems.org/gems/netrc-0.11.0.gem"
    sha256 "de1ce33da8c99ab1d97871726cba75151113f117146becbe45aa85cb3dabee3f"
  end

  # cocoapods-core 1.11.3 -> public_suffix 4.0.7
  resource "public_suffix-4.0.7" do
    url "https://rubygems.org/gems/public_suffix-4.0.7.gem"
    sha256 "8be161e2421f8d45b0098c042c06486789731ea93dc3a896d30554ee38b573b8"
  end

  # cocoapods-core 1.11.3 -> typhoeus 1.4.0 -> ethon 0.16.0 -> ffi 1.15.5
  resource "ffi-1.15.5" do
    url "https://rubygems.org/gems/ffi-1.15.5.gem"
    sha256 "6f2ed2fa68047962d6072b964420cba91d82ce6fa8ee251950c17fca6af3c2a0"
  end

  # cocoapods-core 1.11.3 -> typhoeus 1.4.0 -> ethon 0.16.0
  resource "ethon-0.16.0" do
    url "https://rubygems.org/gems/ethon-0.16.0.gem"
    sha256 "bba0da1cea8ac3e1f5cdd7cb1cb5fc78d7ac562c33736f18f0c3eb2b63053d9e"
  end

  # cocoapods-core 1.11.3 -> typhoeus 1.4.0
  resource "typhoeus-1.4.0" do
    url "https://rubygems.org/gems/typhoeus-1.4.0.gem"
    sha256 "fff9880d5dc35950e7706cf132fd297f377c049101794be1cf01c95567f642d4"
  end

  # cocoapods-core 1.11.3
  resource "cocoapods-core-1.11.3" do
    url "https://rubygems.org/gems/cocoapods-core-1.11.3.gem"
    sha256 "3e1622dba30d8ceb957f940a256a111c9c873624f00491d54dccfe31efc10cd3"
  end

  # json 2.6.3
  resource "json-2.6.3" do
    url "https://rubygems.org/gems/json-2.6.3.gem"
    sha256 "86aaea16adf346a2b22743d88f8dcceeb1038843989ab93cda44b5176c845459"
  end

  # licensee 9.16.0 -> dotenv 2.8.1
  resource "dotenv-2.8.1" do
    url "https://rubygems.org/gems/dotenv-2.8.1.gem"
    sha256 "c5944793349ae03c432e1780a2ca929d60b88c7d14d52d630db0508c3a8a17d8"
  end

  # licensee 9.16.0 -> octokit 6.0.1 -> faraday 2.7.2 -> faraday-net_http 3.0.2
  resource "faraday-net_http-3.0.2" do
    url "https://rubygems.org/gems/faraday-net_http-3.0.2.gem"
    sha256 "6882929abed8094e1ee30344a3369e856fe34530044630d1f652bf70ebd87e8d"
  end

  # licensee 9.16.0 -> octokit 6.0.1 -> faraday 2.7.2 -> ruby2_keywords 0.0.5
  resource "ruby2_keywords-0.0.5" do
    url "https://rubygems.org/gems/ruby2_keywords-0.0.5.gem"
    sha256 "ffd13740c573b7301cf7a2e61fc857b2a8e3d3aff32545d6f8300d8bae10e3ef"
  end

  # llicensee 9.16.0 -> octokit 6.0.1 -> faraday 2.7.2
  resource "faraday-2.7.2" do
    url "https://rubygems.org/gems/faraday-2.7.2.gem"
    sha256 "16c3ee797ff57b2fe412c3aeacc412a60bec9eadfff5b79df24a43608d678a9e"
  end

  # licensee 9.16.0 -> octokit 6.0.1 -> sawyer 0.9.2 -> addressable 2.8.1 -> public_suffix 5.0.1
  resource "public_suffix-5.0.1" do
    url "https://rubygems.org/gems/public_suffix-5.0.1.gem"
    sha256 "65603917ff4ecb32f499f42c14951aeed2380054fa7fc51758fc0a8d455fe043"
  end

  # licensee 9.16.0 -> octokit 6.0.1 -> sawyer 0.9.2 -> addressable 2.8.1
  resource "addressable-2.8.1" do
    url "https://rubygems.org/gems/addressable-2.8.1.gem"
    sha256 "bc724a176ef02118c8a3ed6b5c04c39cf59209607ffcce77b91d0261dbadedfa"
  end

  # licensee 9.16.0 -> octokit 6.0.1 -> sawyer 0.9.2 -> faraday 2.7.2 -> faraday-net_http 3.0.2
  resource "faraday-net_http-3.0.2" do
    url "https://rubygems.org/gems/faraday-net_http-3.0.2.gem"
    sha256 "6882929abed8094e1ee30344a3369e856fe34530044630d1f652bf70ebd87e8d"
  end

  # licensee 9.16.0 -> octokit 6.0.1 -> sawyer 0.9.2 -> faraday 2.7.2 -> ruby2_keywords 0.0.5
  resource "ruby2_keywords-0.0.5" do
    url "https://rubygems.org/gems/ruby2_keywords-0.0.5.gem"
    sha256 "ffd13740c573b7301cf7a2e61fc857b2a8e3d3aff32545d6f8300d8bae10e3ef"
  end

  # licensee 9.16.0 -> octokit 6.0.1 -> sawyer 0.9.2 -> faraday 2.7.2
  resource "faraday-2.7.2" do
    url "https://rubygems.org/gems/faraday-2.7.2.gem"
    sha256 "16c3ee797ff57b2fe412c3aeacc412a60bec9eadfff5b79df24a43608d678a9e"
  end

  # licensee 9.16.0 -> octokit 6.0.1 -> sawyer 0.9.2
  resource "sawyer-0.9.2" do
    url "https://rubygems.org/gems/sawyer-0.9.2.gem"
    sha256 "fa3a72d62a4525517b18857ddb78926aab3424de0129be6772a8e2ba240e7aca"
  end

  # licensee 9.16.0 -> octokit 6.0.1
  resource "octokit-6.0.1" do
    url "https://rubygems.org/gems/octokit-6.0.1.gem"
    sha256 "a5dfea1a92c82856a0fe603fa29d43c086df90ad01186cee7bc5211b76f0b128"
  end

  # licensee 9.16.0 -> reverse_markdown 2.1.1 -> nokogiri 1.13.10 -> mini_portile2 2.8.1
  resource "mini_portile2-2.8.1" do
    url "https://rubygems.org/gems/mini_portile2-2.8.1.gem"
    sha256 "b70e325e37a378aea68b6d78c9cdd060c66cbd2bef558d8f13a6af05b3f2c4a9"
  end

  # licensee 9.16.0 -> reverse_markdown 2.1.1 -> nokogiri 1.13.10 -> racc 1.6.2
  resource "racc-1.6.2" do
    url "https://rubygems.org/gems/racc-1.6.2.gem"
    sha256 "58d26b3666382396fea84d33dc0639b7ee8d704156a52f8f22681f07b2f94f26"
  end

  # licensee 9.16.0 -> reverse_markdown 2.1.1 -> nokogiri 1.13.10
  resource "nokogiri-1.13.10" do
    url "https://rubygems.org/gems/nokogiri-1.13.10.gem"
    sha256 "d3ee00f26c151763da1691c7fc6871ddd03e532f74f85101f5acedc2d099e958"
  end

  # licensee 9.16.0 -> reverse_markdown 2.1.1
  resource "reverse_markdown-2.1.1" do
    url "https://rubygems.org/gems/reverse_markdown-2.1.1.gem"
    sha256 "b2206466b682ac1177b6b8ec321d00a84fca02d096c5d676a7a0cc5838dc0701"
  end

  # licensee 9.16.0 -> rugged 1.5.0.1
  resource "rugged-1.5.0.1" do
    url "https://rubygems.org/gems/rugged-1.5.0.1.gem"
    sha256 "1d947f2b19a2bb1d9fb4e3c7d6e8b8def3ed18f5aee21a8c7f8edb3fce66010a"
  end

  # licensee 9.16.0 -> thor 1.2.1
  resource "thor-1.2.1" do
    url "https://rubygems.org/gems/thor-1.2.1.gem"
    sha256 "b1752153dc9c6b8d3fcaa665e9e1a00a3e73f28da5e238b81c404502e539d446"
  end

  # licensee 9.16.0
  resource "licensee-9.16.0" do
    url "https://rubygems.org/gems/licensee-9.16.0.gem"
    sha256 "7b1693639019dbb1d3e020d72c4470ca84da3cfc67e4d6da1d1cdcb736d09044"
  end

  # parallel 1.22.1
  resource "parallel-1.22.1" do
    url "https://rubygems.org/gems/parallel-1.22.1.gem"
    sha256 "ebdf1f0c51f182df38522f70ba770214940bef998cdb6e00f36492b29699761f"
  end

  # pathname-common_prefix 0.0.1
  resource "pathname-common_prefix-0.0.1" do
    url "https://rubygems.org/gems/pathname-common_prefix-0.0.1.gem"
    sha256 "d58feac7e5048113dd0c9630af7188baf81d83ab37fdd248fcbc63b9e5da654e"
  end

  # reverse_markdown 2.1.1 -> nokogiri 1.13.10 -> mini_portile2 2.8.1
  resource "mini_portile2-2.8.1" do
    url "https://rubygems.org/gems/mini_portile2-2.8.1.gem"
    sha256 "b70e325e37a378aea68b6d78c9cdd060c66cbd2bef558d8f13a6af05b3f2c4a9"
  end

  # reverse_markdown 2.1.1 -> nokogiri 1.13.10 -> racc 1.6.2
  resource "racc-1.6.2" do
    url "https://rubygems.org/gems/racc-1.6.2.gem"
    sha256 "58d26b3666382396fea84d33dc0639b7ee8d704156a52f8f22681f07b2f94f26"
  end

  # reverse_markdown 2.1.1 -> nokogiri 1.13.10
  resource "nokogiri-1.13.10" do
    url "https://rubygems.org/gems/nokogiri-1.13.10.gem"
    sha256 "d3ee00f26c151763da1691c7fc6871ddd03e532f74f85101f5acedc2d099e958"
  end

  # reverse_markdown 2.1.1
  resource "reverse_markdown-2.1.1" do
    url "https://rubygems.org/gems/reverse_markdown-2.1.1.gem"
    sha256 "b2206466b682ac1177b6b8ec321d00a84fca02d096c5d676a7a0cc5838dc0701"
  end

  # ruby-xxHash 0.4.0.2
  resource "ruby-xxHash-0.4.0.2" do
    url "https://rubygems.org/gems/ruby-xxHash-0.4.0.2.gem"
    sha256 "201d8305ec1bd0bc32abeaecf7b423755dd1f45f4f4d02ef793b6bb71bf20684"
  end

  # thor 1.2.1
  resource "thor-1.2.1" do
    url "https://rubygems.org/gems/thor-1.2.1.gem"
    sha256 "b1752153dc9c6b8d3fcaa665e9e1a00a3e73f28da5e238b81c404502e539d446"
  end

  # tomlrb 2.0.3
  resource "tomlrb-2.0.3" do
    url "https://rubygems.org/gems/tomlrb-2.0.3.gem"
    sha256 "c2736acf24919f793334023a4ff396c0647d93fce702a73c9d348deaa815d4f7"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      args = ["--ignore-dependencies", "--no-document", "--install-dir", libexec]
      system "gem", "install", r.cached_download, *args
    end

    system "gem", "build", "licensed.gemspec"
    system "gem", "install", "licensed-#{version}.gem"
    bin.install libexec/"bin/licensed"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])

    # Avoid references to the Homebrew shims directory
    shims_references = Dir[
      libexec/"extensions/**/rugged-*/gem_make.out",
      libexec/"extensions/**/rugged-*/mkmf.log",
      libexec/"gems/rugged-*/vendor/libgit2/build/CMakeCache.txt",
      libexec/"gems/rugged-*/vendor/libgit2/build/**/CMakeFiles/**/*",
    ].select { |f| File.file? f }
    inreplace shims_references, Superenv.shims_path.to_s, "<**Reference to the Homebrew shims directory**>", false
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/licensed version").strip

    (testpath/"Gemfile").write <<~EOS
      source 'https://rubygems.org'
      gem 'licensed', '#{version}'
    EOS

    (testpath/".licensed.yml").write <<~EOS
      name: 'test'
      allowed:
        - mit
    EOS

    assert_match "Caching dependency records for test",
                        shell_output(bin/"licensed cache")
  end
end
