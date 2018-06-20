#! /usr/bin/env python
"""
These are somewhat hacky tools to leverage Dr. Trevor Keenan's
FLUXNET_citations to generate .tex tables for a subset of sites.  

Their upside is minimum dependencies:

just Python >= 3.0

contact Adam Massmann: akm2203 "at" columbia.edu if you have any issues

this is distributed in the hope that it will be useful, 
but without any warranty
"""
import os

PWD = os.path.dirname(__file__)
BIB = os.path.join(PWD, "F15T1LaTexBib.bib")
TEX_IN = os.path.join(PWD, "F15T1LaTex.tex")

def load_tier1_dict():
  """generages a dict of latex table entries indexed by site key (lc)"""
  tex_handle = open(TEX_IN, 'r')

  tex_str = tex_handle.read()
  tex_str_list = tex_str[tex_str.find('AR-SLu &'):\
                        tex_str.find('\\\\[1ex] % [1ex]')].split("\\\\\n")
  tex_dict = dict([(_s.split(' & ')[0].lower(), _s)
                   for _s in tex_str_list])
  tex_handle.close()
  return tex_dict

def generate_table(site_list, table_path="./table.tex",\
                   bib_path="./table.bib"):
  """
  Will generate the body of a citation table following FLUXNET's
  citation guidelines, given a list of sites used (site_list).  For
  universality, only the body of the (7 column) table is output into
  table_path, so when you call table.tex as an input in your tex doc,
  you need to define how the table is set up by writing
  (e.g. \begin{table}, \end{table} sandwiched around \input{<table_path>})

  example:
  import fluxnet_pycite as pycite
  pycite.generate_table(['AU-Cpr', 'BE-Lon', 'US-MMS'])

  will generate:
  table.tex with contents:
  AU-Cpr & SAV & -34.0021 & 140.5891 & Unk & 2010-2014 & \cite{AU-Cpr} \\
  BE-Lon & CRO & 50.5516 & 4.7461 & Cfb & 2004-2014 & \cite{BE-Lon} \\
  US-MMS & DBF & 39.3232 & -86.4131 & Cfa & 1999-2014 & \cite{US-MMS} \\

  as well as table.bib (just a copy of F15T1LaTexBib.bib)
  """

  # take care of bib
  os.system('cp %s %s' % (BIB, bib_path))

  # load and format tex in
  tex_dict = load_tier1_dict()

  # write bib out
  tex_out = open(table_path, 'w')
  site_list.sort()
  [tex_out.write('%s\\\\\n' % tex_dict[_key.lower()])
   for _key in site_list]

  tex_out.close()
  return True
