#!/bin/bash

# Deploy
R -e 'rsconnect::deployApp("shiny")'
