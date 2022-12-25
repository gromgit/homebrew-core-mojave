class Choose < Formula
  include Language::Python::Shebang

  desc "Make choices on the command-line"
  homepage "https://github.com/geier/choose"
  url "https://github.com/geier/choose/archive/v0.1.0.tar.gz"
  sha256 "d09a679920480e66bff36c76dd4d33e8ad739a53eace505d01051c114a829633"
  license "MIT"
  revision 4
  head "https://github.com/geier/choose.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/choose"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "ac709f20ecd778f4d02546e222fdf956dce66615e09aca7e348e62bc7e25a179"
  end

  depends_on "python@3.11"

  conflicts_with "choose-gui", because: "both install a `choose` binary"
  conflicts_with "choose-rust", because: "both install a `choose` binary"

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/45/dd/d57924f77b0914f8a61c81222647888fbb583f89168a376ffeb5613b02a6/urwid-2.1.0.tar.gz"
    sha256 "0896f36060beb6bf3801cb554303fef336a79661401797551ba106d23ab4cd86"
  end

  def install
    python3 = "python3.11"
    ENV.prepend_create_path "PYTHONPATH", libexec/Language::Python.site_packages(python3)

    resource("urwid").stage do
      system python3, *Language::Python.setup_install_args(libexec, python3)
    end

    bin.install "choose"
    rewrite_shebang detected_python_shebang, bin/"choose"
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    assert_predicate bin/"choose", :executable?

    # [Errno 6] No such device or address: '/dev/tty'
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_equal "homebrew-test", pipe_output(bin/"choose", "homebrew-test\n").strip
  end
end
