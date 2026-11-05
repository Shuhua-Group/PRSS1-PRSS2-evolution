#!/usr/bin/env python3
"""Export the supplied Table S1 T2T sheet without changing its coordinates.

Uses only the Python standard library. Writes coordinates, a BED file, an
assembly manifest, and a QC report. The input workbook is not modified.
"""
import argparse
import csv
import posixpath
import re
import xml.etree.ElementTree as ET
from collections import defaultdict
from pathlib import Path
from zipfile import ZipFile

NS = {'s': 'http://schemas.openxmlformats.org/spreadsheetml/2006/main'}
REL = 'http://schemas.openxmlformats.org/officeDocument/2006/relationships'


def sheet_rows(path, name):
    with ZipFile(path) as archive:
        workbook = ET.fromstring(archive.read('xl/workbook.xml'))
        rels = ET.fromstring(archive.read('xl/_rels/workbook.xml.rels'))
        targets = {r.attrib['Id']: r.attrib['Target'] for r in rels}
        sheets = workbook.findall('s:sheets/s:sheet', NS)
        sheet = next((s for s in sheets if s.attrib['name'] == name), None)
        if sheet is None:
            raise ValueError(f'Sheet not found: {name}')
        target = targets[sheet.attrib[f'{{{REL}}}id']]
        member = target.lstrip('/') if target.startswith('/') else posixpath.normpath('xl/' + target)
        strings = []
        if 'xl/sharedStrings.xml' in archive.namelist():
            root = ET.fromstring(archive.read('xl/sharedStrings.xml'))
            strings = [''.join(t.text or '' for t in si.iter(f"{{{NS['s']}}}t")) for si in root]
        root = ET.fromstring(archive.read(member))
        for row in root.findall('s:sheetData/s:row', NS):
            values = {}
            for cell in row.findall('s:c', NS):
                col = re.match('[A-Z]+', cell.attrib['r'])[0]
                typ = cell.attrib.get('t')
                value = cell.find('s:v', NS)
                text = value.text if value is not None else ''
                if typ == 's':
                    text = strings[int(text)]
                elif typ == 'inlineStr':
                    text = ''.join(t.text or '' for t in cell.iter(f"{{{NS['s']}}}t"))
                values[col] = (text or '').strip()
            yield int(row.attrib['r']), values


def write_tsv(path, header, rows):
    with path.open('w', newline='') as stream:
        writer = csv.writer(stream, delimiter='\t')
        writer.writerow(header)
        writer.writerows(rows)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--table', required=True, type=Path)
    parser.add_argument('--sheet', default='Apes T2T Genome')
    parser.add_argument('--out-dir', required=True, type=Path)
    args = parser.parse_args()
    records, qc, current = [], [], ['', '', '']
    for rownum, row in sheet_rows(args.table, args.sheet):
        if rownum == 1 or not row.get('D'):
            continue
        if row.get('A'):
            current = [row.get(c, '') for c in 'ABC']
        else:
            current = [row.get(c) or current[i] for i, c in enumerate('ABC')]
        if not all(current):
            raise ValueError(f'Incomplete species/assembly/contig at row {rownum}')
        match = re.fullmatch(r'(\d+)\s*-\s*(\d+)', row['D'])
        if not match:
            raise ValueError(f'Invalid position at row {rownum}: {row["D"]}')
        start, end = map(int, match.groups())
        if start < 1 or end < start:
            raise ValueError(f'Invalid interval at row {rownum}')
        length, index = int(row['E']), int(row['F'])
        span = end - start + 1
        rec = [*current, start, end, length, index, span]
        records.append(rec)
        if span != length:
            qc.append([current[0], index, 'length_mismatch', f'position_span={span}; table_length={length}'])
    if not records:
        raise ValueError('No coordinates found')
    seen = set()
    for rec in records:
        key = (rec[1], rec[2], rec[6])
        if key in seen:
            raise ValueError(f'Duplicate assembly/contig/copy index: {key}')
        seen.add(key)
    grouped = defaultdict(list)
    for rec in records:
        grouped[(rec[1], rec[2])].append(rec)
    for group in grouped.values():
        for i, a in enumerate(group):
            for b in group[i + 1:]:
                overlap = min(a[4], b[4]) - max(a[3], b[3]) + 1
                if overlap > 0:
                    qc.append([a[0], f'{a[6]},{b[6]}', 'overlap', f'overlap_bp={overlap}'])
    args.out_dir.mkdir(parents=True, exist_ok=True)
    write_tsv(args.out_dir / 'table_s1_t2t.tsv',
              ['species', 'assembly', 'contig', 'start', 'end', 'table_length', 'copy_index', 'position_span'], records)
    assemblies = list(dict.fromkeys(tuple(r[:3]) for r in records))
    write_tsv(args.out_dir / 'assemblies.tsv', ['species', 'assembly', 'contig'], assemblies)
    with (args.out_dir / 'table_s1_t2t.bed').open('w') as stream:
        writer = csv.writer(stream, delimiter='\t')
        for r in records:
            slug = re.sub(r'[^a-z0-9]+', '_', r[0].lower()).strip('_')
            writer.writerow([r[2], r[3] - 1, r[4], f'{slug}_copy{r[6]}', 0, '.'])
    write_tsv(args.out_dir / 'coordinate_qc.tsv', ['species', 'copy_index', 'issue', 'details'], qc)
    print(f'Exported {len(records)} entries from {len(assemblies)} assemblies; {len(qc)} QC flags.')
    print('Position and table_length preserved. BED assumes 1-based inclusive source positions; strand is unspecified.')


if __name__ == '__main__':
    main()
