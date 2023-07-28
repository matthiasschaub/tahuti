#! /bin/bash
#
# continuously sync desks between Earth and Mars
#
watch "rsync -zr tahuti/* zod/tahuti"
