class IrafSt4gem < Formula
  desc "IRAF external package for tabular spectra"
  homepage "https://github.com/iraf-community/iraf-st4gem"
  url "https://gitlab.com/nsf-noirlab/csdc/usngo/iraf/st4gem.git",
      tag: "v1.2.1", revision: "e61f8c2f69265feb849fe065d409cf41bd635473"

  IRAF_PACKAGE = "st4gem".freeze

  bottle do
    root_url "https://github.com/iraf-community/homebrew-tap/releases/download/iraf-st4gem-1.2.1"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d65a6fb197905a8b67708a4f916df9503b2e70fb982f83f5480b2bd5882f463"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdcd1f70ffd44720ad2b04d98720b45e7418603dff324505920362e5915b5b8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11cf653274761d3aa152d190d5e7bed15a10627e5ef5b81736f75b8af048c0f6"
    sha256 cellar: :any_skip_relocation, sequoia:       "73021cc4412df8555438c4bfd2ab53c39fcb572f96cab411a940251b85579109"
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
