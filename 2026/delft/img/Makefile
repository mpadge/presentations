FILE = junction

# neato -n keeps the node positions pinned in the .dot file
all: $(FILE).svg $(FILE).png

%.svg: %.dot
	neato -n -Tsvg $< -o $@

%.png: %.dot
	neato -n -Tpng $< -o $@

# Re-render on every save (requires entr)
watch:
	ls $(FILE).dot | entr -p $(MAKE) $(FILE).svg

clean:
	rm -f $(FILE).svg $(FILE).png

.PHONY: all watch clean
