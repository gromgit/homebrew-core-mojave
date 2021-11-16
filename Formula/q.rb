class Q < Formula
  include Language::Python::Virtualenv

  desc "Run SQL directly on CSV or TSV files"
  homepage "https://harelba.github.io/q/"
  url "https://github.com/harelba/q/archive/2.0.20.tar.gz"
  sha256 "46793aef623aac3700856c699cc04810b7a53533f829318729cee900c499a7e1"
  license "GPL-3.0-or-later"
  head "https://github.com/harelba/q.git", branch: "master"


  depends_on "ronn" => :build
  depends_on "python@3.9"
  depends_on "six"

  def install
    # broken symlink, fixed in next version
    rm_f "bin/qtextasdata.py"
    virtualenv_install_with_resources
    system "ronn", "--roff", "--section=1", "doc/USAGE.markdown"
    man1.install "doc/USAGE.1" => "q.1"
  end

  test do
    seq = (1..100).map(&:to_s).join("\n")
    output = pipe_output("#{bin}/q -c 1 'select sum(c1) from -'", seq)
    assert_equal "5050\n", output
  end
end
