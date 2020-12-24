bundle
ruby lib/create-calendar.rb
cd latex
echo "Creating PDF via Latex"
pdflatex kalender.tex > pdflatex.log
cd ..
mv ./latex/kalender.pdf ./kalender.pdf
echo "\n\n\nDone - opening new calendar"
open ./kalender.pdf
