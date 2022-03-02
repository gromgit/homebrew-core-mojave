class Dromeaudio < Formula
  desc "Small C++ audio manipulation and playback library"
  homepage "https://github.com/joshb/dromeaudio/"
  url "https://github.com/joshb/DromeAudio/archive/v0.3.0.tar.gz"
  sha256 "d226fa3f16d8a41aeea2d0a32178ca15519aebfa109bc6eee36669fa7f7c6b83"
  license "BSD-2-Clause"
  head "https://github.com/joshb/dromeaudio.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dromeaudio"
    rebuild 3
    sha256 cellar: :any_skip_relocation, mojave: "a93e191b7f40b61fc3497904cd4a04295af9b841042fcd885699a72e7f5c9f82"
  end


  depends_on "cmake" => :build

  def install
    # install FindDromeAudio.cmake under share/cmake/Modules/
    inreplace "share/CMakeLists.txt", "${CMAKE_ROOT}", "#{share}/cmake"
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_predicate include/"DromeAudio", :exist?
    assert_predicate lib/"libDromeAudio.a", :exist?

    # We don't test DromeAudioPlayer with an audio file because it only works
    # with certain audio devices and will fail on CI with this error:
    #   DromeAudio Exception: AudioDriverOSX::AudioDriverOSX():
    #   AudioUnitSetProperty (for StreamFormat) failed
    #
    # Related PR: https://github.com/Homebrew/homebrew-core/pull/55292
    assert_match(/Usage: .*?DromeAudioPlayer <filename>/i,
                 shell_output(bin/"DromeAudioPlayer 2>&1", 1))
  end
end
