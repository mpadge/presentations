LFILE = jsm
SETUPFILE = setup-script

all: knith rename

knith: $(LFILE).Rmd
	echo "rmarkdown::render('$(LFILE).Rmd',output_file='$(LFILE).html')" | R --no-save -q

rename: $(LFILE).html
	mv $(LFILE).html index.html

open: $(LFILE).html
	xdg-open $(LFILE).html &

clean:
	rm -rf *.html xaringan-themer.css *_cache *_files libs
