class Lsof < Formula
  desc "Utility to list open files"
  homepage "https://github.com/lsof-org/lsof"
  url "https://github.com/lsof-org/lsof/archive/4.96.3-freebsd.tar.gz"
  sha256 "bcb673c547d234da327a8ee0d1ef59d3b7eac12e0c066242ec13cb706485560d"
  license "Zlib"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lsof"
    sha256 cellar: :any_skip_relocation, mojave: "d9c2ae8fcd9f015c56e7c42d9f72750da0bd23354ddab00b1703d72f1efab4ee"
  end

  keg_only :provided_by_macos

  on_linux do
    depends_on "libtirpc"
  end

  def install
    if OS.mac?
      ENV["LSOF_INCLUDE"] = MacOS.sdk_path/"usr/include"

      # Source hardcodes full header paths at /usr/include
      inreplace %w[
        dialects/darwin/kmem/dlsof.h
        dialects/darwin/kmem/machine.h
        dialects/darwin/libproc/machine.h
      ], "/usr/include", MacOS.sdk_path/"usr/include"
    else
      ENV["LSOF_INCLUDE"] = HOMEBREW_PREFIX/"include"
    end

    ENV["LSOF_CC"] = ENV.cc
    ENV["LSOF_CCV"] = ENV.cxx

    mv "00README", "README"
    system "./Configure", "-n", OS.kernel_name.downcase

    system "make"
    bin.install "lsof"
    man8.install "Lsof.8"
  end

  test do
    (testpath/"test").open("w") do
      system "#{bin}/lsof", testpath/"test"
    end
  end
end
