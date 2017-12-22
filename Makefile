# VARIABLE DEFINITIONS  #######################################################
###############################################################################
# folders #####################################################################
DIR = .#
CODE = $(DIR)/code#
C/DC = $(CODE)/data-cleaning#
C/DP = $(CODE)/data-plotting#
C/F = $(CODE)/functions#

DATA = $(DIR)/data

DT/P = $(DATA)/processed
DT/R = $(DATA)/raw
DT/I = $(DATA)/interim

DOCS = $(DIR)/docs
D/J = $(DOCS)/journals

FIG = $(DIR)/figures


# plot .eps files
FIG/.eps = $(wildcard $(FIG)/*.eps)

# commands ####################################################################
# recipe to knit pdf from first prerequisite
KNIT-PDF = Rscript -e "require(rmarkdown); render('$<', output_dir = '$(@D)', output_format = 'pdf_document' )"

# recipe to knit pdf from first prerequisite
KNIT-HTML = Rscript -e "require(rmarkdown); render('$<', output_dir = '$(@D)', output_format = 'html_document' )"


# DEPENDENCIES   ##############################################################
###############################################################################
all:  $(DT/I)/%.rds $(D/J)/journal.pdf README.html
	-rm $(wildcard ./docs/*/tex2pdf*) -fr

dot: $(FIG)/make.png 

# top level dependencies ######################################################
# make file .dot
$(DT/P)/make.dot : $(DIR)/Makefile
	python $(DIR)/code/functions/makefile2dot.py < $< > $@
	sed -i 's/rankdir="BT"/rankdir="LR"/' $(DT/P)/make.dot

# make chart from .dot
$(FIG)/make.png : $(DT/P)/make.dot
	Rscript -e "suppressMessages(require(DiagrammeR)); \
	suppressMessages(require(DiagrammeRsvg)); \
	suppressMessages(require(rsvg)); \
	png::writePNG(rsvg(charToRaw(export_svg(grViz('$<')))), '$@')"

# journal (with graph) render to  pdf
$(D/J)/journal.pdf:  $(D/J)/journal.Rmd $(FIG)/make.png
	$(KNIT-PDF)

README.html: README.md $(FIG)/make.png
	$(KNIT-HTML)

# catalog is extracted first
$(DT/R)/catalog.full.rds:  $(C/DC)/00-data-catalog.R
	Rscript -e "source('$<')"

# import has to have fresh catalog
$(C/DC)/01-import.R: $(DT/R)/catalog.full.rds

# actual catalog subset is saved during import
$(DT/I)/catalog.rds: $(C/DC)/01-import.R

# imports all the interim .rds files 
$(DT/I)/%.rds: $(C/DC)/01-import.R
	Rscript -e "source('$<')"


# extraction funciton called from cleaning script
$(C/DC)/02-clean.R: $(C/F)/FunDataExtractor.R

$(DT/P)/catalog.csv: $(C/DC)/02-clean.R $(DT/I)/%.rds

# cleans all the /interim .rds files into /processed
$(DT/P)/%.rds: $(C/DC)/02-clean.R $(DT/I)/%.rds
	R	script -e "source('$<')"

# plotting funciton called from cleaning script
$(C/DP)/03-data-plotting.R: $(C/F)/FunPlotSimple.R

# plots 
$(FIG)/%.eps: $(C/DP)/03-data-plotting.R $(DT/P)/%.rds
	Rscript -e "source('$<')"
