local com = import 'lib/commodore.libjsonnet';

local dir = std.extVar('output_path');

// fixupDir already drops null objects, so we can use the identity function.
com.fixupDir(dir, function(o) o)
