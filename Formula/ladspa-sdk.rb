class LadspaSdk < Formula
  desc "Linux Audio Developer's Simple Plugin"
  homepage "https://ladspa.org"
  url "https://www.ladspa.org/download/ladspa_sdk_1.17.tgz"
  sha256 "d9d596171d93f9c226fcdb7e27c6f917422ac487efe2c05e0a18094df4268061"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.ladspa.org/download/"
    regex(/href=.*?ladspa[._-]sdk[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end


  depends_on "libsndfile"
  depends_on :linux

  def install
    args = %W[
      INSTALL_PLUGINS_DIR=#{lib}/ladspa
      INSTALL_INCLUDE_DIR=#{include}
      INSTALL_BINARY_DIR=#{bin}
    ]
    cd "src" do
      system "make", "install", *args
    end
    bin.env_script_all_files libexec/"bin", LADSPA_PATH: opt_lib/"ladspa"
  end

  test do
    output = shell_output("#{bin}/listplugins")
    assert_match "Mono Amplifier", output
    assert_match "Simple Delay Line", output
    assert_match "Simple Low Pass Filter", output
    assert_match "Simple High Pass Filter", output
    assert_match "Sine Oscillator", output
    assert_match "Stereo Amplifier", output
    assert_match "White Noise Source", output

    expected_output = <<~EOS
      Plugin Name: "Mono Amplifier"
      Plugin Label: "amp_mono"
      Plugin Unique ID: 1048
      Maker: "Richard Furse (LADSPA example plugins)"
      Copyright: "None"
      Must Run Real-Time: No
      Has activate() Function: No
      Has deactivate() Function: No
      Has run_adding() Function: No
      Environment: Normal or Hard Real-Time
    EOS
    assert_match expected_output, shell_output("#{bin}/analyseplugin amp")
  end
end
