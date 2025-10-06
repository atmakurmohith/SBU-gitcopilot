"""Simple parser for VM inventory Excel to produce migration recommendations.

Usage: python tools/parse_vm_excel.py <input-xlsx> <output-csv>

The script expects the Excel to have columns: Name, CPU, RAM_GB, Disk_GB, OS, NICs
"""
import sys
import csv
from pathlib import Path

try:
    import openpyxl
except ImportError:
    print('Please pip install openpyxl')
    sys.exit(1)

SIZE_MAP = [
    (2, 'Standard_B1s'),
    (4, 'Standard_B2s'),
    (8, 'Standard_D2s_v3'),
    (16, 'Standard_D4s_v3'),
    (32, 'Standard_D8s_v3'),
]


def pick_size(cpu, ram_gb):
    # naive mapping: pick first size where cpu <= cores and ram sufficient
    for cores, sku in SIZE_MAP:
        if cpu <= cores and ram_gb <= cores * 2:
            return sku
    return SIZE_MAP[-1][1]


def main():
    if len(sys.argv) < 3:
        print('Usage: parse_vm_excel.py input.xlsx output.csv')
        sys.exit(1)

    in_path = Path(sys.argv[1])
    out_path = Path(sys.argv[2])

    wb = openpyxl.load_workbook(in_path)
    ws = wb.active

    rows = list(ws.iter_rows(values_only=True))
    headers = [h.strip() for h in rows[0]]
    data_rows = rows[1:]

    with out_path.open('w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow(['Name','OS','CPU','RAM_GB','Disk_GB','Recommended_VM_SKU','Notes'])
        for r in data_rows:
            d = dict(zip(headers, r))
            name = d.get('Name') or d.get('VM Name') or 'unknown'
            cpu = int(d.get('CPU') or 2)
            ram = int(d.get('RAM_GB') or d.get('RAM') or 4)
            disk = int(d.get('Disk_GB') or d.get('Disk') or 30)
            os_name = (d.get('OS') or 'linux').lower()

            sku = pick_size(cpu, ram)
            notes = []
            if os_name.startswith('win'):
                notes.append('Windows: ensure license & secure password (ADMIN_PASSWORD secret)')
            else:
                notes.append('Linux: ensure SSH key (VM_SSH_PUBLIC_KEY secret)')

            # Defender & Arc recommendation
            notes.append('Enable Azure Defender and onboard to Azure Arc for hybrid management')

            writer.writerow([name, os_name, cpu, ram, disk, sku, '; '.join(notes)])

    print(f'Wrote recommendations to {out_path}')


if __name__ == '__main__':
    main()
