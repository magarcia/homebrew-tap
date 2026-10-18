"""Safety checks for the GitHub release-to-formula updater."""

import copy
from importlib.machinery import SourceFileLoader
from importlib.util import module_from_spec, spec_from_loader
from pathlib import Path
import tempfile
import unittest


SCRIPT = Path(__file__).with_name("update-expensify")
LOADER = SourceFileLoader("update_expensify", str(SCRIPT))
SPEC = spec_from_loader(LOADER.name, LOADER)
updater = module_from_spec(SPEC)
LOADER.exec_module(updater)


def release_fixture(version="0.1.0"):
    tag = f"v{version}"
    assets = []
    for index, (system, arch) in enumerate(updater.PLATFORMS):
        name = f"expensify_{tag}_{system}_{arch}.tar.gz"
        assets.append({
            "name": name,
            "browser_download_url": f"https://github.com/magarcia/expensify-cli/releases/download/{tag}/{name}",
            "digest": f"sha256:{index + 1:064x}",
        })
    return {"tag_name": tag, "draft": False, "prerelease": False, "assets": assets}


class ReleaseMetadataTests(unittest.TestCase):
    def test_renders_all_platforms_and_release_hashes(self):
        formula = updater.render_formula(release_fixture())
        self.assertNotIn('\n  version "', formula)
        for index, (system, arch) in enumerate(updater.PLATFORMS):
            self.assertIn(
                f"https://github.com/magarcia/expensify-cli/releases/download/v0.1.0/"
                f"expensify_v0.1.0_{system}_{arch}.tar.gz",
                formula,
            )
            self.assertIn(f'sha256 "{index + 1:064x}"', formula)
        self.assertIn('pkgshare.install "skills"', formula)
        self.assertIn("--dry-run --no-input", formula)
        self.assertIn("--output llm", formula)

    def test_ignores_other_release_artifacts(self):
        release = release_fixture()
        release["assets"].extend([{"name": "checksums.txt"}, {"name": "expensify_v0.1.0_windows_arm64.zip"}])
        self.assertEqual(updater.render_formula(release_fixture()), updater.render_formula(release))

    def test_rejects_drafts_and_prereleases(self):
        for field in ("draft", "prerelease"):
            for invalid in (True, None, "false", 0):
                with self.subTest(field=field, value=invalid):
                    release = release_fixture()
                    release[field] = invalid
                    with self.assertRaisesRegex(ValueError, "published stable"):
                        updater.render_formula(release)

    def test_rejects_invalid_tags(self):
        for tag in (None, 1, "0.1.0", "v01.0.0", "v0.01.0", "v0.1.00", "v0.1", "v1.2.3-rc.1", "v1.2.3+build", "v1.2.3\n"):
            with self.subTest(tag=tag):
                release = release_fixture()
                release["tag_name"] = tag
                with self.assertRaises(ValueError):
                    updater.render_formula(release)

    def test_rejects_missing_required_platform(self):
        release = release_fixture()
        release["assets"].pop()
        with self.assertRaisesRegex(ValueError, "Missing release assets.*linux_amd64"):
            updater.render_formula(release)

    def test_rejects_duplicate_required_platform(self):
        release = release_fixture()
        release["assets"].append(copy.deepcopy(release["assets"][0]))
        with self.assertRaisesRegex(ValueError, "Duplicate release asset"):
            updater.render_formula(release)

    def test_rejects_missing_and_malformed_digests(self):
        for digest in (None, "", "sha256:", "sha256:" + "1" * 63, "sha256:" + "g" * 64, "sha512:" + "1" * 64):
            with self.subTest(digest=digest):
                release = release_fixture()
                release["assets"][0]["digest"] = digest
                with self.assertRaisesRegex(ValueError, "SHA-256 digest"):
                    updater.render_formula(release)

    def test_accepts_uppercase_digest_and_normalizes_it(self):
        release = release_fixture()
        release["assets"][0]["digest"] = "sha256:" + "A" * 64
        self.assertIn('sha256 "' + "a" * 64 + '"', updater.render_formula(release))

    def test_rejects_noncanonical_download_urls(self):
        original = release_fixture()["assets"][0]["browser_download_url"]
        for url in (None, original.replace("github.com", "example.com"), original.replace("https:", "http:"), original + "?download=1"):
            with self.subTest(url=url):
                release = release_fixture()
                release["assets"][0]["browser_download_url"] = url
                with self.assertRaisesRegex(ValueError, "Unexpected download URL"):
                    updater.render_formula(release)

    def test_rejects_invalid_metadata_shapes(self):
        for release in (None, [], {**release_fixture(), "assets": None}, {**release_fixture(), "assets": [None]}):
            with self.subTest(release=release):
                with self.assertRaises(ValueError):
                    updater.render_formula(release)


class UpdateFormulaTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.directory = Path(self.temporary.name)
        self.path = self.directory / "expensify.rb"
        self.unrelated = self.directory / "other.rb"
        self.unrelated.write_text("unrelated formula\n", encoding="utf-8")

    def test_initial_write_then_identical_release_is_noop(self):
        release = release_fixture()
        self.assertTrue(updater.update_formula(release, self.path))
        stat = self.path.stat()
        self.assertFalse(updater.update_formula(release, self.path))
        self.assertEqual(stat.st_mtime_ns, self.path.stat().st_mtime_ns)
        self.assertEqual("unrelated formula\n", self.unrelated.read_text(encoding="utf-8"))
        self.assertEqual({"expensify.rb", "other.rb"}, {path.name for path in self.directory.iterdir()})

    def test_upgrades_versions_numerically(self):
        updater.update_formula(release_fixture("0.9.0"), self.path)
        self.assertTrue(updater.update_formula(release_fixture("0.10.0"), self.path))
        self.assertIn('/releases/download/v0.10.0/', self.path.read_text(encoding="utf-8"))

    def test_rejects_downgrade_without_modifying_formula(self):
        updater.update_formula(release_fixture("1.2.0"), self.path)
        previous = self.path.read_bytes()
        with self.assertRaisesRegex(ValueError, "Refusing to downgrade"):
            updater.update_formula(release_fixture("0.99.0"), self.path)
        self.assertEqual(previous, self.path.read_bytes())

    def test_invalid_release_does_not_modify_formula(self):
        updater.update_formula(release_fixture(), self.path)
        previous = self.path.read_bytes()
        invalid = release_fixture("0.2.0")
        invalid["assets"].pop()
        with self.assertRaises(ValueError):
            updater.update_formula(invalid, self.path)
        self.assertEqual(previous, self.path.read_bytes())

    def test_refuses_to_replace_formula_without_version(self):
        self.path.write_text("unexpected content\n", encoding="utf-8")
        with self.assertRaisesRegex(ValueError, "no recognizable version"):
            updater.update_formula(release_fixture(), self.path)
        self.assertEqual("unexpected content\n", self.path.read_text(encoding="utf-8"))

    def test_version_must_come_from_canonical_release_url(self):
        previous = updater.render_formula(release_fixture("1.2.0")).replace(
            "https://github.com/magarcia/expensify-cli/releases/download/",
            "https://example.com/releases/download/",
        )
        self.path.write_text(previous, encoding="utf-8")
        with self.assertRaisesRegex(ValueError, "no recognizable version"):
            updater.update_formula(release_fixture("1.3.0"), self.path)
        self.assertEqual(previous, self.path.read_text(encoding="utf-8"))


if __name__ == "__main__":
    unittest.main()
