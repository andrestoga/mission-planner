%% getGPScoord: function description
function [lon, lat] = getGPScoord(x_pix, y_pix, map_gps_coord, meters_per_pixel)

	lon = map_gps_coord.longitude;
	lat = map_gps_coord.latitute;

	x_m = x_pix * meters_per_pixel;
	y_m = y_pix * meters_per_pixel;

	lon_rad = ( pi / 180 ) * abs( lon );
	lat_rad = ( pi / 180 ) * abs( lat );

	[ x, y ] = getMercatorFromGPS( lon_rad, lat_rad );

	s_x = x + x_m;
	s_y = y + y_m;

	[ s_lon, s_lat ] = getGPSFromMercator( s_x, s_y );

	lon_step = ( 180 / pi ) * ( s_lon - lon_rad );
	lat_step = ( 180 / pi ) * ( s_lat - lat_rad );

	lon = lon + lon_step;
	lat = lat - lat_step;
end