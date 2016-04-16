SUBDIR = chapters
SLIDIR = slides
SOURCE = main.tex $(SUBDIR)/*.tex
# SOURCE = main.tex chapters/chap-*.tex chapters/announce.tex chapters/append.tex chapters/abstract*.tex chapters/cover.tex chapters/errata.tex chapters/preface.tex chapters/resume.tex chapters/thanks.tex chapters/title*.tex
CLEANOBJ = $(patsubst %.tex, %.aux, $(SOURCE)) $(patsubst %.tex, %.bbl, $(SOURCE)) \
$(patsubst %.tex, %.blg, $(SOURCE)) $(SOURCE:.tex=.lof) \
$(patsubst %.tex, %.log, $(SOURCE)) $(patsubst %.tex, %.lot, $(SOURCE)) \
$(patsubst %.tex, %.nlo, $(SOURCE)) $(patsubst %.tex, %.out, $(SOURCE)) \
$(patsubst %.tex, %.toc, $(SOURCE))
DVIOBJ = $(patsubst %.tex, %.dvi, $(SOURCE)) 
PDFOBJ = $(patsubst %.tex, %.pdf, $(SOURCE))


main.pdf : main.dvi
	dvipdf main.dvi

# 虽然链接是对的, 但是发现需要 latex 编译三次才能使目录中的页码是正确的
main.dvi : main.bbl $(SOURCE)
	latex main.tex
	latex main.tex
	latex main.tex

main.bbl : main.aux
	-bibtex main.aux

main.aux : $(SOURCE)
	latex main.tex

slides:
	cd $(SLIDIR); make   

clean:
	-rm -fr *~ _* .f* prv_* auto $(SUBDIR)/.f* $(SUBDIR)/_* $(SUBDIR)/*~ $(SUBDIR)/auto $(SUBDIR)/prv_* codes/*~
	cd $(SLIDIR); make clean

clean-all: clean
	-rm -f *.aux $(CLEANOBJ) *.log $(SUBDIR)/*.log
	cd $(SLIDIR); make clean-all

clean-dvi: 
	-rm -f $(DVIOBJ)

clean-pdf:
	-rm -f $(PDFOBJ)
	cd $(SLIDIR); make clean-pdf

clean-doc: clean-dvi clean-pdf

.PHONY: slides clean clean-all clean-dvi clean-pdf clean-doc
