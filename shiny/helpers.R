library(httr)
library(mailR)
library(dotenv)

## To get random seed from random.org API
get_seed <- function(){
   
    ## Get info from random.org api
    url <- "https://www.random.org"
    path <- paste0("integers/?num=1&min=1&max=1000000&col=1&base=10&format=plain&rnd=new")
    out.api <- GET(url = url, path = path)
    seed <- as.numeric(rawToChar(out.api$content))

    return(list(seed = seed, call = out.api))

}

## To randomize the author order conditional on the random seed
draw_order <- function(names, seed, seed.source){
    set.seed(seed)
    draw.names <- names[sample(1:length(names), length(names))]
    return(list(author.order = draw.names, orig.order = names, seed = seed, seed.source = seed.source))
}

## To send email to recipients
send_mail <- function(recipients, text){
    load_dot_env(".env")
    pw <- Sys.getenv("pw")
    recipients <- c(recipients, "randomizeauthor@gmail.com")
    send.mail(
        from         = "randomizeauthor@gmail.com",
        to           = recipients,
        subject      = paste("Results of Author Randomization -", Sys.time()),
        body         = text,
        html         = TRUE,
        smtp         = list(host.name = "smtp.gmail.com", port = 465,
                            user.name = "randomizeauthor", passwd = pw,
                            ssl = TRUE),
        authenticate = TRUE,
        send         = TRUE
    )
}

## To validate emails
is_valid_email <- function(x) {
    grepl("\\<[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}\\>", as.character(x), ignore.case=TRUE)
}

