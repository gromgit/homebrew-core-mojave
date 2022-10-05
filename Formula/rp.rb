class Rp < Formula
  desc "Tool to find ROP sequences in PE/Elf/Mach-O x86/x64 binaries"
  homepage "https://github.com/0vercl0k/rp"
  license "MIT"
  head "https://github.com/0vercl0k/rp.git", branch: "master"

  stable do
    url "https://github.com/0vercl0k/rp/archive/refs/tags/v2.0.2.tar.gz"
    sha256 "97aa4c84045f5777951b3d34fdf6e7c9579e46aebb18422c808c537e8b1044da"

    # Add ARM64 support. Remove in the next release.
    on_arm do
      patch do
        url "https://github.com/0vercl0k/rp/commit/da82af33da229dc98da7f7be8b3559c557924273.patch?full_index=1"
        sha256 "6cd21e38acbb7a4ef15272019634876bdc9c53ca218b4956abda09f9b8b3adc5"
      end
      patch do
        url "https://github.com/0vercl0k/rp/commit/7a2ffb789c0bf8803b31840304bc66768f56e6cf.patch?full_index=1"
        sha256 "ae63c6e9958fdbd55f4906cd3c53ae47d7fd160182d44fd237b123809bf9cbf0"
      end
    end
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rp"
    sha256 cellar: :any_skip_relocation, mojave: "f10376b25023b7f1b9c0f8831a4d668205ab2c4199de3fed1363e7f1c0ed0386"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", "src", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"

    os = OS.mac? ? "osx" : "lin"
    rp = buildpath.glob("build/rp-#{os}-*").first
    bin.install rp
    bin.install_symlink bin/rp.basename => "rp-#{os}"
  end

  test do
    os = OS.mac? ? "osx" : "lin"
    rp = bin/"rp-#{os}"
    output = shell_output("#{rp} --file #{rp} --rop=1 --unique")
    assert_match "FileFormat: #{OS.mac? ? "Mach-o" : "Elf"}", output
    assert_match(/\d+ unique gadgets found/, output)
  end
end
