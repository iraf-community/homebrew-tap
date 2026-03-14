class IrafSptable < Formula
  desc "IRAF external package for tabular spectra"
  homepage "https://github.com/iraf-community/iraf-sptable"
  url "https://github.com/iraf-community/iraf-sptable/archive/refs/tags/1.0.pre20180612.tar.gz"
  sha256 "c241f936cd8ebb3fe45d22e6d72a78b0802b5aacd3673e6eab4f764a50fffc33"

  bottle do
    root_url "https://github.com/iraf-community/homebrew-tap/releases/download/iraf-sptable-1.0.pre20"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "358f01e8ef7e4683e0c10e7c6b8bbedef4b3f2e7ff91feebfdd5ece823959ea8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6eec69282294788008c117a75e2a9144a2b60320ae278b63509d844f5b3e4a5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afa94f47b276aa4f0a29f9f916ad511caa947ac44aded42113d0ac719bc816bd"
    sha256 cellar: :any_skip_relocation, tahoe:         "04e54aa54ced21687a921743c99d72ebee8d4746c6713409d8d00f9a364e5a97"
    sha256 cellar: :any_skip_relocation, sequoia:       "3e17b089a1c16402bd8d545416d0fa394adb3a01af6ff040fd03fb7ec1ef3373"
  end

  IRAF_PACKAGE = "sptable".freeze

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
