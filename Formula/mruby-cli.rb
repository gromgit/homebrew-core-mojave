class MrubyCli < Formula
  desc "Build native command-line applications for Linux, MacOS, and Windows"
  homepage "https://github.com/hone/mruby-cli"
  url "https://github.com/hone/mruby-cli/archive/v0.0.4.tar.gz"
  sha256 "97d889b5980193c562e82b42089b937e675b73950fa0d0c4e46fbe71d16d719f"
  license "MIT"
  head "https://github.com/hone/mruby-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ac082ff3a558eba68662a837eba2a9dfed46d52b757bb0e0b046b6a4d2d1105a"
    sha256 cellar: :any_skip_relocation, big_sur:       "e15510585f6f0d64a93288218ab267281230937d0c97dc6982913683641bc98b"
    sha256 cellar: :any_skip_relocation, catalina:      "0418ca77d1a6adeaaf3184e9cbd566bab2829f2f736cc0f7f07ecf79e3bb6195"
    sha256 cellar: :any_skip_relocation, mojave:        "232802e1ee21a4c1d3790272414914f9d5b7ab073a2fd819c9ef5fc6872a165f"
    sha256 cellar: :any_skip_relocation, high_sierra:   "267baff54cace7684edd4184625afd6fb788cdb072035e88b9c10e4d274454fe"
    sha256 cellar: :any_skip_relocation, sierra:        "d436b8d717f89db9807338345f4b0f385abcfc45f56e9b0b7decc333d4d05ad6"
    sha256 cellar: :any_skip_relocation, el_capitan:    "2f56375783e9365bafc0868d505b54eea315f6dad9a0095decbbd61abeb345ac"
    sha256 cellar: :any_skip_relocation, yosemite:      "a06806ca6a22d3b015e073a984e832013f2efe729870e2aa6d0b17e91a4b9855"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "ruby" => :build

  def install
    ENV["MRUBY_CLI_LOCAL"] = "true"

    # Edit config to skip building Linux and Windows binaries
    rm buildpath/"build_config.rb"

    (buildpath/"build_config.rb").write <<~EOS
      MRuby::Build.new do |conf|
        toolchain :clang
        conf.gem File.expand_path(File.dirname(__FILE__))
      end
    EOS

    system "rake", "compile"
    bin.install "mruby/build/host/bin/mruby-cli"
  end

  test do
    system "#{bin}/mruby-cli", "--setup=brew"
    assert File.file? "brew/mrblib/brew.rb"
    assert File.file? "brew/tools/brew/brew.c"
  end
end
