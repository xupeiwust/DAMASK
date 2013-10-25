#!/usr/bin/env python
# -*- coding: UTF-8 no BOM -*-

import os,sys,string,re,math,numpy,itertools
import damask
from optparse import OptionParser, OptionGroup, Option, SUPPRESS_HELP
from scipy import ndimage
from multiprocessing import Pool

scriptID = '$Id$'
scriptName = scriptID.split()[1]

#--------------------------------------------------------------------------------------------------
class extendedOption(Option):
#--------------------------------------------------------------------------------------------------
# used for definition of new option parser action 'extend', which enables to take multiple option arguments
# taken from online tutorial http://docs.python.org/library/optparse.html

   ACTIONS = Option.ACTIONS + ("extend",)
   STORE_ACTIONS = Option.STORE_ACTIONS + ("extend",)
   TYPED_ACTIONS = Option.TYPED_ACTIONS + ("extend",)
   ALWAYS_TYPED_ACTIONS = Option.ALWAYS_TYPED_ACTIONS + ("extend",)

   def take_action(self, action, dest, opt, value, values, parser):
       if action == "extend":
           lvalue = value.split(",")
           values.ensure_value(dest, []).extend(lvalue)
       else:
           Option.take_action(self, action, dest, opt, value, values, parser)

def grainCoarsenLocal(microLocal,ix,iy,iz,window): 
   interfacialEnergy = lambda A,B: 1.0
   struc = ndimage.generate_binary_structure(3,3)
   winner = numpy.where(numpy.in1d(microLocal,options.black).reshape(microLocal.shape),
                        microLocal,0)                                                               # zero out non-blacklisted microstructures
   diffusedMax = (winner > 0).astype(float)                                                         # concentration of immutable microstructures
   boundingSlice = ndimage.measurements.find_objects(microLocal)                                    # bounding boxes of each distinct microstructure region
   diffused = {}
   for grain in set(numpy.unique(microLocal)) - set(options.black) - (set([0])):                    # all microstructures except immutable ones
     mini = [max(0, boundingSlice[grain-1][i].start - window) for i in range(3)]                    # upper right of expanded bounding box
     maxi = [min(microLocal.shape[i], boundingSlice[grain-1][i].stop + window) for i in range(3)]   # lower left  of expanded bounding box
     microWindow = microLocal[mini[0]:maxi[0],mini[1]:maxi[1],mini[2]:maxi[2]]
     grainCharFunc = microWindow==grain
     neighbours = set(numpy.unique(microWindow[ndimage.morphology.binary_dilation(grainCharFunc,structure=struc)]))\
                - set([grain]) - set(options.black)                                                 # who is on my boundary?
     try:                                                                                           # has grain been diffused previously?
       diff = diffused[grain].copy()                                                                # yes: use previously diffused grain
     except:  
       diffused[grain] = ndimage.filters.gaussian_filter((grainCharFunc).astype(float),options.d)   # no: diffuse grain with unit speed
       diff = diffused[grain].copy()
     if len(neighbours) == 1:
       speed = interfacialEnergy(grain,neighbours.pop())                                            # speed proportional to interfacial energy between me and neighbour
       diff = speed*diff + (1.-speed)*(grainCharFunc)                                               # rescale diffused microstructure by speed
     else:
       tiny = 0.001
       numerator = numpy.zeros(microWindow.shape)
       denominator = numpy.zeros(microWindow.shape)
       weights = {grain: diff + tiny}
       for i in neighbours: 
         miniI = [max(0, boundingSlice[i-1][j].start - window) for j in range(3)]                   # bounding box of neighbour
         maxiI = [min(microLocal.shape[j], boundingSlice[i-1][j].stop + window) for j in range(3)]
         miniCommon = [max(mini[j], boundingSlice[i-1][j].start - window) for j in range(3)]        # intersection of mine and neighbouring bounding box
         maxiCommon = [min(maxi[j], boundingSlice[i-1][j].stop  + window) for j in range(3)]
         weights[i] = tiny*numpy.ones(microWindow.shape)
         try:                                                                                       # has neighbouring grain been diffused previously?
           weights[i][miniCommon[0] - mini[0]:maxiCommon[0] - mini[0],\
                      miniCommon[1] - mini[1]:maxiCommon[1] - mini[1],\
                      miniCommon[2] - mini[2]:maxiCommon[2] - mini[2]] = diffused[i][miniCommon[0] - miniI[0]:maxiCommon[0] - miniI[0],\
                                                                                     miniCommon[1] - miniI[1]:maxiCommon[1] - miniI[1],\
                                                                                     miniCommon[2] - miniI[2]:maxiCommon[2] - miniI[2]] + tiny
         except:                                                                                    # no: diffuse neighbouring grain with unit speed
           diffused[i] = ndimage.filters.gaussian_filter((microLocal[miniI[0]:maxiI[0],\
                                                                     miniI[1]:maxiI[1],\
                                                                     miniI[2]:maxiI[2]]==i).astype(float),options.d)
           weights[i][miniCommon[0] - mini[0]:maxiCommon[0] - mini[0],\
                      miniCommon[1] - mini[1]:maxiCommon[1] - mini[1],\
                      miniCommon[2] - mini[2]:maxiCommon[2] - mini[2]] = diffused[i][miniCommon[0] - miniI[0]:maxiCommon[0] - miniI[0],\
                                                                                     miniCommon[1] - miniI[1]:maxiCommon[1] - miniI[1],\
                                                                                     miniCommon[2] - miniI[2]:maxiCommon[2] - miniI[2]] + tiny
       for grainA,grainB in itertools.combinations(neighbours,2):                                   # combinations of possible triple junctions
         speed = interfacialEnergy(grain,grainA) +\
                 interfacialEnergy(grain,grainB) -\
                 interfacialEnergy(grainA,grainB)                                                   # speed of the triple junction
         weight = weights[grainA] * weights[grainB]
         if numpy.any(weight > 0.01):                                                               # strongly interacting triple junction?
           weight *= weights[grain]
           numerator += weight*(speed*diff + (1.-speed)*(grainCharFunc))
           denominator += weight
       
       diff = numerator/denominator                                                                 # weighted sum of strongly interacting triple junctions
     
     winner[mini[0]:maxi[0],\
            mini[1]:maxi[1],\
            mini[2]:maxi[2]][diff > diffusedMax[mini[0]:maxi[0],\
                                                mini[1]:maxi[1],\
                                                mini[2]:maxi[2]]] = grain                           # remember me ...
     diffusedMax[mini[0]:maxi[0],\
                 mini[1]:maxi[1],\
                 mini[2]:maxi[2]] = numpy.maximum(diff,diffusedMax[mini[0]:maxi[0],\
                                                                   mini[1]:maxi[1],\
                                                                   mini[2]:maxi[2]])                # ... and my concentration
   
   return [winner[window:-window,window:-window,window:-window],ix,iy,iz]

def log_result(result):
   ix = result[1]; iy = result[2]; iz = result[3]
   microstructure[ix*stride[0]:(ix+1)*stride[0],iy*stride[1]:(iy+1)*stride[1],iz*stride[2]:(iz+1)*stride[2]] = \
             result[0]
    
#--------------------------------------------------------------------------------------------------
#                                MAIN
#--------------------------------------------------------------------------------------------------
synonyms = {
        'grid':   ['resolution'],
        'size':   ['dimension'],
          }
identifiers = {
        'grid':   ['a','b','c'],
        'size':   ['x','y','z'],
        'origin': ['x','y','z'],
          }
mappings = {
        'grid':            lambda x: int(x),
        'size':            lambda x: float(x),
        'origin':          lambda x: float(x),
        'homogenization':  lambda x: int(x),
        'microstructures': lambda x: int(x),
          }

parser = OptionParser(option_class=extendedOption, usage='%prog options [file[s]]', description = """
Smoothens out interface roughness by simulated curvature flow.
This is achieved by the diffusion of each initially sharply bounded grain volume within the periodic domain
up to a given distance 'd' voxels.
The final geometry is assembled by selecting at each voxel that grain index for which the concentration remains largest.
""" + string.replace(scriptID,'\n','\\n')
)

parser.add_option('-d', '--distance', dest='d', type='int', \
                  help='diffusion distance in voxels [%default]', metavar='float')
parser.add_option('-N', '--smooth', dest='N', type='int', \
                 help='N for curvature flow [%default]')
parser.add_option('-p', '--processors', dest='p', type='int', nargs = 3, \
                  help='number of threads in x,y,z direction %default')
parser.add_option('-b', '--black', dest='black', action='extend', type='string', \
                 help='indices of stationary microstructures', metavar='<LIST>')

parser.set_defaults(d = 1)
parser.set_defaults(N = 1)
parser.set_defaults(p = [1,1,1])
parser.set_defaults(black = [])

(options, filenames) = parser.parse_args()

options.black = map(int,options.black)

#--- setup file handles --------------------------------------------------------------------------   
files = []
if filenames == []:
 files.append({'name':'STDIN',
               'input':sys.stdin,
               'output':sys.stdout,
               'croak':sys.stderr,
              })
else:
 for name in filenames:
   if os.path.exists(name):
     files.append({'name':name,
                   'input':open(name),
                   'output':open(name+'_tmp','w'),
                   'croak':sys.stdout,
                   })

#--- loop over input files ------------------------------------------------------------------------
for file in files:
  if file['name'] != 'STDIN': file['croak'].write('\033[1m'+scriptName+'\033[0m: '+file['name']+'\n')
  else: file['croak'].write('\033[1m'+scriptName+'\033[0m\n')

  theTable = damask.ASCIItable(file['input'],file['output'],labels=False)
  theTable.head_read()

#--- interpret header ----------------------------------------------------------------------------
  info = {
          'grid':   numpy.zeros(3,'i'),
          'size':   numpy.zeros(3,'d'),
          'origin': numpy.zeros(3,'d'),
          'homogenization':  0,
          'microstructures': 0,
         }
  newInfo = {
          'microstructures': 0,
         }
  extra_header = []

  for header in theTable.info:
    headitems = map(str.lower,header.split())
    if len(headitems) == 0: continue
    for synonym,alternatives in synonyms.iteritems():
      if headitems[0] in alternatives: headitems[0] = synonym
    if headitems[0] in mappings.keys():
      if headitems[0] in identifiers.keys():
        for i in xrange(len(identifiers[headitems[0]])):
          info[headitems[0]][i] = \
            mappings[headitems[0]](headitems[headitems.index(identifiers[headitems[0]][i])+1])
      else:
        info[headitems[0]] = mappings[headitems[0]](headitems[1])
    else:
      extra_header.append(header)

  file['croak'].write('grid     a b c:  %s\n'%(' x '.join(map(str,info['grid']))) + \
                      'size     x y z:  %s\n'%(' x '.join(map(str,info['size']))) + \
                      'origin   x y z:  %s\n'%(' : '.join(map(str,info['origin']))) + \
                      'homogenization:  %i\n'%info['homogenization'] + \
                      'microstructures: %i\n'%info['microstructures'])

  if numpy.any(info['grid'] < 1):
    file['croak'].write('invalid grid a b c.\n')
    continue
  if numpy.any(info['size'] <= 0.0):
    file['croak'].write('invalid size x y z.\n')
    continue

#--- read data ------------------------------------------------------------------------------------
  microstructure = numpy.zeros(info['grid'].prod(),'i')
  i = 0
  theTable.data_rewind()
  while theTable.data_read():
    items = theTable.data
    if len(items) > 2:
      if   items[1].lower() == 'of': items = [int(items[2])]*int(items[0])
      elif items[1].lower() == 'to': items = xrange(int(items[0]),1+int(items[2]))
      else:                          items = map(int,items)
    else:                            items = map(int,items)

    s = len(items)
    microstructure[i:i+s] = items
    i += s

#--- do work -------------------------------------------------------------------------------------
  microstructure = microstructure.reshape(info['grid'],order='F')

#--- domain decomposition -------------------------------------------------------------------------  
  numProc = int(options.p[0]*options.p[1]*options.p[2])
  stride = info['grid']/options.p
  if numpy.any(numpy.floor(stride) != stride): 
    file['croak'].write('invalid domain decomposition.\n')
    continue

#--- initialize helper data -----------------------------------------------------------------------  
  window = 4*options.d
  for smoothIter in xrange(options.N):
    extendedMicro = numpy.tile(microstructure,[3,3,3])
    extendedMicro = extendedMicro[(info['grid'][0]-window):-(info['grid'][0]-window),
                                  (info['grid'][1]-window):-(info['grid'][1]-window),
                                  (info['grid'][2]-window):-(info['grid'][2]-window)]
    pool = Pool(processes=numProc)
    for iz in xrange(options.p[2]):
      for iy in xrange(options.p[1]):
        for ix in xrange(options.p[0]):
          pool.apply_async(grainCoarsenLocal,(extendedMicro[ix*stride[0]:(ix+1)*stride[0]+2*window,\
                                                            iy*stride[1]:(iy+1)*stride[1]+2*window,\
                                                            iz*stride[2]:(iz+1)*stride[2]+2*window],\
                                              ix,iy,iz,window), callback=log_result)
        
    pool.close()
    pool.join()

 # --- assemble header -----------------------------------------------------------------------------
  newInfo['microstructures'] = microstructure.max()

#--- report ---------------------------------------------------------------------------------------
  if (newInfo['microstructures'] != info['microstructures']):
    file['croak'].write('--> microstructures: %i\n'%newInfo['microstructures'])

#--- write header ---------------------------------------------------------------------------------
  theTable.labels_clear()
  theTable.info_clear()
  theTable.info_append(extra_header+[
    scriptID,
    "grid\ta %i\tb %i\tc %i"%(info['grid'][0],info['grid'][1],info['grid'][2],),
    "size\tx %f\ty %f\tz %f"%(info['size'][0],info['size'][1],info['size'][2],),
    "origin\tx %f\ty %f\tz %f"%(info['origin'][0],info['origin'][1],info['origin'][2],),
    "homogenization\t%i"%info['homogenization'],
    "microstructures\t%i"%(newInfo['microstructures']),
    ])
  theTable.head_write()
  theTable.output_flush()
  
# --- write microstructure information ------------------------------------------------------------
  formatwidth = int(math.floor(math.log10(microstructure.max())+1))
  theTable.data = microstructure.reshape((info['grid'][0],info['grid'][1]*info['grid'][2]),order='F').transpose()
  theTable.data_writeArray('%%%ii'%(formatwidth))
    
#--- output finalization --------------------------------------------------------------------------
  if file['name'] != 'STDIN':
    file['input'].close()
    file['output'].close()
    os.rename(file['name']+'_tmp',file['name'])
