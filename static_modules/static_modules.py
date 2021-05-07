
import argparse
import json
import os
import magic


def main():
    args = analyser_commande()
    
    if args.json:
        rmap = load_rmap(args.json)
        mod_list = find_static(rmap)
        print_modules(mod_list)
    if args.modules:
        mod_list = load_modules(args.modules)
        mod_map = get_mod_map(mod_list)
        write_modules(mod_map)


def analyser_commande():
    parser = argparse.ArgumentParser(description='Find static executables from provided JSON file.')
    parser.add_argument('-j', '--json', type=str, help='Path to JSON file')
    parser.add_argument('-m', '--modules', type=str, help='Path to list of modules')
    return parser.parse_args()


def load_rmap(filepath):
    rmap = None
    with open(filepath) as f:
        rmap = json.loads(f.read())['reverseMapT']
    return rmap


def load_modules(filepath):
    mod_list = list()
    with open(filepath) as f:
        while (mod := f.readline()):
            mod_list.append(mod)
    return mod_list


def write_modules(mod_map):
    with open('unique_static_modules.json', 'w') as json_file:
        json.dump(mod_map, json_file)


def find_static(rmap):
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
    return module_list


def print_modules(mod_list):
    print("The following modules contain static executables :")
    for module in mod_list:
        print(module)


def is_static(filepath):
    return 'static' in magic.from_file(filepath)


def get_mod_map(mod_list):
    mod_map = dict()
    for module in mod_list:
        str_list = module.rstrip(')\n').split('(')
        env = str_list[1] if len(str_list) == 2 else None
        key, version = str_list[0].split('/')
        if key not in mod_map:
            mod_map[key] = {'versions': [], 'env': []}
        mod_map[key]['versions'].append(version)
        if env:
            mod_map[key]['env'].append(env)
    return mod_map

if __name__=='__main__':
    main()
