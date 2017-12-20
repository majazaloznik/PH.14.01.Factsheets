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
DT/I = $(DATA)/interim 

DOCS = $(DIR)/docs
D/J = $(DOCS)/journals

FIG = $(DIR)/figures

# .interim .rds files
DT/I/.rds = $(wildcard $(DT/I)/*.rds)

# processed .rds files
DT/P/.rds = $(wildcard $(DT/P)/*.rds)

# commands ####################################################################
# recipe to knit pdf from first prerequisite
KNIT-PDF = Rscript -e "require(rmarkdown); render('$<', output_dir = '$(@D)', output_format = 'pdf_document' )"

# recipe to knit pdf from first prerequisite
KNIT-HTML = Rscript -e "require(rmarkdown); render('$<', output_dir = '$(@D)', output_format = 'html_document' )"


# DEPENDENCIES   ##############################################################
###############################################################################
all:   $(D/J)/journal.pdf README.html $(DT/P/.rds) 
		-rm $(wildcard ./docs/*/tex2pdf*) -fr

dot: $(FIG)/make.png 

# top level dependencies ######################################################
# make file .dot
$(DT/P)/make.dot : $(DIR)/Makefile
	python $(DIR)/code/functions/makefile2dot.py < $< > $@

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
	
$(DT/I/.rds): $(C/DC)/01-import.R $(DT/R)/catalog.full.rds
	Rscript -e "source('$<')"

$(DT/I)/catalog.rds: $(C/DC)/01-import.R

$(DT/P)/catalog.csv $(DT/P/.rds): $(C/DC)/02-clean.R $(DT/I)/catalog.rds $(DT/I/.rds)
	Rscript -e "source('$<')"
	
$(C/DC)/02-clean.R: $(C/F)/FunDataExtractor.R
