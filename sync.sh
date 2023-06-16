#! /bin/bash
#
# continuously sync desks between Earth and Mars
#
watch "rsync -zr splt-exps/* zod/splt-exps"
