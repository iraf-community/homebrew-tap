class IrafCtio < Formula
  desc "Tools for the Cerro Tololo Inter-American Observatory"
  homepage "https://github.com/iraf-community/iraf-ctio"
  url "https://github.com/iraf-community/iraf-ctio.git", revision: "a6113fe"
  version "2023.11.12"
  sha256 "987dbc80e2df98624b192a03d7829f717f51aa70580ea7a8ed3ef24f09aa2708"

  bottle do
    root_url "https://github.com/iraf-community/homebrew-tap/releases/download/iraf-ctio-2023.11.12"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "800fab8ca91a74f94f043c2cc48ce48f7249db2e4fb9538a8f7d715d7d7c1f07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f504118ce58d65fb03055b37bc48a11875db5b1dba3f61dfd1d2724f6b6e486"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79a6f51d1bae7c4dab156a8bc994c8cc581e7f95518aa6063f92160a12a11fd7"
    sha256 cellar: :any_skip_relocation, sequoia:       "0d4d6245f8b22ebf916e9ba20b5d029900fa7ab8f0b9bc7c06e64b229a7f0a39"
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
