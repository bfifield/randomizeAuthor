#!/bin/bash

echo "# ---------------------------- #"
echo "  Redeploying randomizeAuthor"
echo "  $(date)"
echo "# ---------------------------- #"
echo -e "\n"

# Authorize email address
echo "Reauthorize email?"
select yn in "Yes" "No"; do
    case $yn in
	"Yes" ) Rscript authorize_email.R; break;;
	"No" ) break;;
    esac
done

# Test or deploy
echo "Test or deploy randomizeAuthor?"
select td in "Test" "Deploy"; do
    case $td in
	"Test" ) R -e 'shiny::runApp("shiny", launch.browser = TRUE)'; break;;
	"Deploy" ) R -e 'rsconnect::deployApp("shiny", launch.browser = TRUE)'; break;;
    esac
done

