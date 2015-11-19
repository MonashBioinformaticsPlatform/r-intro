
# May need to:
# sudo python -m pip install pandocfilters

#
# The introductory page differs between html and pdf versions.
#
# HTML home page is from index.Rmd
# PDF introduction is from intro.Rmd
#

SECTIONS=start matrices data_frames ggplot next

# SVG->PNG conversion
SVGS=$(wildcard fig/*.svg)
PNGS=$(patsubst %.svg,%.png,$(SVGS))

all : index.html $(addsuffix .html,$(SECTIONS)) intro-r.pdf $(PNGS)

intro-r.pdf : intro.md $(addsuffix .md,$(SECTIONS))
	pandoc -s -t latex -fmarkdown-implicit_figures --toc --toc-depth 1 \
		-Vlinks-as-notes=1 \
		-Vdocumentclass=report \
		-Vpapersize:a4paper \
		-Vgeometry:margin=1in \
		intro.md $(addsuffix .md,$(SECTIONS)) \
		-o $@

%.md : %.Rmd
	Rscript -e 'knitr::knit("$<")'

%.html : %.md
	pandoc -s -t html \
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
