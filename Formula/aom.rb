class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      tag:      "v3.4.0",
      revision: "fc430c57c7b0307b4c5ffb686cd90b3c010d08d2"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/aom"
    sha256 cellar: :any, mojave: "0b81b577035c1b8b91e306b36357432fafecb97740aea8d202feac8a48b9b242"
  end

  depends_on "cmake" => :build
  depends_on "yasm" => :build

  # `jpeg-xl` is currently not bottled on Linux
  on_macos do
    depends_on "pkg-config" => :build
    depends_on "jpeg-xl"
    depends_on "libvmaf"
  end

  resource "homebrew-bus_qcif_15fps.y4m" do
    url "https://media.xiph.org/video/derf/y4m/bus_qcif_15fps.y4m"
    sha256 "868fc3446d37d0c6959a48b68906486bd64788b2e795f0e29613cbb1fa73480e"
  end

  def install
    ENV.runtime_cpu_detection unless Hardware::CPU.arm?

    args = std_cmake_args.concat(["-DCMAKE_INSTALL_RPATH=#{rpath}",
                                  "-DENABLE_DOCS=off",
                                  "-DENABLE_EXAMPLES=on",
                                  "-DENABLE_TESTDATA=off",
                                  "-DENABLE_TESTS=off",
                                  "-DENABLE_TOOLS=off",
                                  "-DBUILD_SHARED_LIBS=on"])
    # Runtime CPU detection is not currently enabled for ARM on macOS.
    args << "-DCONFIG_RUNTIME_CPU_DETECT=0" if Hardware::CPU.arm?

    # Make unconditional when `jpeg-xl` is bottled on Linux
    if OS.mac?
      args += [
        "-DCONFIG_TUNE_BUTTERAUGLI=1",
        "-DCONFIG_TUNE_VMAF=1",
      ]
    end

    system "cmake", "-S", ".", "-B", "brewbuild", *args
    system "cmake", "--build", "brewbuild"
    system "cmake", "--install", "brewbuild"
  end

  test do
    resource("homebrew-bus_qcif_15fps.y4m").stage do
      system "#{bin}/aomenc", "--webm",
                              "--tile-columns=2",
                              "--tile-rows=2",
                              "--cpu-used=8",
                              "--output=bus_qcif_15fps.webm",
                              "bus_qcif_15fps.y4m"

      system "#{bin}/aomdec", "--output=bus_qcif_15fps_decode.y4m",
                              "bus_qcif_15fps.webm"
    end
  end
end
