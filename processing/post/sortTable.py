#!/usr/bin/env python
# -*- coding: UTF-8 no BOM -*-

import os,re,sys,string
import numpy as np
from optparse import OptionParser
import damask

scriptID   = string.replace('$Id$','\n','\\n')
scriptName = os.path.splitext(scriptID.split()[1])[0]

# --------------------------------------------------------------------
#                                MAIN
# --------------------------------------------------------------------

parser = OptionParser(option_class=damask.extendableOption, usage='%prog options [file[s]]', description = """
Sort rows by given column label(s).

Examples:
With coordinates in columns "x", "y", and "z"; sorting with x slowest and z fastest varying index: --label x,y,z.
""", version = scriptID)


parser.add_option('-l','--label',   dest='keys', action='extend', metavar='<string LIST>',
                                    help='list of column labels (a,b,c,...)')
parser.add_option('-r','--reverse', dest='reverse', action='store_true',
                                    help='reverse sorting')

parser.set_defaults(key = [])
parser.set_defaults(reverse = False)

(options,filenames) = parser.parse_args()

if options.keys == None:
  parser.error('No sorting column(s) specified.')

options.keys.reverse()                                                    # numpy sorts with most significant column as last

# ------------------------------------------ setup file handles ---------------------------------------  

files = []
if filenames == []:
  files.append({'name':'STDIN', 'input':sys.stdin, 'output':sys.stdout, 'croak':sys.stderr})
else:
  for name in filenames:
    if os.path.exists(name):
      files.append({'name':name, 'input':open(name), 'output':open(name+'_tmp','w'), 'croak':sys.stderr})

# ------------------------------------------ loop over input files ---------------------------------------  

for file in files:
  if file['name'] != 'STDIN': file['croak'].write('\033[1m'+scriptName+'\033[0m: '+file['name']+'\n')
  else: file['croak'].write('\033[1m'+scriptName+'\033[0m\n')

  table = damask.ASCIItable(file['input'],file['output'],False)             # make unbuffered ASCII_table
  table.head_read()                                                         # read ASCII header info
  table.info_append(string.replace(scriptID,'\n','\\n') + \
                    '\t' + ' '.join(sys.argv[1:]))

# ------------------------------------------ assemble header ---------------------------------------  

  table.head_write()

# ------------------------------------------ process data ---------------------------------------  

  table.data_readArray()
  cols = []
  for column in table.labels_index(options.keys):
    cols += [table.data[:,column]]

  ind = np.lexsort(cols)
  if options.reverse:
    ind = ind[::-1]

  table.data = table.data[ind]
  table.data_writeArray()

# ------------------------------------------ output result ---------------------------------------  

  table.output_flush()                                      # just in case of buffered ASCII table

  table.input_close()                                                       # close input ASCII table
  if file['name'] != 'STDIN':
    table.output_close()                                                    # close output ASCII table
    os.rename(file['name']+'_tmp',file['name'])                             # overwrite old one with tmp new
