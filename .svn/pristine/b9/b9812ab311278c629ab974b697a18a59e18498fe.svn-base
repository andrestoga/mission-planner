files_dir = '';

gps_file_name = 'vin_gps_coords.txt';
gps_file_name = strcat( files_dir, gps_file_name );
fileID = fopen( gps_file_name, 'r' );
% -120.2144086120503,36.84358697333295
C = textscan(fileID, '%f%f', 'Delimiter', ',');

gps_coord = [ C{ 1 }, C{ 2 } ];

% Adapt your algorithm to accept 4 points
top_left = zeros( 1, 2 );% Beginning of starting row
top_right = zeros( 1, 2 );% Ending of starting row
bot_left = zeros( 1, 2 );% Beginning of ending row
bot_right = zeros( 1, 2 );% Ending of ending row

% Open the meta file of the maps
filename = strcat( files_dir, 'maps_meta.txt' );
fileID = fopen( filename, 'r' );
formatSpec = '%f';
maps_meta = fscanf( fileID, formatSpec );

% lon, lat order
top_left( 1 ) = maps_meta( 8 );
top_left( 2 ) = maps_meta( 9 );

top_right( 1 ) = maps_meta( 10 );
top_right( 2 ) = maps_meta( 11 );

bot_right( 1 ) = maps_meta( 12 );
bot_right( 2 ) = maps_meta( 13 );

bot_left( 1 ) = maps_meta( 14 );
bot_left( 2 ) = maps_meta( 15 );

% Sort the GPS points by
% 	gps latitude
% 	then, by their distance to the top_left corner
[gps_coord_sorted, gps_coord_sorted_by_row] = sortPath( top_left, gps_coord );

% TODO: New method to order GPS points
% [gps_coord_sorted, gps_coord_sorted_by_row] = sortPath( top_left, gps_coord, slope_m, row_crop_width_m );

visit_row_every = 1;
numb_times = 0;

% specific_rows = [ 1, 3, 5 ];
% numb_times = 2;

% Selecting specific rows
gps_coord_sorted_selected_rows = selectRows( visit_row_every, numb_times, gps_coord_sorted_by_row );

% Sort the points to waypoints
gps_points = sort_to_waypoints( gps_coord_sorted_selected_rows );

lon = gps_points( :, 1 );
lat = gps_points( :, 2 );

[ x, y, utmzone ] = deg2utm( lat, lon );

number = str2num( utmzone( :, 1:2 ) );

A = [ number, x, y ];
C = cellstr( utmzone( :, 4 ) );
D = [ C(:), num2cell( A ) ]';

% letter,number,East-West position,North-South position
kml_file_name = 'view_kml_vin_utm_coords.txt';
kml_file_name = strcat( files_dir, kml_file_name );
fileID = fopen( kml_file_name,'w' );
fprintf( fileID, '%s,%d,%6.2f,%7.2f\n', D{:} );
fclose( fileID );
fprintf('UTM for KML saved here: %s\n', kml_file_name);

% East-West position,North-South position
utm_file_name = 'vin_utm_coords.txt';
utm_file_name = strcat( files_dir, utm_file_name );
fileID = fopen( utm_file_name,'w' );
fprintf( fileID, '%6.2f,%7.2f\n', [x, y]' );
fclose( fileID );
fprintf('UTM saved here: %s\n', utm_file_name);

% gps_file_name = 'vin_gps_coords.txt';
% gps_file_name = strcat( files_dir, gps_file_name );
% dlmwrite( gps_file_name, gps_coord, 'precision', 16 );
% fprintf('GPS coords saved here: %s\n', gps_file_name);

% utm_file_name = 'vin_utm_coords_sorted.txt';
% utm_file_name = strcat( files_dir, utm_file_name );
% fileID = fopen( utm_file_name,'w' );
% fprintf( fileID, '%6.2f,%7.2f\n', [x, y]' );
% fclose( fileID );
% fprintf('UTM saved here: %s\n', utm_file_name);

%% selectRows: function description
function [selected_rows] = selectRows( row_selection, numb_times, gps_coord_sorted_by_row )

	selected_rows = {};
	selected_rows_i = 1;
	num_rows = length( gps_coord_sorted_by_row );
	counter = 0;

	if length( row_selection ) <= 1

		selected_rows_i = 1;

		while selected_rows_i < num_rows

			tmp = gps_coord_sorted_by_row( selected_rows_i, : );
			selected_rows = [ selected_rows; tmp ];

			selected_rows_i = selected_rows_i + row_selection;
			counter = counter + 1;

			if numb_times > 0

				if counter >= numb_times
					break;
				end

			end

		end

	else

		row_value = sort( row_selection );

		for i = 1:length( row_value )

			selected_rows_i = row_value( i );

			tmp = gps_coord_sorted_by_row( selected_rows_i, : );
			selected_rows = [ selected_rows; tmp ];

		end

	end

end

%% sort_to_waypoints: function description
function [ gps_points_out ] = sort_to_waypoints( gps_points )

	toggle = 0;

	% Reshape and sort the points to waypoint navigation
	[m, ~] = size( gps_points );
	j = 1;
	gps_points_out = [];
	gps_points_tmp_out = [];

	for i = 1:m
		while ~isempty( gps_points{ i, j } )
			gps_points_tmp_out = [ gps_points_tmp_out; gps_points{ i, j } ];
			j = j + 1;
		end

		if toggle == 1
			gps_points_tmp_out = flipud( gps_points_tmp_out );
		end

		toggle = ~toggle;		

		j = 1;
		gps_points_out = [ gps_points_out; gps_points_tmp_out ];
		gps_points_tmp_out = [];
	end
end