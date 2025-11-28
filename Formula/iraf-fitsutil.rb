class IrafFitsutil < Formula
  desc "IRAF external package for FITS utilities"
  homepage "https://github.com/iraf-community/iraf-fitsutil"
  url "https://github.com/iraf-community/iraf-fitsutil/archive/refs/tags/v2024.07.06.tar.gz"
  sha256 "6f58744669a84e021a3c931f448645053d2ceb65213412f0688e11f48e2b5769"

  IRAF_PACKAGE = "fitsutil".freeze

  bottle do
    root_url "https://github.com/iraf-community/homebrew-tap/releases/download/iraf-fitsutil-2024.07.06"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe: "8043f36647ef044d1f058ade3d5bee1f554be316f11f5a0b73f190f3bf850531"
  end

  depends_on "cfitsio"
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
