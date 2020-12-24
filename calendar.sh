bundle
ruby lib/create-calendar.rb
cd latex
pdflatex kalender.tex
cd ..
mv /output/kalender.pdf ./kalender.pdf
echo "\n\n\nDone - opening new calendar"
open ./kalender.pdf
