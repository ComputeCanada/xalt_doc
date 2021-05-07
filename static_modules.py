
import argparse
import json
import os
import magic
import pathlib

def analyser_commande():
    parser = argparse.ArgumentParser(description='Find static executables from provided JSON file.')
    parser.add_argument('filename', type=str, help='fichier JSON')
    return parser.parse_args()



def main():
    # Load reverse map
    filename = analyser_commande().filename
    with open(filename) as f:
        rmap = json.loads(f.read())['reverseMapT']
    
    # Loop over every file in every module path
    module_list = list()
    for path in rmap.keys():
        print(f'Entering {path}')
        for f in os.listdir(path):
            filepath = '/'.join([path, f])
            if not os.path.isfile(filepath): 
                continue
            # If one executable is static, get module name and go to next module
            if (found := is_static(filepath)):
                print(f'Found {filepath}')
                module_list.append(rmap[path])
                break

    # Print results
    print("The following modules contain static executables :")
    for module in module_list:
        print(module)

# 
def is_static(filepath):
    return 'static' in magic.from_file(filepath)

if __name__=='__main__':
    main()