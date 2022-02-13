class Ffmpegthumbnailer < Formula
  desc "Create thumbnails for your video files"
  homepage "https://github.com/dirkvdb/ffmpegthumbnailer"
  url "https://github.com/dirkvdb/ffmpegthumbnailer/archive/2.2.2.tar.gz"
  sha256 "8c4c42ab68144a9e2349710d42c0248407a87e7dc0ba4366891905322b331f92"
  license "GPL-2.0-or-later"
  revision 7
  head "https://github.com/dirkvdb/ffmpegthumbnailer.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ffmpegthumbnailer"
    sha256 cellar: :any, mojave: "073903a770bfaafc70fb66b1b9b09c51bf0482d72f0b1168632f93cc3e45c149"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg@4"
  depends_on "jpeg"
  depends_on "libpng"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # rubberband is built with GCC

  def install
    args = std_cmake_args
    args << "-DENABLE_GIO=ON"
    args << "-DENABLE_THUMBNAILER=ON"
    args << "-DCMAKE_INSTALL_RPATH=#{rpath}"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    f = Formula["ffmpeg@4"].opt_bin/"ffmpeg"
    png = test_fixtures("test.png")
    system f.to_s, "-loop", "1", "-i", png.to_s, "-c:v", "libx264", "-t", "30",
                   "-pix_fmt", "yuv420p", "v.mp4"
    assert_predicate testpath/"v.mp4", :exist?, "Failed to generate source video!"
    system "#{bin}/ffmpegthumbnailer", "-i", "v.mp4", "-o", "out.jpg"
    assert_predicate testpath/"out.jpg", :exist?, "Failed to create thumbnail!"
  end
end
