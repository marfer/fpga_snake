BITSTREAM = prj/target.bit
SRC = src/top.v
TD = /opt/TD/TD_RELEASE_MAY2019_r4.5.12562/bin/td

$(BITSTREAM):$(SRC) resources/batman_indexed.mif
	cd prj;$(TD) build.tcl

resources/init.mif: resources/batman_indexed.data
	srec_cat resources/batman_indexed.data -binary -o resources/batman_indexed.mif -mif

flash: $(BITSTREAM)
	cd prj;sudo $(TD) download.tcl

clean:
	cd prj;rm -f *.db *.area *.log *.bit
