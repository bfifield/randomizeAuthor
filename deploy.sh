#!/bin/bash

echo "# ---------------------------- #"
echo "  Redeploying randomizeAuthor"
echo "  $(date)"
echo "# ---------------------------- #"
echo -e "\n"

# Test or deploy
echo "Test or deploy randomizeAuthor?"
select td in "Test" "Deploy"; do
    case $td in
	"Test" ) R -e 'shiny::runApp("shiny", launch.browser = TRUE)'; break;;
	"Deploy" ) R -e 'rsconnect::deployApp("shiny", launch.browser = TRUE)'; break;;
    esac
done

# Commit to github
echo "Commit changes to github?"
select yn in "Yes" "No"; do
    case $yn in
	"Yes" ) git add -A
		echo "Give commit message here:"
		read commit
		git commit -m "$commit"
		git push origin master; break;;
	"No" ) break;;
    esac
done

