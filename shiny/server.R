library(shiny)
library(httr)
library(mailR)

get.seed <- function(){
   
    ## Get info from random.org api
    url <- "https://www.random.org"
    path <- paste0("integers/?num=1&min=1&max=1000000&col=1&base=10&format=plain&rnd=new")
    out.api <- GET(url = url, path = path)
    seed <- as.numeric(rawToChar(out.api$content))

    return(list(seed = seed, call = out.api))

}

draw.order <- function(names, seed, seed.source){
    set.seed(seed)
    draw.names <- names[sample(1:length(names), length(names))]
    return(list(author.order = draw.names, orig.order = names, seed = seed, seed.source = seed.source))
}

## send.mail <- function(recipients, text){

    
    

## }

shinyServer(
    function(input, output) {

        ## ----------------------
        ## Randomize author order
        ## ----------------------
        randomize.authors <- eventReactive(input$go, {

            ## Clean input names
            in.author <- c(input$name1, input$name2, input$name3, input$name4,
                           input$name5, input$name6, input$name7, input$name8)
            in.author <- in.author[in.author != ""]

            ## Get random seed
            if(input$seed == ""){
                seed <- get.seed()$seed
                seed.source <- "random.org"
            }else{
                seed <- input$seed
                seed.source <- "user"
            }

            ## Randomize
            draw.order(in.author, seed, seed.source)
            
        })

        ## -------------------
        ## Parse author emails
        ## -------------------
        author.emails <- eventReactive(input$go, {
            
            ## Parse email addresses of recipients
            in.emails <- input$emails
            validate(
                need(grepl("; ", in.emails), "Email addresses must be split by '; '.")
            )

            ## Split 
            split.out <- strsplit(in.emails, "; ")[[1]]

            ## Test length
            validate(
                need(length(split.out) > 1, "Must provide at least two recipient email addresses.")
            )

            ## Return
            split.out

        })

        ## -------------
        ## Output to app
        ## -------------
        output$text1 <- renderText({
            
            ## Get emails
            em.out <- author.emails()
            
            ## Randomize and output to app
            ra.out <- randomize.authors()
            str1 <- paste("<strong>Input author order is:</strong>", paste(ra.out$orig.order, collapse = ", "))
            str2 <- paste("<strong>Randomized author order is:</strong> ", paste(ra.out$author.order, collapse = ", "))
            str3 <- paste("<strong>Random seed is:</strong>", ra.out$seed)
            str4 <- paste("<strong>Random seed source is:</strong>", ra.out$seed.source)
            str5 <- paste("<strong>Emailing results to:</strong>", paste(em.out, collapse = ", "))
            message.out <- paste(str1, str2, str3, str4, str5, sep = "<br/>")
            HTML(message.out)

            ## ## Email results
            ## send.mail(em.out, message.out)
  
        })

    }
)
