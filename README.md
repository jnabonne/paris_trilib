# Paris Trilib Project
Shiny App to manipulate Paris OpenData about Trilib recycing station.

## About the project
This project is based on Paris OpenData, information and datasets for Trilib are available on [opendata.paris.fr](https://opendata.paris.fr/explore/dataset/trilib/information).

The map displays the trilib recycling stations in Paris.  
Passing the mouse over a station icon will display its type, a click on it will provide additional informations (as full address and status).

As some information are quite volatile _(eg. stations filling rate)_, and to ensure the utility of this tool, the dataset is download each time the application is initiated _(given the very small size of the dataset, ~ 50KB, this will not delay much the launch)_.


## Interacting with the map
You can use the filters provided on the left part to refine the stations selection.  
On the current version you can only filter by trash type for now _(ie. Glass, CB, Can/Plastic)_

_Note: to better see the reflect of filters, it will desactivate stations clustering_


## Shiny structure
The project is composed of the following files:

- `server.R`, the server part of the Shiny app
- `ui.R`, the UI part of the Shiny app
- `trilib.csv`,  the open data used for the project
- 3 images to customize icon on the leaflet map:
  * `recycle-blue.png`
  * `recycle-orange.png`
  * `recycle-red.png`

### Requirements
Libraries:

- _(obviously)_ `shiny`
- `leaflet` to render the map
- `tidyr` & `dplyr` to clean the data
