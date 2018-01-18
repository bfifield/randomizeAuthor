library(gmailr)

## Check if email sends
msg.send <- mime() %>%
    to("randomizeauthor@gmail.com") %>%
    from("randomizeauthor@gmail.com") %>%
    subject(paste("Test Email Functionality -", Sys.Date())) %>%
    html_body("Test message")
send_message(msg.send)

