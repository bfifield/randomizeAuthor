shinyUI(fluidPage(
    titlePanel("randomizeAuthor"),

    ## Author name input
    sidebarLayout(
        sidebarPanel(

            ## Input emails
            textInput("emails", label = "Recipient Emails", value = ""),

            ## Input author names
            textInput("name1", label = "Author Names", value = ""),
            textInput("name2", label = "", value = ""),
            textInput("name3", label = "", value = ""),
            textInput("name4", label = "", value = ""),
            textInput("name5", label = "", value = ""),
            textInput("name6", label = "", value = ""),
            textInput("name7", label = "", value = ""),
            textInput("name8", label = "", value = ""),

            ## Input seed
            textInput("seed", label = "Random Seed (Optional)", value = "")## ,
            
        ),

        ## Output randomized order
        mainPanel(
            h2("Welcome to randomizeAuthor!", align = "center"),
            
            h3("Instructions:"),
            HTML("<ul><li>Input email addresses of at minimum two recipients under <strong>Recipient Emails</strong>. Separate each email with a semicolon and a space. For example, <em>authorA@univ.edu; authorB@coll.edu</em>.</li><li>Input author names in blank fields under <strong>Author Names</strong>.</li><li>Hit the <strong>Randomize</strong> button below, which will return the randomized author ordering and the random seed to replicate the results. Results will be emailed to the provided email addresses.</li><li>To replicate results, input author names in the same order, input the random seed in <strong>Random Seed</strong>, and hit the <strong>Randomize</strong> button below.</li></ul>"),

            p(),

            ## Randomize
            actionButton("go", "Randomize"),
            
            h3("Results of Author Randomization:"),
            htmlOutput("text1")
        )
    )

))
