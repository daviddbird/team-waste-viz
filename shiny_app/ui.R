library(shiny)

ui <- fluidPage(
    
    theme = shinythemes::shinytheme("sandstone"),
    
    titlePanel("Team Waste Dashboard"),
    h5("Waste processing data for one year for Welsh council areas from Q2-2017 to Q1-2018.
        *Please note* this dashboard is populated with synthetic data."),
    tabsetPanel(
        
        tabPanel("Map of Facilities",
                 h5("When you select a council, that council's area is outlined in red on the map. 
                    All the points on the map show where processing happens at each level in the disposal chain for that waste."),
                 h6("Contains National Statistics data © Crown copyright and database right 2019.
    Contains OS data © Crown copyright [and database right] 2019."),
                 checkboxGroupInput("check_grp", 
                                    label = h5("Select processing level(s):"),
                                    choices = list("Level 1" = 1,
                                                   "Level 2" = 2,
                                                   "Level 3" = 3,
                                                   "Level 4" = 4,
                                                   "Level 5" = 5,
                                                   "Level 6" = 6),
                                    selected = 1, inline = TRUE),
                 fluidRow(
                
                     column(3, selectInput("authority", "Which council?", 
                                           choices = all_authority_names)),
                     
                                
                     
                     column(9, leafletOutput("county_map", height = 600))
                     )
                 ),
        
        tabPanel("Map of Materials", h5("Use the map control to explore where different types of waste are processed."),
                 h6("Contains National Statistics data © Crown copyright and database right 2019.
    Contains OS data © Crown copyright [and database right] 2019."),
                 leafletOutput("material_map", height = 600)),
       
        tabPanel("Waste vs Population", 
                 plotOutput("population_plot")),
                
        tabPanel("Waste by Quarter", 
                 fluidRow(
                     column(3, selectInput("authority_time", "Which authority?", 
                                           choices = all_authority_names)),
                     
                     column(9, plotOutput("time_plot"))
                 )
                ),
        
        tabPanel("Material Outliers by Council",
                 
                plotOutput("outliers"),
                 
                 
                plotOutput("outliers_three_authorities")
                 ),
        
        tabPanel("Overseas Waste Destinations", h6("An indication rather than a definitive list of countries where waste from Wales is exported."),
                 h6("We found at least 28 countries - so during the course of 12 months, 14% of countries in the world are importing waste from Wales."),
                 plotOutput("world_map")),
        
        tabPanel("Top Ten Facilities by Tonnage", 
                 plotOutput("top_ten")
        )
    
)     
)        
        