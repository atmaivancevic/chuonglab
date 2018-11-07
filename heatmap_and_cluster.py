#!/usr/bin/python

# Basic usage: ~/repos/chuonglab/heatmap_and_cluster.py -s states.txt -c cells.txt -i input.txt --stat=combo -o out.pdf

# Adapted from Ryan Layer's giggle heatmap example
# (https://github.com/ryanlayer/giggle/blob/master/scripts/giggle_heat_map.py)

# Example files:
# > head states.txt 
# 1 A_1
# 2 A_2
# 3 A_3
# 4 A_4
# 5 B_1
# 6 B_2
# 7 B_3
# 8 B_4
# 9 C
# 10  D

# > head cells.txt 
# 1 ERV3-16A3_LTR
# 2 HERV-Fc1_LTR1
# 3 HERV-Fc1_LTR2
# 4 HERV-Fc1_LTR3
# 5 HERV-Fc2_LTR
# 6 HERV1_LTRa
# 7 HERV1_LTRb
# 8 HERV1_LTRc
# 9 HERV1_LTRd
# 10  HERV1_LTRe

# > head input.txt
# ERV3-16A3_LTR A_1 1133  46  0.94324357167916306 0.66294303227407074 0.33193483016300039 0.72013467231989392 -0.015049150563962547
# ERV3-16A3_LTR A_2 1133  35  0.98509073288050308 0.93277144248610743 0.44580366628093415 0.62048287803813543 -0.00065501534797796819
# ERV3-16A3_LTR A_3 1133  61  1.0827797372574306  0.58818119906434112 0.71546363190967917 0.3312181310616757  0.02644624469880924
# ERV3-16A3_LTR A_4 1133  37  1.0417223268020714  0.86648975497054803 0.57926371849673933 0.48701557495351778 0.0036701386746911928
# ERV3-16A3_LTR B_1 1133  40  0.7624571279104988  0.067197610441467871  0.03440325712313942 0.97577133239018003 -0.45882346707430148
# ERV3-16A3_LTR B_2 1133  85  1.6169115162991494  9.4274899228396479e-05  0.99996545803958286 5.6922163097397998e-05  2.7907126067012965
# ERV3-16A3_LTR B_3 1133  71  1.0168880183066682  0.95101822992495112 0.54352721880883869 0.50532024763151978 0.00052697536672829935
# ERV3-16A3_LTR B_4 1133  48  0.92996602994931665 0.57178285014702761 0.29455985969060748 0.75349175083346177 -0.025430058300329888
# ERV3-16A3_LTR C 1133  40  0.90172759230052257 0.4938248794807851  0.24094903575789444 0.80538839898240836 -0.045730075637752012
# ERV3-16A3_LTR D 1133  42  0.93037567657443587 0.59831755038283759 0.30477050064829735 0.74717505794667479 -0.02322468807292857

#########################################################################################

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import sys
import math
from optparse import OptionParser
from scipy.spatial.distance import pdist,squareform

import warnings
warnings.simplefilter(action='ignore', category=FutureWarning)

parser = OptionParser()

parser.add_option("-b",
                  action="store_true",
                  default=False,
                  dest="black",
                  help="black background")

parser.add_option("--x_size",
                  dest="x_size",
                  type="int",
                  default=10,
                  help="Figure x size (Default 10)")

parser.add_option("--y_size",
                  dest="y_size",
                  type="int",
                  default=30,
                  help="Figure x size (Default 30)")

parser.add_option("--no_labels",
                  dest="no_labels",
                  action="store_true",
                  default=False,
                  help="Do not label x and y axis");

parser.add_option("--no_ylabels",
                  dest="no_ylabels",
                  action="store_true",
                  default=False,
                  help="Do not label y axis");


parser.add_option("--stat",
                  dest="stat",
                  default="combo",
                  help="Stat to plot (odds, sig, combo) (Default: combo)")

parser.add_option("-i",
                  "--input",
                  dest="input_file",
                  help="GIGGLE result file name with '-s'")

parser.add_option("--ablines",
                  dest="ablines")

parser.add_option("-o",
                  "--output",
                  dest="output_file",
                  help="Output file name")

parser.add_option("-s",
                  "--states",
                  dest="states_file",
                  help="States file name")

parser.add_option("-n",
                  "--cell_names",
                  dest="cells_names_file",
                  help="Cells names file name")

parser.add_option("--sort",
                  dest="cells_sort_file",
                  help="Cells sort order file name")

parser.add_option("--state_names",
                  dest="state_names",
                  help="States names")

parser.add_option("--group_names",
                  dest="group_names",
                  help="Group names")

parser.add_option("-c",
                  "--cells",
                  dest="cells_file",
                  help="Cells file name")

(options, args) = parser.parse_args()

if not options.output_file:
    parser.error('Output file not given')
if not options.input_file:
    parser.error('Input file not given')
if not options.states_file:
    parser.error('States file not given')
if not options.cells_file:
    parser.error('Cells file not given')

if options.stat not in ['odds', 'sig', 'combo']:
    parser.error('Stat "' + options.stat + '" not supported')

#########################################################################################

# Parse the required data out of the giggle results file

states = []
for l in open(options.states_file, 'r'):
    states.append(l.rstrip().split('\t')[1])

cells = []
for l in open(options.cells_file, 'r'):
    cells.append(l.rstrip().split('\t')[1])

names = []
if options.cells_names_file:
    for l in open(options.cells_names_file, 'r'):
        names.append(l.rstrip().split('\t')[1])

sorts = []
if options.cells_sort_file:
    for l in open(options.cells_sort_file, 'r'):
        sorts.append(l.rstrip().split('\t')[1])

M = {}

for c in cells:
    M[c] = {}
    for s in states:
        M[c][s] = 0

# open the input file
for l in open(options.input_file,'r'):
    if l[0] == '#': # ignore comment/header lines in input file
        continue
    A = l.rstrip().split('\t')
    odds = float(A[4])
    sig = float(A[5])
    combo = float(A[8])

    c = ''
    found = False
    for i in cells:
        if i == A[0]: # changed this to be an exact name match
            assert not found, (A[0], i)
            c = i
            found = True

    s = ''
    found = False
    for i in states:
        if i == A[1]: # also here, require exact match
            assert not found, (A[1], i)
            s = i
            found = True

    assert M[c][s] == 0, (A[0], A[1], c, s, M[c][s])

    if options.stat == 'sig':
        M[c][s] = sig
    elif options.stat == 'combo':
        M[c][s] = combo
    elif options.stat == 'odds':
        M[c][s] = odds

D=np.zeros([len(cells),len(states)])

c = 0
for cell in cells:
    s = 0
    for state in states:
        D[c,s] = M[cell][state]
        s+=1
    c+=1

column_labels = cells
row_labels = states
data = D

# print column_labels
# print row_labels
# print data.min(), data.max()

#########################################################################################

# Make a heatmap with hierarchial clustering and save output figure

import seaborn as sns; sns.set(color_codes=True)

# load the dataset to seaborn
data2 = pd.DataFrame(data, columns=states, index=cells)
print data2

# choose colour scheme
from matplotlib import colors as mcolors
from matplotlib.colors import Normalize

_seismic_data = ( (0.0, 0.0, 0.3), 
                  (0.0, 0.0, 1.0),

                  (1.0, 1.0, 1.0),

                  (1.0, 0.0, 0.0),
                  (0.5, 0.0, 0.0))

hm = mcolors.LinearSegmentedColormap.from_list( \
        name='red_white_blue', \
        colors=_seismic_data, N=256)

class MidpointNormalize(Normalize):
    def __init__(self, vmin=None, vmax=None, midpoint=None, clip=False):
        self.midpoint = midpoint
        Normalize.__init__(self, vmin, vmax, clip)

    def __call__(self, value, clip=None):
        x, y = [self.vmin, self.midpoint, self.vmax], [0, 0.5, 1]
        return np.ma.masked_array(np.interp(value, x, y))

fig = plt.figure()
clustermap = sns.clustermap(data2, cmap=hm, norm = MidpointNormalize(midpoint=0), robust=False, metric='euclidean', method='complete', figsize=(40, 150), col_cluster=False)
plt.savefig(options.output_file,bbox_inches='tight')


# lots of different clustering methods
# tested: method='single', method='complete', method='average', method='weighted', method='centroid', method='median', method='ward'
# ward seems to best distinguish the ones that differ between control and cancer









