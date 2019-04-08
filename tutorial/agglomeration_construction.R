library(sf)
library(dplyr)
library(smoothr)

#loading data 
setwd("~/cours/DelhiR/delhiR/tutorial/DATA/")
buildings <-  st_read("delhi_buildings/Delhi_Selection_buildings.shp")
plot(buildings)


# size of buffer in meters
buff_size <-  200
# Construct a Buffer around buildings geometry with the given buffer size
buff_buildings <-  st_buffer(buildings, dist = buff_size)
plot(buff_buildings)
#Merging geometries : taking the union of the buffered buildings polygons
merged_buff_buildings <-  st_union(buff_buildings)
#we check the structure of the result
str(merged_buff_buildings)
# we transform as an st object
st_merged_buff_buidings <-  st_sf(geometry= merged_buff_buildings)
#we need to disagregate the single multiplolygon entity into polygons
connex_components <- st_cast(st_merged_buff_buidings, "POLYGON")
# we create a new column to label the components (by their row number)
connex_components$component <-  1:nrow(connex_components)
#now the color should be autoomatically set to the the component number
plot(connex_components)
# we compute the area (in m^2), to select the largest compenent
connex_components$area <-  st_area(connex_components)
#we retain  the largest component ID by arranging (ordering) by area value in descending order
largest_CC<- connex_components %>% top_n(1, area)
#plot gives two subplots becasue there is two columns (default behaviour)
plot(largest_CC)
# we now take the convex hull of the geometry to get the agglomeration shape
agglo <-  st_convex_hull(largest_CC)
plot(agglo)


#we save the object with the inital buildings geometries
st_write(agglo,"tutu.shp")



#we could stop here, but the convex hull seems oversimplified.

#we will try to reach an intermediate level of simplification / agglomeration by simplifying geometries and removing holes

#we start by simplying the geometries off the largest component
#try to adjust the tolerance
simpleCC <-  st_simplify(largest_CC,dTolerance = 200, preserveTopology = F)
plot(simpleCC)

#smoothr package has a function to remove holes , try some values of threshold until every holes is filled 
simpleCC_filled <- fill_holes(simpleCC, 10000000)
plot(simpleCC_filled)


