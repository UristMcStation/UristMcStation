import argparse, re, sys
from os import path, walk
from tqdm import tqdm
import dmitool # This import is why this script is here. If someone can import this file cleanly from [repo root]/test/ instead, feel free

opt = argparse.ArgumentParser()
opt.add_argument('dir', help='The directory to scan for *.dmi files with an excess number of icon states.')
opt.add_argument('-q', '--quiet', default=False, dest="quiet", action='store_true', help="Suppress the progress bar, useful is the tqdm is bloating the logging")
args = opt.parse_args()

if(not path.isdir(args.dir)):
    print('Not a directory')
    sys.exit(1)

bad_dmi_files = []

icons_to_process = []
# This section parses all *.dmi files in the given directory, recursively.
for root, subdirs, files in walk(args.dir):
    for filename in files:
        if filename.endswith('.dmi'):
            icons_to_process.append(path.join(root, filename))

enum = range(len(icons_to_process))
if __name__ == "__main__" and not args.quiet:
    enum = tqdm(enum)

for i in enum:
    file_path = icons_to_process[i]
    try:
        dmi_info = dmitool.info(file_path)
        number_of_icon_states = len(dmi_info["states"])
        if number_of_icon_states > 512:
            bad_dmi_files.append((
                file_path,
                f"had too many icon states. {number_of_icon_states}/512."
            ))
    except Exception:
        bad_dmi_files.append((file_path, "is possibly empty or corrupted"))


if len(bad_dmi_files) > 0:
    for dmi_path, message in bad_dmi_files:
        print("{0} {1}.".format(dmi_path, message), file=sys.stderr)
    sys.exit(1)
