class Qcli < Formula
  desc "Report audiovisual metrics via libavfilter"
  homepage "https://bavc.org/preserve-media/preservation-tools"
  url "https://github.com/bavc/qctools/archive/v1.2.1.tar.gz"
  sha256 "17cdc326819d3b332574968ee99714ac982c3a8e19a9c80bcbd3dc6dcb4db2b1"
  license "GPL-3.0-or-later"
  head "https://github.com/bavc/qctools.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/qcli"
    sha256 cellar: :any, mojave: "11abe890b53b57dedcecd7947c321365db1d73e13ca113dd453e877d45006f55"
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg@4"
  depends_on "qt@5"
  depends_on "qwt-qt5"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    qt5 = Formula["qt@5"].opt_prefix
    ENV["QCTOOLS_USE_BREW"]="true"

    cd "Project/QtCreator/qctools-lib" do
      system "#{qt5}/bin/qmake", "qctools-lib.pro"
      system "make"
    end
    cd "Project/QtCreator/qctools-cli" do
      system "#{qt5}/bin/qmake", "qctools-cli.pro"
      system "make"
      bin.install "qcli"
    end
  end

  test do
    # Create an example mp4 file
    mp4out = testpath/"video.mp4"
    system "#{Formula["ffmpeg@4"].bin}/ffmpeg", "-filter_complex", "testsrc=rate=1:duration=1", mp4out
    # Create a qcli report from the mp4
    qcliout = testpath/"video.mp4.qctools.xml.gz"
    system bin/"qcli", "-i", mp4out, "-o", qcliout
    assert_predicate qcliout, :exist?
  end
end
