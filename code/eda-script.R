# import data
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(lubridate)
ibt <- read_csv("../data/ibtracs-2010-2015.csv", na = c(""),
                col_types = list(col_character(), col_integer(), col_character(),
                                 col_factor(), col_character(), col_character(), 
                                 col_character(), col_character(), col_double(), 
                                 col_double(), col_double(), col_double()))

names(ibt) <- c("serial_num", "season", "num", "basin", "sub_basin", "name", 
                "iso_time", "nature", "latitude", "longitude", "wind", "press")

# convert missing values to NA
ibt <-ibt %>%
  mutate(latitude = na_if(latitude, "-999")) %>%
  mutate(longitude = na_if(longitude, "-999")) %>%
  mutate(wind = na_if(wind, "-1")) %>%
  mutate(wind = na_if(wind, "-999")) %>%
  mutate(wind = na_if(wind, "0")) %>%
  mutate(press = na_if(press, "-1")) %>%
  mutate(press = na_if(press, "-999")) %>%
  mutate(press = na_if(press, "0"))

# summarize data
sink("../output/data-summary.txt")
summary(ibt)
sink()

# clean
## remove records with NAs
ibt <- na.omit(ibt)
## remove trajectories crossing the longitude 180 (only 18)
## Note: for the complete visualization of one trajectory 
flags <- tapply(ibt$longitude, ibt$serial_num, 
            FUN = function(x) {
              flag = 0
              for (i in 1:(length(x)-1)) {
                if (x[i] <= 180 && x[i+1] * x[i] < 0) { 
                  flag = 1
                  break
                }
                if (x[i] >= -180 && x[i+1] * x[i] < 0) {
                  flag = 1
                  break
                }}
              flag
              })
r_flags <- flags[flags==1]
ibt <- ibt[!ibt$serial_num %in% names(r_flags), ]

# visualization
## all years
wmap <- map_data("world")
p_all <-
  ggplot(ibt, aes(x = longitude, y = latitude, group = serial_num)) + 
  geom_polygon(data = wmap, aes(x = long, y = lat, group = group), 
               fill = "whitesmoke", colour = "gray50", size = 0.1) +
  geom_path(alpha = 0.2, size = 0.6, color = "red") +
  scale_x_continuous(name = "Longitude", breaks = seq(-180, 180, 60)) +
  scale_y_continuous(name = "Latitude", breaks = seq(-90, 90, 45)) +
  coord_equal() +
  ggtitle("Trajectories of storms (2010-2015)") +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5)) 
  
width <- 6.75 # in
height <- 3.7
pdf(file = "../images/map-all-storms.pdf", 
    width = width, height = height)
p_all
dev.off()
png(filename = "../images/map-all-storms.png",
    width = width, height = height, units = "in", res = 135)
p_all
dev.off()

## basins EP NA by year
ibt_vis <- ibt[ibt$basin %in% c("EP", "NA"), ]
p_EPNA <-
  ggplot() + 
  geom_polygon(data = wmap, aes(x = long, y = lat, group = group), 
               fill = "whitesmoke", colour = "gray50", size = 0.1) +
  geom_path(aes(x = longitude, y = latitude, group = serial_num,
                color = press),
            data = ibt_vis, size = 0.6) +
  scale_x_continuous(name = "Longitude", breaks = seq(-180, 180, 60)) +
  scale_y_continuous(name = "Latitude", breaks = seq(-90, 90, 45)) +
  scale_color_distiller("Press", palette = "Spectral") +
  facet_grid(season~basin, ) +
  coord_equal(xlim = c(-180, 20), ylim = c(-10, 80)) +
  ggtitle("Trajectories of storms in East Pacific") +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(legend.spacing.x = unit(1,"mm"),
        legend.position = c("left"),
        legend.key.width = unit(2.5, "mm"),
        legend.key.height = unit(16, "mm"),
        legend.background = element_blank(),
        legend.key = element_rect(size = 0)) 
p_EPNA
width <- 6.75 # in
height <- 8
pdf(file = "../images/map-ep-na-storms-by-year.pdf", 
    width = width, height = height)
p_EPNA
dev.off()
png(filename = "../images/map-ep-na-storms-by-year.png",
    width = width, height = height, units = "in", res = 135)
p_EPNA
dev.off()

## basin EP NA by month
ibt_vis <- ibt[ibt$basin %in% c("EP", "NA"), ]
ibt_vis$month <- month(as_date(ibt_vis$iso_time))
p_EPNA_m <-
  ggplot() + 
  geom_polygon(data = wmap, aes(x = long, y = lat, group = group), 
               fill = "whitesmoke", colour = "gray50", size = 0.1) +
  geom_path(aes(x = longitude, y = latitude, group = serial_num,
                color = wind),
            data = ibt_vis, size = 0.6) +
  scale_x_continuous(name = "Longitude", breaks = seq(-180, 180, 60)) +
  scale_y_continuous(name = "Latitude", breaks = seq(-90, 90, 45)) +
  scale_color_distiller("Wind", palette = "BuPu", direction = 1) +
  facet_grid(month~basin, ) +
  coord_equal(xlim = c(-180, 20), ylim = c(-10, 80)) +
  ggtitle("Trajectories of storms in East Pacific") +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(legend.spacing.x = unit(1,"mm"),
        legend.position = c("left"),
        legend.key.width = unit(2.5, "mm"),
        legend.key.height = unit(16, "mm"),
        legend.background = element_blank(),
        legend.key = element_rect(size = 0)) 
p_EPNA_m
width <- 6.75 # in
height <- 12
pdf(file = "../images/map-ep-na-storms-by-month.pdf", 
    width = width, height = height)
p_EPNA_m
dev.off()
png(filename = "../images/map-ep-na-storms-by-month.png",
    width = width, height = height, units = "in", res = 135)
p_EPNA_m
dev.off()


