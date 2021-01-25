from importlib.util import spec_from_file_location, module_from_spec
from glob import iglob
from pathlib import Path
from itertools import chain
from vunit import VUnit


if __name__ == '__main__':
    tests = []
    for path in iglob('./test/test_*.py'):
        spec = spec_from_file_location('test', path)
        test = module_from_spec(spec)
        spec.loader.exec_module(test)
        tests.append(test)

    test_environment = VUnit.from_argv()

    for test in tests:
        if hasattr(test, 'add_libraries'):
            test.add_libraries(test_environment)

    test_lib = test_environment.add_library('test')

    for f in chain(
        iglob('./test/**/*.vhd', recursive=True),
        iglob('./src/**/*.vhd', recursive=True),
        iglob('./external/**/src/**/*.vhd', recursive=True)
    ):
        try:
            test_lib.get_source_files(f'*{Path(f).stem}.vhd')
        except:
            test_lib.add_source_file(f)
            print(f)

    for test in tests:
        if hasattr(test, 'add_configs'):
            test.add_configs(test_lib)

    test_environment.main()
