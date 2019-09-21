server <- function(input, output) {
    
    # Top ten facilities by tonnage tab ---------------------------------------
    output$top_ten <- renderPlot({
        #top_ten_plot
        waste_new %>%
            dplyr::select(
                is.leaf.level, 
                facility.name, 
                tonnes.by.material, 
                authority) %>%
            drop_na(tonnes.by.material) %>%
            filter(is.leaf.level == FALSE) %>%
            group_by(facility.name) %>%
            summarise(total_material_in_tonnes = sum(tonnes.by.material)) %>%
            arrange(desc(total_material_in_tonnes)) %>%
            filter(facility.name != "Other/Exempt") %>%
            slice(1:10) %>%
            ggplot() +
            aes(x = reorder(facility.name, total_material_in_tonnes), 
                y = total_material_in_tonnes) +
            geom_col()  +
            coord_flip() +
            labs(title = "Top Ten Facilities by Material Processed", 
                 x = "Facility Name",
                 y = "Total Material (tonnes)")
        
    }, height = 600)
    #--------------------------------------------------------------------------
    
    # Waste by quater tab------------------------------------------------------
    output$time_plot <- renderPlot({
        waste_new %>%
            dplyr::select(period_ID, 
                   authority,
                 #  authorityid,
                   county_name,
                 #  total.tonnes, 
                   tonnes.by.material,
                   waste.stream.type,
                   is.leaf.level) %>%
            filter(is.leaf.level == FALSE) %>%
            filter(county_name == input$authority_time) %>%
            drop_na() %>%
            ggplot() +
            aes(x = waste.stream.type, y = tonnes.by.material) +
            geom_bar(stat = "identity") +
            facet_wrap(~ period_ID) +
            coord_flip() +
            ggtitle("Waste by Quarter")
        
    })
    #--------------------------------------------------------------------------
    
    # UK map of facilities tab-------------------------------------------------
    output$county_map <- renderLeaflet({
        waste_new %>%
            filter(county_name == input$authority) %>%
            filter(is.leaf.level == FALSE) %>%
            drop_na(latitude) %>%
            drop_na(longitude) %>%
            filter(level %in% input$check_grp) %>%
            leaflet() %>% 
            addTiles() %>% 
            addProviderTiles(providers$OpenStreetMap) %>% 
            addPolygons(data = wales[wales$name == input$authority, ], 
                        fill = input$authority, 
                        stroke = TRUE, 
                        color = "red",
                        label = ~as.character(input$authority)) %>%
            addMarkers(lng = ~longitude, 
                       lat = ~ latitude,
                       label = ~as.character(facility.name),
                       clusterOptions = markerClusterOptions())
    })
    
    # selecting levels
    output$level <- renderPrint({input$check_grp})
    
    # -------------------------------------------------------------------------
    
    # UK map of materials tab--------------------------------------------------
    output$material_map <- renderLeaflet({
        leaflet() %>%
            # Adding Tiles
            addTiles() %>%
            
            addMarkers(lng = ~longitude, 
                       lat = ~latitude, 
                       data = waste_new %>%
                           drop_na(latitude) %>%
                           drop_na(longitude) %>%
                           filter(is.leaf.level == FALSE) %>%
                           filter(waste.stream.type == "Comingled recyclate"), 
                       group = "Comingled recyclate", 
                       clusterOptions = markerClusterOptions(), 
                       label = ~as.character(facility.name)) %>%
            addMarkers(lng = ~longitude, 
                       lat = ~latitude,
                       data = waste_new %>%
                           drop_na(latitude) %>%
                           drop_na(longitude) %>%
                           filter(is.leaf.level == FALSE) %>%
                           filter(waste.stream.type == "Food waste"), 
                       group = "Food waste", 
                       clusterOptions = markerClusterOptions(), 
                       label = ~as.character(facility.name)) %>% 
            addMarkers(lng = ~longitude, 
                       lat = ~latitude,
                       data = waste_new %>%
                           drop_na(latitude) %>%
                           drop_na(longitude) %>%
                           filter(is.leaf.level == FALSE) %>%
                           filter(waste.stream.type == "Mixed green and food waste"), 
                       group = "Mixed green & food waste", 
                       clusterOptions = markerClusterOptions(), 
                       label = ~as.character(facility.name)) %>%
            addMarkers(lng = ~longitude, 
                       lat = ~latitude,
                       data = waste_new %>%
                           drop_na(latitude) %>%
                           drop_na(longitude) %>%
                           filter(is.leaf.level == FALSE) %>%
                           filter(waste.stream.type == "Green waste"), 
                       group = "Green waste", 
                       clusterOptions = markerClusterOptions(), 
                       label = ~as.character(facility.name)) %>% 
            addMarkers(lng = ~longitude, 
                       lat = ~latitude,
                       data = waste_new %>%
                           drop_na(latitude) %>%
                           drop_na(longitude) %>%
                           filter(is.leaf.level == FALSE) %>%
                           filter(waste.stream.type == "Source segregated recyclate"), 
                       group = "Source segregated recyclate", 
                       clusterOptions = markerClusterOptions(), 
                       label = ~as.character(facility.name)) %>%
            addMarkers(lng = ~longitude, 
                       lat = ~latitude,
                       data = waste_new %>%
                           drop_na(latitude) %>%
                           drop_na(longitude) %>%
                           filter(is.leaf.level == FALSE) %>%
                           filter(waste.stream.type == "Residual waste"), 
                       group = "Residual waste", 
                       clusterOptions = markerClusterOptions(), 
                       label = ~as.character(facility.name)) %>%  
            
            
            # Layers control
            addLayersControl(
                overlayGroups = c("Comingled recyclate",
                                  "Food waste",
                                  "Mixed green & food waste",
                                  "Green waste",
                                  "Source segregated recyclate",
                                  "Residual waste"),
                options = layersControlOptions(collapsed = FALSE)
            )
    })
    # -------------------------------------------------------------------------
    
    # Material outliers by Welsh authorities tab-------------------------------
    # Waste by tonnange by authority box plot (top section of page)
    output$outliers <- renderPlot({
      #  waste_postcodes_latlong %>%
        waste_new %>%
            drop_na(authority) %>%
            ggplot() + 
            aes(reorder(authority, tonnes.by.material, na.rm = TRUE), 
                tonnes.by.material) + 
            geom_boxplot(outlier.size = 2) + 
            ylab("Tonnes") +
            xlab("Welsh Authority") +
            ggtitle("Waste Tonnage by Authority") +
            theme(plot.title = element_text(size = 17, face = "bold"),
                  axis.title = element_text(size = 17),
                  axis.text = element_text(size = 15)) +
            coord_flip()
    })
    
    # Faceted box plots at lower section of page--------------------------------
    output$outliers_three_authorities <- renderPlot({
        #waste_postcodes_latlong %>%
        waste_new %>%
        drop_na(material) %>%
        filter(authority %in% c("Flintshire County Council", 
                                "Wrexham CBC", 
                                "Cardiff County Council"),
               tonnes.by.material > quantile(tonnes.by.material, 
                                             0.95, 
                                             na.rm = TRUE)) %>%
        ggplot() + aes(reorder(material, tonnes.by.material, na.rm = TRUE), 
                       tonnes.by.material, 
                       fill = authority) + 
        geom_boxplot() +
        facet_wrap(~authority) +
        theme(legend.position = "none", 
              strip.text.x = element_text(size = 16, face = "bold"),
              panel.spacing = unit(2, "lines"),
              axis.title = element_text(size = 14, face = "bold"),
              axis.text = element_text(size = 14)) +
        xlab("Material Type") +
        ylab("Tonnes") +
        coord_flip()
    })
    #--------------------------------------------------------------------------
    
    # Waste destinations outside the UK tab------------------------------------
    output$world_map <- renderPlot({
        mapCountryData(countries_map, 
                       nameColumnToPlot = "Countries", 
                       catMethod = "categorical",
                       missingCountryCol = grey(.8), 
                       colourPalette = c("#999999", 
                                         "#E69F00", 
                                         "#56B4E9", 
                                         "#009E73", 
                                         "#F0E442", 
                                         "#0072B2", 
                                         "#D55E00", 
                                         "#CC79A7"))
    }, height = 600)
    #--------------------------------------------------------------------------
    
    # Waste vs population (Welsh authorities) tab------------------------------
    output$population_plot <- renderPlot({
        pop_and_waste %>%
            ggplot() +
            aes(x = reorder(county_name, total_tonnes_by_material), 
                y = total_tonnes_by_material, 
                fill = -population) +
            geom_col() +
            coord_flip() +
            ggtitle("Comparison of council areas by waste and population") +
            labs(
                x = "\nCounty",
                y = "Tonnes by material",
                title = "Comparison of council areas by waste and population"
            )
        
    })
    #--------------------------------------------------------------------------

}





