#!/usr/bin/env python3

import subprocess
import sys

extensions = subprocess.check_output(['code', '--list-extensions'])
extensions = [e for e in extensions.decode('utf-8').split('\n') if e]
extensions.sort()
print(' '.join(extensions), end='')
