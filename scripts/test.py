from importlib.util import spec_from_file_location, module_from_spec
from glob import iglob
from itertools import chain
from vunit import VUnit

if __name__ == '__main__':
    test_environment = VUnit.from_argv()
    test_lib = test_environment.add_library('test')

    for f in chain(
        iglob('./external/**/src/**/*.vhd', recursive=True),
        iglob('./src/**/*.vhd', recursive=True),
        iglob('./test/**/*.vhd', recursive=True)
    ):
        test_lib.add_source_file(f)

    for path in iglob('./test/test_*.py'):
        spec = spec_from_file_location('test', path)
        test = module_from_spec(spec)
        spec.loader.exec_module(test)
        test.add_configs(test_lib)

    test_environment.main()
