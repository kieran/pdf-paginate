fs = require 'fs'
path = require 'path'
{ orderBy } = require 'natural-orderby'
{ PDFDocument, StandardFonts, rgb, degrees } = require 'pdf-lib'

source = '.' #'/Volumes/KINGSTON'

do ->
  page_number = 0

  files = fs.readdirSync source

  for file in orderBy files when /pdf$/.test file

    console.log "#{page_number+1} - #{file}"

    # open PDF
    pdfDoc = await PDFDocument.load fs.readFileSync path.resolve source, file

    # embed font
    font = await pdfDoc.embedFont StandardFonts.Helvetica
    size = 14
    color = rgb(0, 0, 0)

    for page in pdfDoc.getPages()

      { width, height } = page.getSize()

      if width < height
        x = width / 2 - 10
        y = height - 20
        rotate = degrees 0
      else
        y = height / 2 + 10
        x = width - 20
        rotate = degrees -90

      page.drawText "#{page_number += 1}", { x, y, size, font, color, rotate }

    fs.writeFileSync "numbered/#{file}", await pdfDoc.save()



