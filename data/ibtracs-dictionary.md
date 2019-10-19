##Metadata for ibtraces

Data used in this project was downloaed from IBTrACs NOAA, which provides tropical cyclone best track data in a numerous formats. CSV data files in version 3 of years 2010-2015 were collected from the archive center of IBTrACs ([ftp://eclipse.ncdc.noaa.gov/pub/ibtracs/v03r10/all/csv/](ftp://eclipse.ncdc.noaa.gov/pub/ibtracs/v03r10/all/csv/)). The cyclone track data include a variety of attributes describing different characteristics of storms. 12 variables were extracted from the downloaed CSV files and combined into one file (ibtracs-2010-2015.csv). The table below offers a description of the 12 variables.



| Variable   | Data Type   | Description                                                  |
| ---------- | ----------- | ------------------------------------------------------------ |
| serial_num | character   | Storm Identifier                                             |
| season     | integer     | Year                                                         |
| num        | integer     | The caridinal number of the systems for the season (year)    |
| basin      | character   | Basins: A typical classfication of the world <br/>NA (North Atlantic )<br/>EP (Eastern North Pacific)<br/>WP (Western North Pacific)<br/>NI (North Indian)<br/>SI (South Indian)<br/>SP (Southern Pacific)<br/>SA (South Atlantic) |
| sub_basin  | character   | Subbasins: The subregions that storms occurs<br/>CS - Caribbean Sea<br/> GM - Gulf of Mexico<br/> CP - Central Pacific<br/> BB - Bay of Bengal<br/> AS - Arabian Sea<br/> WA - Western Australia<br/> EA - Eastern Australia |
| name       | character   | Name provided by the agency                                  |
| iso_time   | character   | ISO TimE in Universal Time Coordinates (UTC) <br/>Specific times for the observation of storms |
| nature     | character   | Storm types<br/> DS - Disturbance<br/> TS - Tropical<br/> ET - Extratropical<br/> SS - Subtropical<br/> NR - Not reported<br/> MX - Mixture |
| latitude   | float value | Coordinates of storms                                        |
| longitude  | float value | Coordiantes of storms                                        |
| wind       | float value | Wind speed at the observation time                           |
| press      | float value | Pressure at the observation time                             |

