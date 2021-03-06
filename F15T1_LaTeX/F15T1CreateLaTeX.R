##--------------------------------------------------------------------------------------------------------------
## This script creates LaTeX source file "F15T1LaTex_fromR.tex" with a big table containing meta info for 
## FLUXNET 2015, including bibtex citation keys that go with F15T1LaTexBib.bib.
## Compiles and opens "F15T1LaTex_fromR.pdf" as well.
##
## Written by B. Stocker (b.stocker@creaf.uab.cat)
##--------------------------------------------------------------------------------------------------------------

## Known issues
##  sites without references print pdf with '?' 

library(dplyr)
library(readr)

## Read table with site meta info
cit <- read_csv('siteinfo_fluxnet2015.csv')
cit <- cit %>% dplyr::rename( site = mysitename ) %>% select( -elv_watch, -elv_diff, -years_data )

##--------------------------------------------------------------------------------------------------------------
## Create big table with in-line citation keys for LaTeX
##--------------------------------------------------------------------------------------------------------------
## Couln't find a solution with dplyr. Tried but doesn't work: cit <- cit %>% mutate( citation = cat( paste0("\\cite{", site, "}")) )
zz <- file("F15T1LaTex_fromR.tex","w")
# cat( glue::collapse(names(cit), sep = " & "), "\\\\", "\n", file=zz, sep=" " ) # alternative simple short header line
cat( "\\documentclass[a4paper, 12pt]{article}", "\n", file = zz, sep = " " )
cat( "\\usepackage[left=20mm,right=20mm,top=20 mm,bottom=20mm]{geometry}", "\n", file = zz, sep = " " )
cat( "\\usepackage{longtable}", "\n", file = zz, sep = " " )
cat( "\\usepackage{lipsum}", "\n", file = zz, sep = " " )
cat( "\\usepackage{hyperref}", "\n", file = zz, sep = " " )
cat( "\\usepackage{textcomp}", "\n", file = zz, sep = " " )
cat( "\\begin{document}", "\n", file = zz, sep = " " )
cat( "\\setlength{\\parindent}{0em}", "\n", file = zz, sep = " " )
cat( "\\textbf{Table} Main site characteristics, and studied periods of flux sites used in this analysis. All the data gathered from \\href{www.fluxdata.org}{www.fluxdata.org}.", "\n", file = zz, sep = " " )
cat( "\\begin{longtable}{l l l l l l l l}", "\n", file=zz, sep=" ")
cat( "\\hline", "\n", file=zz, sep=" ")
cat( "\\multicolumn{1}{l}{\\textbf{Site name}} & ", "\n", file=zz, sep=" ")
cat( "\\multicolumn{1}{l}{\\textbf{Lon\\textsuperscript{1}}} & ", "\n", file=zz, sep=" ")
cat( "\\multicolumn{1}{l}{\\textbf{Lat\\textsuperscript{2}}} & ", "\n", file=zz, sep=" ")
cat( "\\multicolumn{1}{l}{\\textbf{Alt}} & ", "\n", file=zz, sep=" ")
cat( "\\multicolumn{1}{l}{\\textbf{Year start}} & ", "\n", file=zz, sep=" ")
cat( "\\multicolumn{1}{l}{\\textbf{Year end}} & ", "\n", file=zz, sep=" ")
cat( "\\multicolumn{1}{l}{\\textbf{Veg\\textsuperscript{3}}} & ", "\n", file=zz, sep=" ")
cat( "\\multicolumn{1}{l}{\\textbf{Ref\\textsuperscript{4}}} \\\\[0.5ex]", "\n", file=zz, sep=" ")
cat( "\\hline", "\n", file=zz, sep=" ")
cat( "\\endhead ", "\n", file=zz, sep=" ")

## loop over rows in data frame 'cit' to create latex table row-by-row
for (idx in seq(nrow(cit))){
  cat( cit$site[idx], "&", cit$lon[idx], "&", cit$lat[idx], "&", cit$elv[idx], "&", cit$year_start[idx], "&", cit$year_end[idx], "&", cit$classid[idx], "&", paste0("\\cite{", cit$site[idx], "}"), "\\\\", "\n", file=zz, sep=" " )
}

cat( "\\hline ", "\n", file = zz, sep = " ")
cat( "\\label{tab:longtable} ", "\n", file = zz, sep = " ")
cat( "\\end{longtable}", "\n", file = zz, sep = " ")
cat( "\\textsuperscript{1} Negative value indicates west longitude. \\textsuperscript{2} Positive value indicates north latitude. \\textsuperscript{3} Vegetation types: deciduous broadleaf forest (DBF); evergreen broadleaf forest (EBF); evergreen needleleaf forest (ENF); grassland (GRA); mixed deciduous and evergreen needleleaf forest (MF); savanna ecosystem (SAV); shrub ecosystem (SHR); wetland (WET); unknown (UNK). \\textsuperscript{4} References.", "\n", file = zz, sep = " ")
cat( "\\medskip", "\n", file = zz, sep = " ")
cat( "\\bibliographystyle{apalike}", "\n", file = zz, sep = " ")
cat( "\\bibliography{F15T1LaTexBib}", "\n", file = zz, sep = " ")
cat( "\\end{document}", "\n", file = zz, sep = " ")

close(zz)

## compile to PDF document and open it
system("pdflatex F15T1LaTex_fromR.tex")
system("bibtex F15T1LaTex_fromR")
system("pdflatex F15T1LaTex_fromR.tex")
system("open F15T1LaTex_fromR.pdf")
