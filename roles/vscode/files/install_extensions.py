#!/usr/bin/env python3

import subprocess
import sys

extensions = subprocess.check_output(['code', '--list-extensions'])
extensions = [e for e in extensions.decode('utf-8').split('\n') if e]

for extension in sys.argv[1:]:
    if extension not in extensions:
        subprocess.check_call(['code', '--install-extension', extension, '--force'])
        print('Installing %s', extension)
