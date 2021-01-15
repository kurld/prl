#!/usr/bin/python
# Usage: parseTemplate.py template.yaml values.ini
# values in ini format separated by newline, no spaces between '='

import jinja2
import sys
import os
from subprocess import check_output


sourceTemplate = sys.argv[1] 
sourceValues = sys.argv[2]
toRender={}

with open(sourceTemplate, 'r') as f:
  t = f.read()
f.close()

template = jinja2.Template(t)

with open(sourceValues, 'r') as f:
  val = f.read().splitlines()
f.close()
  
for i in val:
  (k, v) = i.split("=")
  toRender[k] = v

osEnv = dict(os.environ)
for key in osEnv.keys():
   toRender[key] = osEnv[key]


parsed = template.render(toRender)


targetTemplate = 'parsed_' + (check_output(['basename', sourceTemplate], universal_newlines=True)).rstrip()

with open(targetTemplate, 'w') as fh:
  fh.write(parsed)
  fh.write('\n')
fh.close()

