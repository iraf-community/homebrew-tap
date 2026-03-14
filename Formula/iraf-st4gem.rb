class IrafSt4gem < Formula
  desc "IRAF external package for tabular spectra"
  homepage "https://github.com/iraf-community/iraf-st4gem"
  url "https://gitlab.com/nsf-noirlab/csdc/usngo/iraf/st4gem.git",
      tag: "v1.2.1", revision: "e61f8c2f69265feb849fe065d409cf41bd635473"

  bottle do
    root_url "https://github.com/iraf-community/homebrew-tap/releases/download/iraf-st4gem-1.2.1"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e876b69e22498f0f6a2e389a6e2079fdc22446116790405ff49179716bb5d2b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0b62a501e4e56960142d7c42d6a208b8119d29a3494bf4c29febf7cbb19ee3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5134390a5f07ea90ff35e660103e87ba11166ef9bc76dca223e2a4c6c00c9f3e"
    sha256 cellar: :any_skip_relocation, tahoe:         "edea3f564569efc282699b4d7591073cdf3e9e4d1cc32ebc1b7008c1c8c7a68b"
    sha256 cellar: :any_skip_relocation, sequoia:       "c5f6f3ebd4df338dfe058137cded55d31b59ce1644e71150e36ce62b3366afb5"
  end

  IRAF_PACKAGE = "st4gem".freeze

  depends_on "iraf"

  def install
    rm "bin"
    mkdir_p "bin"
    ENV[IRAF_PACKAGE] = "#{buildpath}/"
    system "mkpkg", "-p", IRAF_PACKAGE
    system "irafcl", "-c", "softools; mkhelpdb helpdir=lib$root.hd helpdb=lib$helpdb.mip"

    iraf_extern = lib/"iraf/extern"
    (iraf_extern/IRAF_PACKAGE).install Dir["*"]
  end

  test do
    # Extract the version string of the package directly from the .par
    # file and check whether it can be reproduced from the
    # corresponding IRAF variable.
    ref = shell_output("grep ^version, #{lib}/iraf/extern/#{IRAF_PACKAGE}/#{IRAF_PACKAGE}.par  | cut -d\\\" -f2")
    ver = shell_output("irafcl -c #{IRAF_PACKAGE} -c =version")
    puts "'#{ref}' == '#{ver}'?"
    assert_match ref, ver
  end
end
