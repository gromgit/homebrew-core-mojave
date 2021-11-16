class BandcampDl < Formula
  include Language::Python::Virtualenv

  desc "Simple python script to download Bandcamp albums"
  homepage "https://github.com/iheanyi/bandcamp-dl"
  license "Unlicense"
  revision 6
  head "https://github.com/iheanyi/bandcamp-dl.git", branch: "master"

  stable do
    url "https://github.com/iheanyi/bandcamp-dl/archive/v0.0.8-12.tar.gz"
    sha256 "3252f52780f280ba18818d40cda1c89bdb99ee33d7911320ec2ce4c374df2d6b"
    # upstream hotfix, https://github.com/iheanyi/bandcamp-dl/pull/167
    # remove this in next release
    patch do
      url "https://github.com/iheanyi/bandcamp-dl/commit/3d3a524af27bac761bd2f8766c6f4951776c6c60.patch?full_index=1"
      sha256 "f776b23beb1149d2449c2187bbdc3843933d063a79254a354bfc69ce4d644091"
    end

    # fix script matching https://github.com/iheanyi/bandcamp-dl/pull/171
    patch do
      url "https://github.com/iheanyi/bandcamp-dl/commit/08c450385efe847e4f8ece1dc95034e69aaeaed0.patch?full_index=1"
      sha256 "64808a6334994d847d0c5bdcfd49cfd6dbb4376c8c8d3fd4304b85f892d3915f"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99b87f34f59977248e8cef4bcf8a4280f94a4c5ed27433085f40826c08257ede"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "add76c38806f7f310dd34946916d70cb4db029c4ef3694cc64592deb9921dc2b"
    sha256 cellar: :any_skip_relocation, monterey:       "f506a16d56064a678c48ec014f6ace5171525dccc1496894b1daac2971db2bf0"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0e19f971b88b0ff7e673f453e0d88913f82e4f8d1c4accda8321092fceb68bc"
    sha256 cellar: :any_skip_relocation, catalina:       "ee51b1cdb255665578251bd7081ae2a01abcca24d48d72eed076b9a8794af58c"
    sha256 cellar: :any_skip_relocation, mojave:         "d416f44eae62f3a83be9ea4312cb244581772df264c9c8156165dde038144f56"
    sha256 cellar: :any_skip_relocation, high_sierra:    "f1d7e4a182af86854f3218cf6812fa7975d922a0ee3e8c3b5c9ee16741b0eb1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a605f8c202f0bb0e6609af7f934ef378c544752417aa20a2a33fad1173a6f54"
  end

  depends_on "python@3.9"

  resource "Unidecode" do
    url "https://files.pythonhosted.org/packages/9d/36/49d0ee152b6a1631f03a541532c6201942430060aa97fe011cf01a2cce64/Unidecode-1.0.22.tar.gz"
    sha256 "8c33dd588e0c9bc22a76eaa0c715a5434851f726131bd44a6c26471746efabf5"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/fa/8d/1d14391fdaed5abada4e0f63543fef49b8331a34ca60c88bd521bcf7f782/beautifulsoup4-4.6.0.tar.gz"
    sha256 "808b6ac932dccb0a4126558f7dfdcf41710dd44a4ef497a0bb59a77f9f078e89"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/15/d4/2f888fc463d516ff7bf2379a4e9a552fef7f22a94147655d9b1097108248/certifi-2018.1.18.tar.gz"
    sha256 "edbc3f203427eef571f79a7692bb160a2b0f7ccaa31953e99bd17e307cf63f7d"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "demjson" do
    url "https://files.pythonhosted.org/packages/96/67/6db789e2533158963d4af689f961b644ddd9200615b8ce92d6cad695c65a/demjson-2.2.4.tar.gz"
    sha256 "31de2038a0fdd9c4c11f8bf3b13fe77bc2a128307f965c8d5fb4dc6d6f6beb79"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"
    sha256 "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"
  end

  resource "mock" do
    url "https://files.pythonhosted.org/packages/0c/53/014354fc93c591ccc4abff12c473ad565a2eb24dcd82490fae33dbf2539f/mock-2.0.0.tar.gz"
    sha256 "b158b6df76edd239b8208d481dc46b6afd45a846b7812ff0ce58971cf5bc8bba"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/2c/6a/0b2caf9364db074b616b1b8c26ce7166a883c21b0e40bd50f6db02307afe/mutagen-1.40.0.tar.gz"
    sha256 "b2a2c2ce87863af12ed7896f341419cd051a3c72c3c6733db9e83060dcadee5e"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/d5/d6/f2bf137d71e4f213b575faa9eb426a8775732432edb67588a8ee836ecb80/pbr-3.1.1.tar.gz"
    sha256 "05f61c71aaefc02d8e37c0a3eeb9815ff526ea28b3b76324769e6158d7f95be1"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/b0/e1/eab4fc3752e3d240468a8c0b284607899d2fbfb236a56b7377a329aa8d09/requests-2.18.4.tar.gz"
    sha256 "9c443e7324ba5b85070c4a818ade28bfabedf16ea10206da1132edaa6dda237e"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "unicode-slugify" do
    url "https://files.pythonhosted.org/packages/8c/ba/1a05f61c7fd72df85ae4dc1c7967a3e5a4b6c61f016e794bc7f09b2597c0/unicode-slugify-0.1.3.tar.gz"
    sha256 "34cf3afefa6480efe705a4fc0eaeeaf7f49754aec322ba3e8b2f27dc1cbcf650"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ee/11/7c59620aceedcc1ef65e156cc5ce5a24ef87be4107c2b74458464e437a5d/urllib3-1.22.tar.gz"
    sha256 "cc44da8e1145637334317feebd728bd869a35285b93cbb4cca2577da7e62db4f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/bandcamp-dl", "--artist=iamsleepless", "--album=rivulets"
    assert_predicate testpath/"iamsleepless/rivulets/01 - rivulets.mp3", :exist?
    system "#{bin}/bandcamp-dl", "https://iamsleepless.bandcamp.com/track/under-the-glass-dome"
    assert_predicate testpath/"iamsleepless/under-the-glass-dome/Single - under-the-glass-dome.mp3", :exist?
  end
end
