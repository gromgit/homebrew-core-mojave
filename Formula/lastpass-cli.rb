class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/releases/download/v1.3.3/lastpass-cli-1.3.3.tar.gz"
  sha256 "b94f591627e06c9fed3bc38007b1adc6ea77127e17c7175c85d497096768671b"
  license "GPL-2.0"
  revision 1
  head "https://github.com/lastpass/lastpass-cli.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lastpass-cli"
    rebuild 5
    sha256 cellar: :any, mojave: "7a86d5b4f02b59aff84294f2c263a3bc6132a74c17cb2b09e8f00f7bb613b591"
  end

  depends_on "asciidoc" => :build
  depends_on "cmake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
  # Avoid crashes on Mojave's version of libcurl (https://github.com/lastpass/lastpass-cli/issues/427)
  depends_on "curl" if MacOS.version >= :mojave
  depends_on "openssl@1.1"
  depends_on "pinentry"

  uses_from_macos "curl"
  uses_from_macos "libxslt"

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_INSTALL_MANDIR:PATH=#{man}"
      system "make", "install", "install-doc"
    end

    bash_completion.install "contrib/lpass_bash_completion"
    zsh_completion.install "contrib/lpass_zsh_completion" => "_lpass"
    fish_completion.install "contrib/completions-lpass.fish" => "lpass.fish"
  end

  test do
    assert_equal("Error: Could not find decryption key. Perhaps you need to login with `#{bin}/lpass login`.",
      shell_output("#{bin}/lpass passwd 2>&1", 1).chomp)
  end
end
