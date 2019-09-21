library(shiny)
library(readxl)
library(tidyverse)
library(leaflet)
require(rgdal)
library(ggthemes)
library(shinythemes)
library(rworldmap)

# Loading required data---------------------------------------------------------
#Calling datasets

waste_new <- read.csv("../outputs/synth_waste.csv")

# prevent scientific notation
options(scipen=999)

#-------------------------------------------------------------------------------

# required for the Waste by quater tab------------------------------------------
period_breakdown <- waste_new %>%
  dplyr::select(county_name, 
         period_ID, 
         tonnes.by.material, 
         #material, 
         is.leaf.level) %>%
  drop_na(tonnes.by.material) %>%
  filter(is.leaf.level == FALSE)
#-------------------------------------------------------------------------------

# unique list of counties
all_authority_names <- unique(waste_new$county_name)

# unique list of facility types
all_facility_types <- unique(waste_new$facility.type)

# reading in the shape file information-----------------------------------------
# and transforming it to correct CRS to map in leaflet
wales_shape <-  readOGR("../shapefile/Wales_lad_2011/")
wales <- spTransform(wales_shape, CRS("+init=epsg:4326"))
#-------------------------------------------------------------------------------

# required for the World map section -------------------------------------------
# reading in the countries csv
countries <- read_csv("../outputs/countries.csv")
# renameing the Name column to Countries
countries <- countries %>% rename(Countries = Name)
# joining the countries
countries_map <- joinCountryData2Map(countries, joinCode = "ISO3",
                                     nameJoinColumn = "ISO_code")

#creating the world map
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
#------------------------------------------------------------------------------


# required for Waste vs population tab-----------------------------------------
population_df <- data.frame(
  county_name = c(
    "Isle of Anglesey", "Gwynedd", "Conwy",
    "Denbighshire", "Flintshire", "Wrexham", "Powys", "Ceredigion", "Pembrokeshire", 
    "Carmarthenshire", "Swansea", "Neath Port Talbot", "Bridgend", "The Vale of Glamorgan",
    "Cardiff", "Rhondda Cynon Taf", "Merthyr Tydfil", "Caerphilly", "Blaenau Gwent",
    "Torfaen", "Monmouthshire", "Newport"), 
  population = c(
    69961, 124178, 117181, 95330, 155593, 136126, 132447, 72992, 125055,
    187568, 246466, 142906, 144876, 132165, 364248, 240131, 60183, 181019, 69713,
    93049, 94142, 153302),
  area = c(
    711, 2535, 1126, 837, 
    437, 504, 5181, 1786, 1619, 2370, 380, 441, 251, 331, 141, 424, 111, 277, 109, 
    126, 849, 191))

sum_tonnes_by_material <- waste_new %>%
  drop_na(tonnes.by.material) %>%
  filter(is.leaf.level == FALSE) %>%
  group_by(county_name) %>%
  summarise(total_tonnes_by_material = sum(tonnes.by.material))

pop_and_waste <- sum_tonnes_by_material %>%
  full_join(population_df, key = "county_name")

pop_and_waste <- pop_and_waste %>%
  mutate(tonnes_by_pop = total_tonnes_by_material/population)

#-------------------------------------------------------------------------------
