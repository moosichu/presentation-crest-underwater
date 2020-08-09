:: Delete plots folder as all plots are automatically regenerated
:: del /S plots

:: Build presentation.md into a reveal.js presentation at index.html
pandoc -t revealjs -s presentation.md -o index.html --mathml --filter "pandoc-plot" --filter pandoc-citeproc --slide-level=3
