# team-waste-viz
Team Waste - Shiny Dashboard

This repro shows an example of visualising waste processing for local authorities and the number of levels of processing that can happen until the waste reaches it's final destination. The data populating this dashboard has been synthetically created and is not actual data. It has been created for the purposes of illustrating the dashboard only.

The dashboard was build using R Shiny as part of a group project at [CodeClan's](https://codeclan.com) Data Analysis course in Edinburgh.

The [`leaflet`](https://rstudio.github.io/leaflet) package was used to show the interactive mapping elements. The [`rworldmap`](https://cran.r-project.org/web/packages/rworldmap/rworldmap.pdf) package was used to display the static world map. A [shape file](https://borders.ukdataservice.ac.uk/easy_download_data.html?data=Wales_lad_2011) was used to display the boundary areas of the different Welsh councils (used as an example of a range of authorities who will typically have to manage waste processes).




Office for National Statistics (2011). 2011 Census: boundary data (England and Wales) [data collection].
UK Data Service. SN:5819 UKBORDERS: Digitised Boundary Data, 1840- and Postcode Directories, 1980-.
http://discover.ukdataservice.ac.uk/catalogue/?sn=5819&type=Data%20catalogue,
Retrieved from http://census.ukdataservice.ac.uk/get-data/boundary-data.aspx.
Contains public sector information licensed under the Open Government Licence v3.
