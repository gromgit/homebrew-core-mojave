class Lsof < Formula
  desc "Utility to list open files"
  homepage "https://github.com/lsof-org/lsof"
  url "https://github.com/lsof-org/lsof/archive/refs/tags/4.96.4.tar.gz"
  sha256 "b5a052cac8d6b2726bbb1de2b98c6d9204c7619263fb63e9b6b1bd6bbb37bf14"
  license "Zlib"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lsof"
    sha256 cellar: :any_skip_relocation, mojave: "ec67898679ab6b62274660640bdc0bc1af27ebde184fbda3fa6772528e2e825b"
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
