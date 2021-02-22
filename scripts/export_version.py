from re import search
from sys import argv

try:
    ref = argv[1]

    VERSION_MAJOR, VERSION_MINOR, VERSION_REVISION = search(r'v(\d+)\.(\d+)\.(\d+)', ref).groups()

    print(f'##vso[task.setvariable variable=VERSION_MAJOR]{VERSION_MAJOR}')
    print(f'##vso[task.setvariable variable=VERSION_MINOR]{VERSION_MINOR}')
    print(f'##vso[task.setvariable variable=VERSION_REVISION]{VERSION_REVISION}')
except IndexError:
    pass
except AttributeError:
    pass
