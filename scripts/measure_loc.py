#!/usr/bin/env python3
"""
DevFlow Production Source Lines of Code (SLOC) Counter
Strictly follows TrainPlex evaluation guidelines:
- Excludes tests, dependencies, .git, build/dist, coverage, and generated files.
- Analyzes Java, TypeScript, JavaScript, SQL, HTML, CSS source files.
"""

import os
import sys

EXCLUDE_DIRS = {
    '.git', 'node_modules', 'dist', 'build', 'target', 'out',
    '.next', '.turbo', '.cache', 'coverage', '.nyc_output',
    'test', 'tests', '__tests__', 'test-results', 'docs'
}

SOURCE_EXTENSIONS = {
    '.java': 'Java',
    '.ts': 'TypeScript',
    '.tsx': 'TypeScript (React)',
    '.js': 'JavaScript',
    '.jsx': 'JavaScript (React)',
    '.sql': 'SQL Migrations',
    '.css': 'CSS',
    '.html': 'HTML'
}

def is_test_file(filename, filepath):
    lower_name = filename.lower()
    lower_path = filepath.lower()
    if 'test' in lower_name or 'spec' in lower_name:
        return True
    if any(td in lower_path.replace('\\', '/').split('/') for td in ['test', 'tests', '__tests__']):
        return True
    return False

def count_file_lines(filepath):
    sloc = 0
    total = 0
    try:
        with open(filepath, 'r', encoding='utf-8', errors='ignore') as fp:
            for line in fp:
                total += 1
                stripped = line.strip()
                if stripped and not stripped.startswith('//') and not stripped.startswith('#') and not stripped.startswith('/*') and not stripped.startswith('*'):
                    sloc += 1
    except Exception as e:
        return 0, 0
    return sloc, total

def measure_repository(root_dir='.'):
    lang_sloc = {}
    lang_files = {}
    total_sloc = 0
    total_lines = 0
    total_files = 0

    for root, dirs, files in os.walk(root_dir):
        # Filter out excluded directories in-place
        dirs[:] = [d for d in dirs if d not in EXCLUDE_DIRS and 'test' not in d.lower()]

        for f in files:
            ext = os.path.splitext(f)[1].lower()
            if ext in SOURCE_EXTENSIONS:
                filepath = os.path.join(root, f)
                if is_test_file(f, filepath):
                    continue

                lang = SOURCE_EXTENSIONS[ext]
                sloc, lines = count_file_lines(filepath)
                if sloc > 0:
                    lang_sloc[lang] = lang_sloc.get(lang, 0) + sloc
                    lang_files[lang] = lang_files.get(lang, 0) + 1
                    total_sloc += sloc
                    total_lines += lines
                    total_files += 1

    print("=" * 65)
    print(" DevFlow Production SLOC Measurement Report")
    print("=" * 65)
    print(f"{'Language':<25} | {'Files':<8} | {'SLOC':<12}")
    print("-" * 65)
    for lang in sorted(lang_sloc.keys(), key=lambda l: lang_sloc[l], reverse=True):
        print(f"{lang:<25} | {lang_files[lang]:<8} | {lang_sloc[lang]:<12,}")
    print("-" * 65)
    print(f"{'Total Production SLOC':<25} | {total_files:<8} | {total_sloc:<12,}")
    print(f"Total Physical Lines: {total_lines:,}")
    print("=" * 65)
    
    target = 500000
    if total_sloc >= target:
        print(f"PASS: Production SLOC {total_sloc:,} exceeds target of {target:,} (+{total_sloc - target:,})")
    else:
        print(f"GAP: Need {target - total_sloc:,} more SLOC to meet {target:,} target.")

    return total_sloc

if __name__ == '__main__':
    measure_repository()
