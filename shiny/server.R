library(shiny)
source("helpers.R")

## Call to shinyServer
shinyServer(
    function(input, output) {

        ## -------------------
        ## Parse author emails
        ## -------------------
        author.emails <- eventReactive(input$go, {

            ## ----------------------
            ## Randomize author order
            ## ----------------------
            ## Clean input names
            in.author <- c(input$name1, input$name2, input$name3, input$name4,
                           input$name5, input$name6, input$name7, input$name8)
            in.author <- in.author[in.author != ""]

            validate(
                need(length(in.author) > 1, "Please provide at least two author names to randomize.")
            )

            ## Get random seed
            if(input$seed == ""){
                seed <- get.seed()$seed
                seed.source <- "random.org"
            }else{
                seed <- input$seed
                seed.source <- "user"
            }

            ## Randomize
            d.order <- draw.order(in.author, seed, seed.source)

            ## -------------------
            ## Parse author emails
            ## -------------------
            in.emails <- input$emails

            ## Validate that emails are provided
            validate(
                need(in.emails != "", "Please provide a recipient email for randomizeAuthor results.")
            )

            ## Split
            if(grepl(";", in.emails)){
                out <- strsplit(in.emails, ";")[[1]]
            }else if(grepl(",", in.emails)){
                out <- strsplit(in.emails, ",")[[1]]
            }else{
                out <- in.emails
            }

            ## Validate
            for(i in 1:length(out)){
                validate(
                    need(isValidEmail(out[i]), paste(out[i], "is an invalid email address. Please fix or remove before using randomizeAuthor."))
                )
            }

            ## -----------------
            ## Construct message
            ## -----------------
            str1 <- paste("<strong>Input author order is:</strong>", paste(d.order$orig.order, collapse = ", "))
            str2 <- paste("<strong>Randomized author order is:</strong> ", paste(d.order$author.order, collapse = ", "))
            str3 <- paste("<strong>Random seed is:</strong>", d.order$seed)
            str4 <- paste("<strong>Random seed source is:</strong>", d.order$seed.source)
            str5 <- paste("<strong>Emailing results to:</strong>", paste(out, collapse = ", "))
            
            message.out <- paste(str1, str2, str3, str4, str5, sep = "<br/>")

            ## -----------
            ## Send emails
            ## -----------
            send.mail(out, message.out)
            
            ## Return
            message.out

        })

        ## -------------
        ## Output to app
        ## -------------
        output$text1 <- renderText({
            
            ## Randomize and output to app
            ra.out <- author.emails()
            HTML(ra.out)
  
        })
        
    }
)

