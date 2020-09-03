library(getlandsat)
library(tidyverse)

palo <- readr::read_csv("labs/data/uscities.csv") %>%
    st_as_sf(coords = c("lng", "lat"), crs = 4326) %>%
    filter(city == "Palo", state_name == "Iowa") %>%
    st_transform(5070)

palo_bbox <- palo %>%
    st_buffer(5000) %>%
    st_bbox() %>%
    st_as_sfc() %>%
    st_as_sf()

bounds <- st_bbox(st_transform(palo_bbox, 4326))
landsats <- getlandsat::lsat_scenes()

landsats %>%
    filter(min_lon >= bounds[1]-2, min_lat >= bounds[2]-2, max_lon <= bounds[3]+2, max_lat <= bounds[4]+2) %>%
    filter(as.Date(acquisitionDate) == as.Date("2016-09-26")) %>%
    write.csv(file = "labs/data/palo-flood-scene.csv")