class IrafSt4gem < Formula
  desc "IRAF external package for tabular spectra"
  homepage "https://github.com/iraf-community/iraf-st4gem"
  url "https://gitlab.com/nsf-noirlab/csdc/usngo/iraf/st4gem.git",
      tag: "v1.2.1", revision: "e61f8c2f69265feb849fe065d409cf41bd635473"

  IRAF_PACKAGE = "st4gem".freeze

  bottle do
    root_url "https://github.com/iraf-community/homebrew-tap/releases/download/iraf-st4gem-1.2.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "eb775d4d152462608e6516951e0dd9ad22b417127db978473e75f78bc3db4202"
    sha256 cellar: :any_skip_relocation, sequoia:     "42f52038be1620326303a04e91cc828dd687143dd096f46bb05ba51cb09dcd1c"
  end

  depends_on "iraf"

  def install
    rm "bin"
    mkdir_p "bin"
    ENV[IRAF_PACKAGE] = "#{buildpath}/"
    system "mkpkg", "-p", IRAF_PACKAGE

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
