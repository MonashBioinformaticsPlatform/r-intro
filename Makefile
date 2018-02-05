
# May need to:
# sudo python -m pip install pandocfilters

#
# The introductory page differs between html and pdf versions.
#
# HTML home page is from index.Rmd
# PDF introduction is from intro.Rmd
#

SECTIONS=start matrices data_frames for_loops ggplot next

# SVG->PNG conversion
SVGS=$(wildcard fig/*.svg)
PNGS=$(patsubst %.svg,%.png,$(SVGS))

all : index.html r-intro-files.zip $(addsuffix .html,$(SECTIONS)) r-intro.pdf $(PNGS)

clean :
	rm -f index.html index.md intro.md r-intro-files.zip $(addsuffix .md,$(SECTIONS)) $(addsuffix .html,$(SECTIONS)) r-intro.pdf
	rm -f fig/*-chunk-*.png

r-intro.tex : intro.md $(addsuffix .md,$(SECTIONS))
	pandoc -s -t latex -fmarkdown-implicit_figures --toc --toc-depth 2 --no-highlight \
		-Vlinks-as-notes=1 \
		-Vdocumentclass=report \
		-Vpapersize:a4paper \
		-Vgeometry:margin=1in \
		intro.md $(addsuffix .md,$(SECTIONS)) \
		-o $@

r-intro.pdf : intro.md $(addsuffix .md,$(SECTIONS))
	pandoc -s -t latex -fmarkdown-implicit_figures --toc --toc-depth 2 --no-highlight \
		-Vlinks-as-notes=1 \
		-Vdocumentclass=report \
		-Vpapersize:a4paper \
		-Vgeometry:margin=1in \
		intro.md $(addsuffix .md,$(SECTIONS)) \
		-o $@

r-intro-files.zip : r-intro-files/*
	zip -FSr r-intro-files.zip r-intro-files

%.md : %.Rmd
	Rscript -e 'knitr::knit("$<")'

%.html : %.md _includes/*.html
	pandoc -s -t html -fmarkdown-implicit_figures \
	    --smart \
        --template=_layouts/page \
		--filter=tools/filters/blockquote2div.py \
		--filter=tools/filters/id4glossary.py \
		-Vheader="$$(cat _includes/header.html)" \
        -Vbanner="$$(cat _includes/banner.html)" \
        -Vfooter="$$(cat _includes/footer.html)" \
        -Vjavascript="$$(cat _includes/javascript.html)" \
		-o $@ $<


%.png : %.svg
	rsvg-convert $< >$@
