class Iozone < Formula
  desc "File system benchmark tool"
  homepage "https://www.iozone.org/"
  url "https://www.iozone.org/src/current/iozone3_493.tgz"
  sha256 "5a52f5017e022e737f5b55f320cc6ada0f2a8c831a5f996cce2a44e03e91c038"
  license :cannot_represent

  livecheck do
    url "https://www.iozone.org/src/current/"
    regex(/href=.*?iozone[._-]?v?(\d+(?:[._]\d+)+)\.t/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub("_", ".") }
    end
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/iozone"
    sha256 cellar: :any_skip_relocation, mojave: "e5fb9c4c8b297f4d1f73061971f74f407dd0df4e3d2fb50d13dbc7f79a9f475d"
  end

  def install
    cd "src/current" do
      target = OS.mac? ? "macosx" : OS.kernel_name.downcase
      system "make", target, "CC=#{ENV.cc}"
      bin.install "iozone"
      pkgshare.install %w[Generate_Graphs client_list gengnuplot.sh gnu3d.dem
                          gnuplot.dem gnuplotps.dem iozone_visualizer.pl
                          report.pl]
    end
    man1.install "docs/iozone.1"
  end

  test do
    assert_match "File size set to 16384 kB",
      shell_output("#{bin}/iozone -I -s 16M")
  end
end
