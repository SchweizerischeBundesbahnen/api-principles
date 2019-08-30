#!/bin/bash

#for f in *.adoc
#do
#  ADOC_FILENAME="$f"
#  FILENAME="${ADOC_FILENAME%%.*}"
#  MD_FILENAME="$FILENAME.md"
#  XML_FILENAME="$FILENAME.xml"
#
#  asciidoctor -b docbook "$ADOC_FILENAME"
#  pandoc -f docbook -t markdown_strict "$XML_FILENAME" -o "$MD_FILENAME"
#  #iconv -t utf-8 "$XML_FILENAME" | pandoc -f docbook -t markdown_strict | iconv -f utf-8 > "$MD_FILENAME"
#  iconv -t utf-8 "$XML_FILENAME" | pandoc -f docbook -t markdown_strict --wrap=none | iconv -f utf-8 > "$MD_FILENAME"
#  rm ./"$XML_FILENAME"
#  rm ./"$ADOC_FILENAME"
#done