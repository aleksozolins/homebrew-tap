# orgwarrior and orgwarrior-web in one formula: two formulae can't share a
# Python package, and the page uses orgwarrior's engine.
class Orgwarrior < Formula
  include Language::Python::Virtualenv

  desc "Taskwarrior-style command line and web page for Org mode's agenda"
  homepage "https://github.com/aleksozolins/orgwarrior"
  url "https://files.pythonhosted.org/packages/source/o/orgwarrior/orgwarrior-0.4.0.tar.gz"
  sha256 "bd479d0aeedcd6cfdc4274961f2914b53785caa191e6dadcc9ddbc5f27700683"
  license "GPL-3.0-or-later"

  depends_on "python@3.13"

  resource "orgwarrior-web" do
    url "https://files.pythonhosted.org/packages/source/o/orgwarrior-web/orgwarrior_web-0.4.0.tar.gz"
    sha256 "bdea45f9acec2cf25bb8d8e5d2f1f14f8add0895d2558d93d22c24f781c6d273"
  end

  def install
    # Both commands linked by hand: orgwarrior-web's package brings
    # orgwarrior's command too, so pip_install_and_link, which links only what
    # orgwarrior newly adds, found it there already and linked nothing.
    venv = virtualenv_create(libexec, "python3.13")
    venv.pip_install resources
    venv.pip_install buildpath
    bin.install_symlink libexec/"bin/orgwarrior", libexec/"bin/orgwarrior-web"
    man1.install "docs/orgwarrior.1"
  end

  def caveats
    <<~EOS
      orgwarrior talks to a running Emacs daemon (emacs --daemon), Emacs 29
      or later, from Homebrew or wherever yours comes from.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/orgwarrior --version")
    assert_match "orgwarrior-web", shell_output("#{bin}/orgwarrior-web --help")
  end
end
