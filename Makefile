
all : \
	index.html

%.html : %.Rmd
	Rscript -e 'knitr::knit2html("$<")'
	rm $$(basename $< .Rmd).md
