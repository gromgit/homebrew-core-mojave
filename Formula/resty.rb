class Resty < Formula
  include Language::Python::Shebang

  desc "Command-line REST client that can be used in pipelines"
  homepage "https://github.com/micha/resty"
  url "https://github.com/micha/resty/archive/v3.0.tar.gz"
  sha256 "9ed8f50dcf70a765b3438840024b557470d7faae2f0c1957a011ebb6c94b9dd1"
  license "MIT"
  revision 1
  head "https://github.com/micha/resty.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/resty"
    sha256 cellar: :any_skip_relocation, mojave: "6d7dfa30703514f3e81eaa49c2708aeece27c1a1c34050caecdd6cdbd7be43db"
  end

  uses_from_macos "perl"

  on_linux do
    depends_on "python@3.10"
  end

  conflicts_with "nss", because: "both install `pp` binaries"

  resource "JSON" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-2.94.tar.gz"
    sha256 "12271b5cee49943bbdde430eef58f1fe64ba6561980b22c69585e08fc977dc6d"
  end

  def install
    pkgshare.install "resty"

    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resource("JSON").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    bin.install "pp"
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])

    bin.install "pypp"
    rewrite_shebang detected_python_shebang, bin/"pypp" if OS.linux?
  end

  def caveats
    <<~EOS
      To activate the resty, add the following at the end of your #{shell_profile}:
      source #{opt_pkgshare}/resty
    EOS
  end

  test do
    cmd = "bash -c '. #{pkgshare}/resty && resty https://api.github.com' 2>&1"
    assert_equal "https://api.github.com*", shell_output(cmd).chomp
    json_pretty_pypp=<<~EOS
      {
          "a": 1
      }
    EOS
    json_pretty_pp=<<~EOS
      {
         "a" : 1
      }
    EOS
    assert_equal json_pretty_pypp, pipe_output("#{bin}/pypp", '{"a":1}', 0)
    assert_equal json_pretty_pp, pipe_output("#{bin}/pp", '{"a":1}', 0).chomp
  end
end
