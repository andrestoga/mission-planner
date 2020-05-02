from pykml import parser
import utm
import sys

if len(sys.argv) !=2:
    print("Need input file name (e.g., kml_to_utm input.kml)")
    sys.exit()
    
fout = open(sys.argv[1][:-4]+".txt",'w')
# fout = open("aut_nav_test.txt",'w')

root = parser.fromstring(open(sys.argv[1], 'r').read())
# root = parser.fromstring(open('aut_nav_test.kml', 'r').read())

children = list(root.Document.Folder.Placemark)

for child in children:
	coord = child.Point.coordinates.text
	mierda = coord.split(',')
	lon = mierda[ 0 ]
	lat = mierda[ 1 ]
	easting, northing, zone_number, zone_letter = utm.from_latlon( float(lat), float(lon) )
	fout.write( "{:.10f},{:.10f}\n".format(easting, northing) )
	print("{:.10f},{:.10f}".format(easting, northing))

fout.close()