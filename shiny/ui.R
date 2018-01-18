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
            textInput("seed", label = "Random Seed (Only Provide when Replicating Randomization)", value = "")## ,
            
        ),

        ## Output randomized order
        mainPanel(
            h2("Welcome to randomizeAuthor!", align = "center"),
            
            h3("Instructions:"),
            HTML('<ul><li>Input email addresses of at least one recipient under <strong>Recipient Emails</strong>. Separate each email with a semicolon or a comma. For example, <em>authorA@univ.edu; authorB@coll.edu</em>. A copy of the randomization results will also be sent to <em>randomizeauthor@gmail.com</em>.</li><li>Input author names in blank fields under <strong>Author Names</strong>. Only put one name in each field.</li><li>Hit the <strong>Randomize</strong> button below, which will return the randomized author ordering and the random seed drawn from <em>random.org</em> that can be used to replicate the results. Results will be emailed to the provided email addresses from <em>randomizeauthor@gmail.com</em>.</li><li>To replicate results, input author names in the same order, input the random seed in the <strong>Random Seed</strong> field, and hit the <strong>Randomize</strong> button below.</li><li>If you would like to take a look at the source code powering randomizeAuthor, check out <a href="https://github.com/PrincetonUniversity/randomizeAuthor">our Github repo</a>!</li></ul>'),

            p(),

            ## Randomize
            actionButton("go", "Randomize"),
            
            h3("Results of Author Randomization:"),
            htmlOutput("text1")
        )
    )

))
