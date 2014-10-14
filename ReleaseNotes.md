Version 0.6
===========


This version brings OERPScenario compatibility with behave 1.2.4. 

Things to change in your features and steps:

1. the tools which are defined in `support/tools.py` are no longer available in
the `globals()` of your step definitions, so you need to import them manually:

    from support.tools import model, puts, set_trace, assert_equal

There is also a shortcut available:

    from support import *



2. There has been a change in the way the `ctx.feature.filename` attribute is
managed. If your step definitions use this variable, e.g. to get a path to a
`data` directory to load files, you will need to adapt. For the record the
patch applied to the basic step definitions is:

    === modified file 'features/steps/tools.py'
    --- features/steps/tools.py     2014-08-27 13:46:19 +0000
    +++ features/steps/tools.py     2014-08-28 06:41:58 +0000
    @@ -38,9 +38,9 @@
     @given('"{model_name}" is imported from CSV "{csvfile}" using delimiter "{sep}"')
     def impl(ctx, model_name, csvfile, sep=","):
         tmp_path = ctx.feature.filename.split(os.path.sep)
    -    tmp_path = tmp_path[1: tmp_path.index('features')] + ['data', csvfile]
    +    tmp_path = tmp_path[: tmp_path.index('features')] + ['data', csvfile]
         tmp_path = [str(x) for x in tmp_path]
    -    path = os.path.join('/', *tmp_path)
    +    path = os.path.join(*tmp_path)
         assert os.path.exists(path)
         data = csv.reader(open(path, 'rb'), delimiter=str(sep))
         head = data.next()

3. If you step definitions used the helper functions from `dsl.py` to parse
domain from table data for instance, you need to import them. They were
extracted to a new module `dsl_helper` to ease things and avoid a mess with
duplicate step definitions:

    from dsl_helpers import (parse_domain,
                             build_search_domain,
                             parse_table_values,
                             )


