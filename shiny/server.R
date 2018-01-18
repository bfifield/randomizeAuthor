library(shiny)
library(httr)
library(gmailr)

## To get random seed from random.org API
get.seed <- function(){
   
    ## Get info from random.org api
    url <- "https://www.random.org"
    path <- paste0("integers/?num=1&min=1&max=1000000&col=1&base=10&format=plain&rnd=new")
    out.api <- GET(url = url, path = path)
    seed <- as.numeric(rawToChar(out.api$content))

    return(list(seed = seed, call = out.api))

}

## To randomize the author order conditional on the random seed
draw.order <- function(names, seed, seed.source){
    set.seed(seed)
    draw.names <- names[sample(1:length(names), length(names))]
    return(list(author.order = draw.names, orig.order = names, seed = seed, seed.source = seed.source))
}

## To send email to recipients
send.mail <- function(recipients, text){
    recipients <- c(recipients, "randomizeauthor@gmail.com")
    sender <- "randomizeauthor@gmail.com"
    subject <- "Results of Author Randomization"
    msg <- text
    msg.send <- mime() %>%
        to(recipients) %>%
        from("randomizeauthor@gmail.com") %>%
        subject(paste("Results of Author Randomization -", Sys.time())) %>%
        html_body(msg)
    send_message(msg.send)
}

## To validate emails
isValidEmail <- function(x) {
    grepl("\\<[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}\\>", as.character(x), ignore.case=TRUE)
}

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
