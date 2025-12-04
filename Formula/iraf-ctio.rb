class IrafCtio < Formula
  desc "Tools for the Cerro Tololo Inter-American Observatory"
  homepage "https://github.com/iraf-community/iraf-ctio"
  url "https://github.com/iraf-community/iraf-ctio.git", revision: "a6113fe"
  version "202.11.12"
  sha256 "987dbc80e2df98624b192a03d7829f717f51aa70580ea7a8ed3ef24f09aa2708"

  bottle do
    root_url "https://github.com/iraf-community/homebrew-tap/releases/download/iraf-ctio-2023-11-12"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7128d130795e43f71a9f78ad42f0ae3891a1579e5064e8049b858719cdd13a3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78dad784ed327576cacfad3a108965f60d95cbc3f73dbe6e3802f2651ae464aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc975f9b80b24e8d584aea336e938f50fef49bfd96a9c1023b6ed33229289de7"
    sha256 cellar: :any_skip_relocation, sequoia:       "22a8c4defd463504a8f1d02c0cf4103f436ea957471d253ecd216a641395eb8a"
  end

  IRAF_PACKAGE = "ctio".freeze

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
