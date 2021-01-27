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

    for test in tests:
        if hasattr(test, 'add_source_files'):
            test.add_source_files(test_lib)

        if hasattr(test, 'add_configs'):
            test.add_configs(test_lib)

    test_environment.main()
