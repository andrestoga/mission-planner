#!/usr/bin/env python3

# converts txt file of planned route to kml file that can be displayed in Google Earth

import sys
import pdb
import utm

if len(sys.argv) !=2:
    print("Need input file name (e.g., gpstokml input.txt)")
    sys.exit()
    
fh = open(sys.argv[1],'r')
fout = open(sys.argv[1][:-4]+".kml",'w')

fout.write('<?xml version="1.0" encoding="UTF-8"?>\n<kml xmlns="http://www.opengis.net/kml/2.2">\n<Document>\n')

#Styles for points
fout.write("<Style id=\"point\">\n  <IconStyle>\n    <scale>0.5</scale>\n    <Icon>\n      <href>http://maps.google.com/mapfiles/kml/shapes/road_shield3.png</href>\n    </Icon>\n  </IconStyle>\n</Style>\n")

n = 1
for i in fh:
    k = i.strip()
    if k.endswith(','):   # sometimes there's a comma at the end; remove it if that's the case
        k = k[:-1]

    tokens = k.rstrip().split(",")
    
    lat,lon = utm.to_latlon(float(tokens[0]), float(tokens[1]), 10, 'S')
    fout.write("  <Placemark>\n")
    fout.write("    <name>" + str(n) + "</name>\n")
    fout.write("    <styleUrl>point</styleUrl>\n    <Point>\n")
    fout.write("      <coordinates>"+str(lon)+","+str(lat)+",2000</coordinates>\n")
    fout.write("    </Point>\n  </Placemark>\n")
    n += 1

fout.write("</Document>\n</kml>\n")

    
fh.close()
fout.close()
