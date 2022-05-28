class Pillow < Formula
  desc "Friendly PIL fork (Python Imaging Library)"
  homepage "https://python-pillow.org"
  url "https://files.pythonhosted.org/packages/43/6e/59853546226ee6200f9ba6e574d11604b60ad0754d2cbd1c8f3246b70418/Pillow-9.1.1.tar.gz"
  sha256 "7502539939b53d7565f3d11d87c78e7ec900d3c72945d4ee0e2f250d598309a0"
  license "HPND"
  head "https://github.com/python-pillow/Pillow.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pillow"
    sha256 cellar: :any, mojave: "7e0d5e035560fd8a7eeb9831b3dce222c682aaa51b41b4d726662f9fc51c3dbd"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.8" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]
  depends_on "jpeg"
  depends_on "libimagequant"
  depends_on "libraqm"
  depends_on "libtiff"
  depends_on "libxcb"
  depends_on "little-cms2"
  depends_on "openjpeg"
  depends_on "tcl-tk"
  depends_on "webp"

  uses_from_macos "zlib"

  on_macos do
    depends_on "python@3.7" => [:build, :test] unless Hardware::CPU.arm?
  end

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/python@\d\.\d+/) }
        .map(&:opt_bin)
        .map { |bin| bin/"python3" }
  end

  def install
    build_ext_args = %w[
      --enable-tiff
      --enable-freetype
      --enable-lcms
      --enable-webp
      --enable-xcb
    ]

    install_args = %w[
      --single-version-externally-managed
      --record=installed.txt
    ]

    ENV["MAX_CONCURRENCY"] = ENV.make_jobs.to_s
    deps.each do |dep|
      next if dep.build? || dep.test?

      ENV.prepend "CPPFLAGS", "-I#{dep.to_formula.opt_include}"
      ENV.prepend "LDFLAGS", "-L#{dep.to_formula.opt_lib}"
    end

    # Useful in case of build failures.
    inreplace "setup.py", "DEBUG = False", "DEBUG = True"

    pythons.each do |python|
      system python, "setup.py",
                     "build_ext", *build_ext_args,
                     "install", *install_args, "--install-lib=#{prefix/Language::Python.site_packages(python)}"
    end
  end

  test do
    (testpath/"test.py").write <<~EOS
      from PIL import Image
      im = Image.open("#{test_fixtures("test.jpg")}")
      print(im.format, im.size, im.mode)
    EOS

    pythons.each do |python|
      assert_equal "JPEG (1, 1) RGB", shell_output("#{python} test.py").chomp
    end
  end
end
