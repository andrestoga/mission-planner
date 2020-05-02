#!/usr/bin/python3
# GoogleMapDownloader.py 
# Created by Adrien de Jauréguiberry
# Modified by Andres Torres Garcia
# A script which when given four corner gps points in lon and lat format 
# returns a series of images of the whole area

from urllib import request
from PIL import Image
import os
from math import *
from collections import namedtuple
# import yaml

class GoogleMapDownloader:
    """
        A class which generates high resolution google maps images given
        a gmap API key and location parameters
    """

    def __init__(self, API_key, lat, lng, lgth, img_size=1000):
        """
            GoogleMapDownloader Constructor
            Args:
                API_key:  The GoogleMap API key to load images
                lat:      The latitude of the location required
                lng:      The longitude of the location required
                lgth:     Length of the map in m. The map will be a square.
                          warning: too big length will result in distorded map due to mercator projection.
                img_size: The resolution of the output image as img_size X img_size
                          default to 1000
        """
        lat_rad = (pi/180)*lat
        self._img_size = img_size
        self._lat = lat
        self._lng = lng
        self._zoom = floor(log2(156543.03 * img_size / lgth))
        self._resolution = 156543.03 / (2 ** self._zoom) #(m/px)
        self._nb_tiles = ceil(img_size/500)
        self._tile_lgth = lgth/self._nb_tiles
        self._tile_size = int(self._tile_lgth/self._resolution)
        self._API_key = API_key

    def getMercatorFromGPS(self,lng,lat):
        x = 6371000 * lng
        y = 6371000 * log(tan(pi/4 + lat/2))
        return (x,y)

    def getGPSFromMercator(self,x,y):
        lng = x/6371000
        lat = 2*atan(exp(y/6371000)) - pi/2
        return (lng,lat)

    def generateImage(self):
        """
            Generates an image by stitching a number of google map tiles together.
            
            Returns:
                A high-resolution Goole Map image.
        """

        MapMetaData = namedtuple('MapMetaData', ['map', 'resolution', 'zoom', 'width', 'height'])

        lat_rad = (pi/180)*abs(self._lat)
        lng_rad = (pi/180)*abs(self._lng)
        xy_loc  = self.getMercatorFromGPS(lng_rad,lat_rad)

        xy_with_step  = [xy_loc[0]+self._tile_lgth , xy_loc[1]+self._tile_lgth]
        gps_with_step = self.getGPSFromMercator(xy_with_step[0], xy_with_step[1])

        lat_step = (180/pi)*(gps_with_step[1] - lat_rad)
        lon_step = (180/pi)*(gps_with_step[0] - lng_rad)

        # print( str( lat_step ) + " " + str( lon_step ) )

        border = 20        

        # Determine the size of the image
        width, height = self._tile_size * self._nb_tiles, self._tile_size * self._nb_tiles

        #Create a new image of the size require
        map_img = Image.new('RGB', (width,height))

        nb_tiles_max = self._nb_tiles**2
        counter = 1
        for x in range(0, self._nb_tiles):
            for y in range(0, self._nb_tiles) :

                la = self._lat - y*lat_step + lat_step*(self._nb_tiles-1)/2
                lo = self._lng + x*lon_step - lon_step*(self._nb_tiles-1)/2

                url = 'https://maps.googleapis.com/maps/api/staticmap?'
                url += 'center='+str(la)+','+str(lo)
                url += '&zoom='+str(self._zoom)
                url += '&size='+str(self._tile_size+2*border)+'x'+str(self._tile_size+2*border)
                url += '&maptype=satellite'
                if self._API_key:url += '&key='+self._API_key
                print('getting tile '+str(counter)+"/"+str(nb_tiles_max))
                counter+=1

                current_tile = str(x)+'-'+str(y)
                request.urlretrieve(url, current_tile)
            
                im = Image.open(current_tile)
                map_img.paste(im.crop((border,border,self._tile_size+border,self._tile_size+border)), (x*self._tile_size, y*self._tile_size))
              
                os.remove(current_tile)

        # print("Resizing map")
        # print( "Resolution: " + str( self._resolution ) )
        # print( "Zoom: " + str( self._zoom ) )
        # print( "Tile size: " + str( self._tile_size ) )

        _MapMetaData = MapMetaData( map_img, self._resolution, self._zoom, width, height )

        return _MapMetaData
        # return map_img
        # return map_img.resize((self._img_size,self._img_size))

def getMercatorFromGPS(lng,lat):
        x = 6371000 * lng
        y = 6371000 * log(tan(pi/4 + lat/2))
        return (x,y)

def getGPSFromMercator(x,y):
    lng = x/6371000
    lat = 2*atan(exp(y/6371000)) - pi/2
    return (lng,lat)

def generate_vin_img( coord_top_left, coord_bottom_right, sub_map_size, sub_img_size=1000 ):

    # print( "{}  {}".format( coord_top_left[ 0 ], coord_top_left[ 1 ] ) )

    gmap_key  = ""

    VinMetaData = namedtuple('VinMetaData', ['x_sub_maps', 'y_sub_maps', 'height', 'width', 'res', 'zoom'])

    # Getting Mercator coordinates of the top left GPS point
    _lat = coord_top_left[ 1 ]
    _lng = coord_top_left[ 0 ]
    lat_rad = ( pi / 180 ) * abs( _lat )
    lng_rad = ( pi / 180 ) * abs( _lng )
    xy_loc  = getMercatorFromGPS( lng_rad, lat_rad )

    # Getting the step for the middle point in lat and lon coordinates
    xy_with_step  = [ xy_loc[ 0 ] + sub_map_size, xy_loc[ 1 ] + sub_map_size ]
    gps_with_step = getGPSFromMercator( xy_with_step[ 0 ], xy_with_step[ 1 ] )
    lat_step = ( 180 / pi ) * ( gps_with_step[ 1 ] - lat_rad )
    lon_step = ( 180 / pi ) * ( gps_with_step[ 0 ] - lng_rad )

    # print( "My method " + str( lat_step ) + " " + str( lon_step ) )

    # Getting the init step in lat and lon coordinates
    init_xy_with_step  = [ xy_loc[ 0 ] + sub_map_size / 2, xy_loc[ 1 ] + sub_map_size / 2 ]
    init_gps_with_step = getGPSFromMercator( init_xy_with_step[ 0 ], init_xy_with_step[ 1 ] )
    init_lat_step = ( 180 / pi ) * ( init_gps_with_step[ 1 ] - lat_rad )
    init_lon_step = ( 180 / pi ) * ( init_gps_with_step[ 0 ] - lng_rad )

    # Getting Mercator coordinates of the bottom right GPS point
    _lat_bot_r = coord_bottom_right[ 1 ]
    _lng_bot_r = coord_bottom_right[ 0 ]
    lat_rad_bot_r = ( pi / 180 ) * abs( _lat_bot_r )
    lng_rad_bot_r = ( pi / 180 ) * abs( _lng_bot_r )
    xy_loc_bot_right  = getMercatorFromGPS( lng_rad_bot_r, lat_rad_bot_r )

    # print( str( xy_loc[ 0 ] ) + " " + str( xy_loc[ 1 ] ) )
    # print( str( xy_loc_bot_right[ 0 ] ) + " " + str( xy_loc_bot_right[ 1 ] ) )

    # Computing the width and height ( meters ) of the vineyard
    vin_width = xy_loc[ 0 ] - xy_loc_bot_right[ 0 ]
    vin_height = xy_loc[ 1 ] - xy_loc_bot_right[ 1 ]

    # Computing the number of sub-maps
    x_sub_maps = ceil( vin_width / sub_map_size )
    y_sub_maps = ceil( vin_height / sub_map_size )

    la = _lat - init_lat_step;
    lo = _lng + init_lon_step;
    counter = 1

    print( "width " + str( vin_width ) )
    print( "height " + str( vin_height ) )
    print( "Number of submaps {} x {} = {}".format( x_sub_maps, y_sub_maps, x_sub_maps * y_sub_maps ) )

    for y in range(0, y_sub_maps):
        for x in range(0, x_sub_maps) :

            tmp_lo = lo + x * lon_step
            tmp_la = la - y * lat_step

            lo_top_left = _lng + x * lon_step
            la_top_left = _lat - y * lat_step
            
            gmd = GoogleMapDownloader(gmap_key, tmp_la, tmp_lo, sub_map_size, sub_img_size)
            print("getting sub map " + str(counter) + "/" + str( x_sub_maps * y_sub_maps ) )
            # print( str( tmp_la ) + " " + str( tmp_lo ) )

            try:
                # Get the high resolution image
                metaData = gmd.generateImage()
            except IOError:
                print("ERROR: Could not generate the image - use another key or change the location")
            else:

                # _MapMetaData = MapMetaData( map_img, self._resolution, zoom, width, height )

                img = metaData.map
                res = metaData.resolution
                zoom = metaData.zoom
                width = metaData.width
                height = metaData.height

                #Save the image to disk
                # img.save("sub_map_" + str( counter ) + ".jpg" )
                img.save("sub_map_" + str( counter ) + ".png" )
                print("The submap has successfully been created")
                # Save in a file, with the same name as the image, the top left coordinates of each sub
                file = open( "sub_map_" + str( counter ) + ".txt", "w" )
                file.write( str( lo_top_left ) + "\n" )
                file.write( str( la_top_left ) )
                file.close()

            counter+=1

    # print( "My method {}  {}".format( xy_loc[ 0 ], xy_loc[ 1 ] ) )

    _VinMetaData = VinMetaData( x_sub_maps, y_sub_maps, height, width, res, zoom )

    return _VinMetaData

def run_example():
    # Create a new instance of GoogleMap Downloader

    #GMap API is not free! Even if this script we adapted to use free acount settings
    #you might need a project key.
    #You can find one here: https://developers.google.com/maps/documentation/static-maps/intro
    gmap_key  = ""

    GPScoord = namedtuple('GPScoord', ['lon', 'lat'])
    # GPScoord = namedtuple('GPScoord', ['leftmost', 'rightmost', 'topmost', 'lowest'])

    # lon and lat order
    coord_top_left = GPScoord( -120.214320,  36.843594 )
    coord_top_right = GPScoord( -120.210804, 36.843602 )

    coord_bot_left = GPScoord( -120.214298, 36.841369 )
    coord_bot_right = GPScoord( -120.210804, 36.841378 )

    # lo = coord_top_left[ 0 ]
    # la = coord_top_left[ 1 ]

    # Get the leftmost coordinate out of the two left points
    if coord_top_left[ 0 ] < coord_bot_left[ 0 ]:
        leftmost = coord_top_left[ 0 ]
    else:
        leftmost = coord_bot_left[ 0 ]

    # Get the rightmost coordinate out of the two right points
    if coord_top_right[ 0 ] > coord_bot_right[ 0 ]:
        rightmost = coord_top_right[ 0 ]
    else:
        rightmost = coord_bot_right[ 0 ]

    # Get the topmost/uppermost coordinate out of the two top points
    if coord_top_left[ 1 ] > coord_top_right[ 1 ]:
        topmost = coord_top_left[ 1 ]
    else:
        topmost = coord_top_right[ 1 ]

    # Get the lowest coordinate out of the two bottom points
    if coord_bot_left[ 1 ] < coord_bot_right[ 1 ]:
        lowest = coord_bot_left[ 1 ]
    else:
        lowest = coord_bot_right[ 1 ]

    # print( "{}  {}".format( coord_top_left[ 0 ], coord_top_left[ 1 ] ) )    

    sub_map_size  = 85
    sub_img_size  = 1320

    # Start getting images from the leftmost and highest point and stop at the rightmost and lowest point.
    coord_top_left = GPScoord( leftmost, topmost )
    coord_bot_right = GPScoord(  rightmost, lowest )

    metaData = generate_vin_img( coord_top_left, coord_bot_right, sub_map_size )

    x_sub_maps = metaData.x_sub_maps
    y_sub_maps = metaData.y_sub_maps
    height = metaData.height
    width = metaData.width
    res = metaData.res
    zoom = metaData.zoom

    file = open( "maps_meta.txt", "w" )
    # image_num: 20
    file.write( str( x_sub_maps * y_sub_maps ) + "\n" )
    # img_per_col: 0.1
    file.write( str( x_sub_maps ) + "\n" )
    # img_per_row: 0.1
    file.write( str( y_sub_maps ) + "\n" )
    # height: 0.1
    file.write( str( height ) + "\n" )
    # width: 0.1
    file.write( str( width ) + "\n" )
    # m_pix: 0.1
    file.write( str( res ) + "\n" )
    # zoom
    file.write( str( zoom ) + "\n" )
    # top_left_point: 0.1
    file.write( str( coord_top_left.lon ) + "\n" )
    file.write( str( coord_top_left.lat ) + "\n" )
    # top_right_point: 0.1
    file.write( str( coord_top_right.lon ) + "\n" )
    file.write( str( coord_top_right.lat ) + "\n" )
    # bot_left_point: 0.1
    file.write( str( coord_bot_left.lon ) + "\n" )
    file.write( str( coord_bot_left.lat ) + "\n" )
    # bot_right_point: 0.1
    file.write( str( coord_bot_right.lon ) + "\n" )
    file.write( str( coord_bot_right.lat ) )
    file.close()
        
run_example()