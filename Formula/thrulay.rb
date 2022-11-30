class Thrulay < Formula
  desc "Measure performance of a network"
  homepage "https://sourceforge.net/projects/thrulay/"
  url "https://downloads.sourceforge.net/project/thrulay/thrulay/0.9/thrulay-0.9.tar.gz"
  sha256 "373d5613dfe371f6b4f48fc853f6c27701b2981ba4100388c9881cb802d1780d"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/thrulay"
    rebuild 1
    sha256 cellar: :any, mojave: "ccc5b7d52b0b42d1c47639f9115badf347862ab0bf8ccb18557a118efbdb339f"
  end

  def install
    # Fix flat namespace usage
    inreplace "configure", "${wl}-flat_namespace ${wl}-undefined ${wl}suppress", "${wl}-undefined ${wl}dynamic_lookup"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    ENV.deparallelize
    system "make", "install"
  end
end
