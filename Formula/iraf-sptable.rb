class IrafSptable < Formula
  desc "IRAF external package for tabular spectra"
  homepage "https://github.com/iraf-community/iraf-sptable"
  url "https://github.com/iraf-community/iraf-sptable/archive/refs/tags/1.0.pre20180612.tar.gz"
  sha256 "c241f936cd8ebb3fe45d22e6d72a78b0802b5aacd3673e6eab4f764a50fffc33"

  IRAF_PACKAGE = "sptable".freeze

  bottle do
    root_url "https://github.com/iraf-community/homebrew-tap/releases/download/iraf-sptable-1.0.pre20"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "436124c62479f09885434692505670b1226b69f4296f1931b59da5b826946220"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84a83bcbcdea16969f03f5137b25ff5b2b6125c61290c9df2c2f209d83e170e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d61040d27ebd72ee8c01820f65f4debe1cae00dd86370175401d0e9cf7beb66a"
    sha256 cellar: :any_skip_relocation, sequoia:       "2f52c60779c291cf5116faacd3cebc4571244a124bb349d8dd67ca9a9a17cca4"
  end

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
