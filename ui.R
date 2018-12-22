library(shiny) ; library(leaflet)

shinyUI(pageWithSidebar(
    headerPanel("Paname Trilib Recycling Sites"),

    sidebarPanel(
        h3('Filtering'),
        p("You can filter recycling sites; this beta version only offers trash type options for now..."),
        textOutput("you can filter by trash type"),
        checkboxGroupInput('binType', "Type :", c('Glass', 'CB', 'Can / Plastic')),
        p("Note: filtering desactivate clustering."),
        actionButton('resetButton', "Clear filters"),

        hr(),
        htmlOutput('sources')
    ),

    mainPanel(
        textOutput('update'),
        leafletOutput('panamap'),
        htmlOutput('legend')
    )    
))