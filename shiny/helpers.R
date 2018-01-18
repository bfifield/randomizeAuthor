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

