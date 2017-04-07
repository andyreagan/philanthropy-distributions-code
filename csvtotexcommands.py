#!/usr/bin/python
#
# csvtotexcommand.py
#
# convert a csv to a tex file of commands for each entry
#
# USAGE
#
# csvtotexcommand.py exponents.tex
#  -write to the exponents tex file

import sys
outfile = sys.argv[1]
g = open(outfile,'w')

## f = open('figures/local/inst_names.csv','r')
## labels = [x.split(' ')[0] for x in f.readline().rstrip().split(',')]
labels = ["sinai","Einstein","UVM","unitedway","echo","flynntheater"]
## f.close()
## f = open('figures/local/inst_years.csv','r')
## years = [line.rstrip().split(',') for line in f]
## f.close()
years = []
n_inst = len(labels)
all_data = range(n_inst)
fileroot = "/Users/andyreagan/work/2012/2012-01philanthropy-distributions/data/sharing/NonprofitData-"    
filenames = [fileroot + name + ".csv" for name in labels]
for i in range(n_inst):
  f = open(filenames[i],'r')
  years.append(f.readline().rstrip().split(','))
  f.close()
print years

for method in ['MLE','LS']:
  if method == 'MLE':
    f = open('figures/local/inst_p_{0}.csv'.format(method),'r')
    p_mat = [line.rstrip().split(',') for line in f]
    f.close()
    f = open('figures/local/inst_gof_{0}.csv'.format(method),'r')
    gof_mat = [line.rstrip().split(',') for line in f]
    f.close()
  f = open('figures/local/inst_fit_l_{0}.csv'.format(method),'r')
  fit_l_mat = [line.rstrip().split(',') for line in f]
  f.close()
  f = open('figures/local/inst_fit_u_{0}.csv'.format(method),'r')
  fit_u_mat = [line.rstrip().split(',') for line in f]
  f.close()
  f = open('figures/local/inst_alpha_{0}.csv'.format(method),'r')
  alpha_mat = [line.rstrip().split(',') for line in f]
  f.close()
  f = open('figures/local/inst_alpha_conf_{0}.csv'.format(method),'r')
  alpha_conf_mat = [line.rstrip().split(',') for line in f]
  f.close()
  f = open('figures/local/inst_gamma_{0}.csv'.format(method),'r')
  gamma_mat = [line.rstrip().split(',') for line in f]
  f.close()
  f = open('figures/local/inst_gamma_conf_{0}.csv'.format(method),'r')
  gamma_conf_mat = [line.rstrip().split(',') for line in f]
  f.close()
  
  ugh = ['zero','one','two','three','four','five','six','seven','eight','nine']
  for i in range(len(fit_u_mat)): # over the years range(7)
    for j in range(len(fit_u_mat[i])): # over the institutions range(6)
##      print i
##      print j
      if len(years[j]) > i:
        # convert the year to a string with last two digits
        yearstring = ugh[int(years[j][i][2])]+ugh[int(years[j][i][3])]
        if method == 'MLE':
          g.write('\\newcommand{{\\{0}{1}{2}p}}{{{3:.2f}}}\n'.format(method,labels[j],yearstring,float(p_mat[i][j])))
          g.write('\\newcommand{{\\{0}{1}{2}gof}}{{{3:.2f}}}\n'.format(method,labels[j],yearstring,float(gof_mat[i][j])))
        g.write('\\newcommand{{\\{0}{1}{2}minfit}}{{{3}}}\n'.format(method,labels[j],yearstring,fit_l_mat[i][j]))
        g.write('\\newcommand{{\\{0}{1}{2}maxfit}}{{{3}}}\n'.format(method,labels[j],yearstring,fit_u_mat[i][j]))
        g.write('\\newcommand{{\\{0}{1}{2}alpha}}{{{3:.2f}}}\n'.format(method,labels[j],yearstring,float(alpha_mat[i][j])))
        g.write('\\newcommand{{\\{0}{1}{2}alphaconf}}{{{3:.2f}}}\n'.format(method,labels[j],yearstring,float(alpha_conf_mat[i][j])))
        g.write('\\newcommand{{\\{0}{1}{2}gamma}}{{{3:.2f}}}\n'.format(method,labels[j],yearstring,float(gamma_mat[i][j])))
        g.write('\\newcommand{{\\{0}{1}{2}gammaconf}}{{{3:.2f}}}\n'.format(method,labels[j],yearstring,float(gamma_conf_mat[i][j])))
g.close()
