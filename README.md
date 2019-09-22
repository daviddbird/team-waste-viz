# Team Waste - Shiny Dashboard

![Screenshot1.png](https://github.com/daviddbird/team-waste-viz/blob/master/images/Screenshot1.png)

### Introduction
This repro shows an example of visualising waste processing for local authorities and the number of levels of processing that can happen until the waste reaches its final destination. The data populating this dashboard has been synthetically created and is not actual data. It has been created for the purposes of illustrating the dashboard only.

The dashboard was built using R Shiny as part of a group project at [CodeClan's](https://codeclan.com) Data Analysis course in Edinburgh.

### Processing steps
The data was provided in an Excel spreadsheet along with a data dictionary. After reading and becoming familiar with the data dictionary, we were able to determine the key fields to include and identify some features we would need to create. Regular expressions were used to pull out postcode information where possible. This postcode file was then run through a [geocoding service](https://www.doogal.co.uk/BatchGeocoding.php) to fetch the latitude and longitude information required for mapping.

### Packages and other infomation used
The [`leaflet`](https://rstudio.github.io/leaflet) package was used to show the interactive mapping elements. The [`rworldmap`](https://cran.r-project.org/web/packages/rworldmap/rworldmap.pdf) package was used to display the static world map. A [shape file](https://borders.ukdataservice.ac.uk/easy_download_data.html?data=Wales_lad_2011) was added to display the boundary areas of the different Welsh councils (used as an example of a range of authorities who will typically have to manage waste processes).

Following presentation to the client, the data was replaced with [synthetic data](https://en.wikipedia.org/wiki/Synthetic_data) using the r package [`synthpop`](https://cran.r-project.org/web/packages/synthpop/index.html).

### Team members
David Bird, Jenny Wales and Matthew Moffitt.

### Images
![Screenshot2.png](https://github.com/daviddbird/team-waste-viz/blob/master/images/Screenshot2.png)
![Screenshot3.png](https://github.com/daviddbird/team-waste-viz/blob/master/images/Screenshot3.png)
![Screenshot1.png](https://github.com/daviddbird/team-waste-viz/blob/master/images/Screenshot4.png)

### Credits
Office for National Statistics (2011). 2011 Census: boundary data (England and Wales) [data collection].
UK Data Service. SN:5819 UKBORDERS: Digitised Boundary Data, 1840- and Postcode Directories, 1980-.
http://discover.ukdataservice.ac.uk/catalogue/?sn=5819&type=Data%20catalogue,
Retrieved from http://census.ukdataservice.ac.uk/get-data/boundary-data.aspx.
Contains public sector information licensed under the Open Government Licence v3.

Welsh population statistics from https://statswales.gov.wales/Catalogue/Population-and-Migration/Population/Estimates/Local-Authority/populationestimates-by-localauthority-year
