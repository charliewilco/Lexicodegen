import io
import os
from pathlib import Path
import subprocess
import tarfile
import tempfile
import unittest


SCRIPT = Path(__file__).with_name('get-lexicons.sh').resolve()


class RefreshTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.bin = self.root / 'bin'
        self.bin.mkdir()
        curl = self.bin / 'curl'
        curl.write_text('#!/bin/sh\ncase "$2" in *atproto*) cp "$FIXTURE_ROOT/atproto.tar.gz" "$4" ;; *bsky*) cp "$FIXTURE_ROOT/bsky.tar.gz" "$4" ;; *) exit 22 ;; esac\n')
        curl.chmod(0o755)
        self.env = {**os.environ, 'PATH': str(self.bin) + ':' + os.environ['PATH'], 'FIXTURE_ROOT': str(self.root)}
        self.archive('atproto', {'com/test.json': 'protocol', 'tools/test.json': 'tools', 'app/old.json': 'stale', 'internal/test.json': 'private'})
        self.archive('bsky', {'app/bsky/actor/link.json': 'link', 'chat/test.json': 'chat', 'com/ignored.json': 'wrong-owner'})
        (self.root / 'lexicons').mkdir()
        (self.root / 'lexicons/stale.json').write_text('existing')

    def archive(self, repo, files):
        with tarfile.open(self.root / f'{repo}.tar.gz', 'w:gz') as archive:
            for name, content in files.items():
                data = content.encode()
                entry = tarfile.TarInfo(f'{repo}-main/lexicons/{name}')
                entry.size = len(data)
                archive.addfile(entry, io.BytesIO(data))

    def run_script(self, *args):
        return subprocess.run(['sh', str(SCRIPT), *args], cwd=self.root, env=self.env, capture_output=True, text=True)

    def test_combines_canonical_namespaces_and_removes_stale_files(self):
        result = self.run_script()
        self.assertEqual(result.returncode, 0, result.stderr)
        files = sorted(str(path.relative_to(self.root / 'lexicons')) for path in (self.root / 'lexicons').rglob('*.json'))
        self.assertEqual(files, ['app/bsky/actor/link.json', 'chat/test.json', 'com/test.json', 'tools/test.json'])

    def test_failed_second_download_preserves_destination(self):
        self.env['BSKY_URL'] = 'invalid'
        result = self.run_script()
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual((self.root / 'lexicons/stale.json').read_text(), 'existing')

    def test_failed_extraction_preserves_destination(self):
        (self.root / 'bsky.tar.gz').write_text('invalid archive')
        result = self.run_script()
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual((self.root / 'lexicons/stale.json').read_text(), 'existing')

    def test_explicit_archive_keeps_single_source_contract(self):
        self.env['BSKY_URL'] = 'invalid'
        result = self.run_script('atproto', 'custom', 'atproto-main/lexicons')
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual((self.root / 'custom/app/old.json').read_text(), 'stale')
        self.assertFalse((self.root / 'custom/chat').exists())


if __name__ == '__main__':
    unittest.main()
