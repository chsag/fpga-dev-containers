from importlib.util import spec_from_file_location, module_from_spec
from glob import glob
from vunit import VUnit

if __name__ == '__main__':
    test_environment = VUnit.from_argv()
    test_lib = test_environment.add_library('test')

    test_files = glob('./test/test_*.py')

    for path in test_files:
        spec = spec_from_file_location('test', path)
        test = module_from_spec(spec)
        spec.loader.exec_module(test)
        test.add_tests(test_environment, test_lib)

    test_environment.main()
