class IrafFitsutil < Formula
  desc "IRAF external package for FITS utilities"
  homepage "https://github.com/iraf-community/iraf-fitsutil"
  url "https://github.com/iraf-community/iraf-fitsutil/archive/refs/tags/v2024.07.06.tar.gz"
  sha256 "6f58744669a84e021a3c931f448645053d2ceb65213412f0688e11f48e2b5769"

  bottle do
    root_url "https://github.com/iraf-community/homebrew-tap/releases/download/iraf-fitsutil-2024.07.06"
    rebuild 3
    sha256 cellar: :any, arm64_tahoe:   "e45050b75bc880532cda6000b2516e5fd2f8b008274877952a3bd0e2e48ccbcb"
    sha256 cellar: :any, arm64_sequoia: "8f745ae541b359d04dbf670cb0ae83bbf11ddc9d5ef62b6b45d655d6beab6303"
    sha256 cellar: :any, arm64_sonoma:  "c050b8deab60722b4978ad6ddaef9605151a15651d59f7d54f7a810b3b0c43a7"
  end

  IRAF_PACKAGE = "fitsutil".freeze

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
