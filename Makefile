# Local resume build. CI does the same thing on push; this is for previewing
# without waiting on GitHub Actions.
#
#   make          build resume.pdf from resume/AengusResume.tex
#   make check    build, then run the consistency checks
#   make clean    remove LaTeX intermediates

TEX := resume/AengusResume.tex
PDF := resume.pdf

.PHONY: all check clean

all: $(PDF)

$(PDF): $(TEX)
	@cd resume && pdflatex -interaction=nonstopmode -halt-on-error AengusResume.tex >/dev/null \
	  || { echo "LaTeX failed - see resume/AengusResume.log"; exit 1; }
	@mv resume/AengusResume.pdf $(PDF)
	@rm -f resume/AengusResume.aux resume/AengusResume.out resume/AengusResume.log
	@echo "built $(PDF)"

check: $(PDF)
	@./resume/check-resume.sh

clean:
	@rm -f resume/AengusResume.aux resume/AengusResume.out resume/AengusResume.log
