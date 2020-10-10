bonnes-pratiques.pdf: bonnes-pratiques.odp
	libreoffice7.0 \
		--headless \
		"-env:UserInstallation=file:///tmp/bonnes_pratiques_${USER}" \
		--convert-to pdf:impress_pdf_Export \
		--outdir . \
		./bonnes-pratiques.odp
	
	mv bonnes-pratiques.pdf bonnes-pratiques-unoptimized.pdf

	ghostscript \
		-sDEVICE=pdfwrite \
		-dCompatibilityLevel=1.5 \
		-dPDFSETTINGS=/screen \
		-dNOPAUSE \
		-dQUIET \
		-dBATCH \
		-sOutputFile=bonnes-pratiques.pdf \
		bonnes-pratiques-unoptimized.pdf
	
	rm bonnes-pratiques-unoptimized.pdf
