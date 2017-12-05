# VARIABLE DEFINITIONS  #######################################################
###############################################################################
# folders #####################################################################
DIR = .
CODE = $(DIR)/code
C/DC = $(CODE)/data-cleaning
C/P = $(CODE)/plotting
C/F = $(CODE)/functions

DATA = $(DIR)/data
DT/P = $(DATA)/processed

DT/R = $(DATA)/raw

DOCS = $(DIR)/docs
D/J = $(DOCS)/journals

FIG = $(DIR)/figures


# commands ####################################################################
# recipe to knit pdf from first prerequisite
KNIT-PDF = Rscript -e "require(rmarkdown); render('$<', output_dir = '$(@D)', output_format = 'pdf_document' )"

# recipe to knit pdf from first prerequisite
KNIT-HTML = Rscript -e "require(rmarkdown); render('$<', output_dir = '$(@D)', output_format = 'html_document' )"


# DEPENDENCIES   ##############################################################
###############################################################################
all:   $(D/J)/journal.pdf README.html
		-rm $(wildcard ./docs/*/tex2pdf*) -fr

  
# top level dependencies ######################################################
# make file .dot
$(DT/P)/make.dot : $(DIR)/Makefile
	python $(DIR)/code/functions/makefile2dot.py < $< > $@

# make chart from .dot
$(FIG)/make.png : $(DT/P)/make.dot
	Rscript -e "require(DiagrammeR); require(DiagrammeRsvg); require(rsvg); png::writePNG(rsvg(charToRaw(export_svg(grViz('$<')))), '$@')"

# journal (with graph) render to  pdf
$(D/J)/journal.pdf:  $(D/J)/journal.Rmd $(FIG)/make.png
	$(KNIT-PDF)

README.html: README.md $(FIG)/make.png
	$(KNIT-HTML)
