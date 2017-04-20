#!/bin/bash

echo "Test or deploy randomizeAuthor?"
select td in "Test" "Deploy"; do
    case $td in
	"Test" ) R -e 'shiny::runApp("shiny", launch.browser = TRUE)'; break;;
	"Deploy" ) R -e 'rsconnect::deployApp("shiny", launch.browser = TRUE)'; break;;
    esac
done
