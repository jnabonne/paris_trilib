library(shiny) ; library(leaflet)
library(tidyr) ; library(dplyr)

# download and read dataset
website  <- "https://opendata.paris.fr/explore/dataset/trilib"
file_url <- "/download/?format=csv&timezone=Europe/Berlin&use_labels_for_header=true"
download.file(paste(website, file_url, sep=''), destfile="trilib.csv", method="curl")
download_date <- date()
df <- read.csv('trilib.csv', header=TRUE, sep=';')
# transform geo col into exploitable lat long
df <- separate(df, geo, into=c('lat', 'long'), sep=',', convert=TRUE)
# adding nice icon depending on filling rate
icon_red    <- makeIcon('recycle-red.png')
icon_orange <- makeIcon('recycle-orange.png')
icon_blue   <- makeIcon('recycle-blue.png')
df <- mutate(df, color=ifelse(fillingRate>75, 'red', 
                       ifelse(fillingRate>50, 'orange', 'blue')))

shinyServer(
    function(input, output, session) {
        output$sources <- renderText("Source: <a href='https://opendata.paris.fr/explore/dataset/trilib/information'>Open Data Paris</a>")
        output$update  <- renderText(paste("data freshness:", download_date))

        # reset filters' checkboxes
        observeEvent(input$resetButton, {
            updateCheckboxGroupInput(session, inputId='binType', selected=NULL, 
                                     choices=c('Glass', 'CB', "Can / Plastic"))
        })
        
        output$panamap <- renderLeaflet({
            # default leaflet map with clustering
            if(is.null(input$binType)) {
                output$legend <- renderText('')
                df %>% leaflet() %>% 
                    addProviderTiles(providers$CartoDB.Positron) %>% 
                    addMarkers(label=~wastetype_designation, 
                        popup=~paste(localisationfo_street,' (',fillingRate,'% full)', sep=''), 
                        clusterOptions=markerClusterOptions())
            }
            # leaflet maps with filter (desactivates clustering)
            else {
                # filter data
                df_sub <- filter(df, wastetype_designation==input$binType)
                # build legend
                output$legend <- renderText("Filling rate: <font color='blue'>under 50%</font> / <font color='orange'>between 50%-75%</font> / <font color='red'>over 75%</font>")
                # rendering map
                leaflet() %>% 
                    addProviderTiles(providers$CartoDB.Positron) %>% 
                    addMarkers(data=subset(df_sub, color=='red'),    icon=icon_red,    
                        label=~wastetype_designation, popup=~paste(localisationfo_street, 
                            ' (', fillingRate, '% full)', sep='')) %>%
                    addMarkers(data=subset(df_sub, color=='orange'), icon=icon_orange, 
                        label=~wastetype_designation, popup=~paste(localisationfo_street, 
                            ' (', fillingRate, '% full)', sep='')) %>%
                    addMarkers(data=subset(df_sub, color=='blue'),   icon=icon_blue,   
                        label=~wastetype_designation, popup=~paste(localisationfo_street, 
                            ' (', fillingRate, '% full)', sep=''))
            }
        })
    }
)