close all;
clc;
clear;
clear getGPScoord_sub_map;

% files_dir = 'TestingImgs/First_half/';
% files_dir = 'TestingImgs/Second_half/';
files_dir = '';

% Open the meta file of the maps
filename = strcat( files_dir, 'maps_meta.txt' );
fileID = fopen( filename, 'r' );
formatSpec = '%f';
maps_meta = fscanf( fileID, formatSpec );

image_name = 'sub_map';
image_ext = 'png';
meta_ext = 'txt';
image_num = maps_meta( 1 );
img_per_row = maps_meta( 2 );
resolution = maps_meta( 6 );

pathName = strcat( files_dir, image_name, '_' );
pathNameOut = strcat( pathName, 'out_' );
image_ext = strcat( '.', image_ext );
meta_ext = strcat( '.', meta_ext );

gps_coord = [];
gps_coord_i = 0;
slope_m = 0;
row_crop_width_m = 0;
left_pix = 0;

for i = 1:image_num
	sub_map_file_name = sprintf('%s%d%s', pathName, i, image_ext );
	sub_map_output_file_name = sprintf('%s%d%s', pathNameOut, i, image_ext );
	sub_map_meta_file_name = sprintf('%s%d%s', pathName, i, meta_ext );

	fprintf('Processing sub map %d of %d\n', i, image_num );

	col = mod( i, img_per_row );

	if col ~= 0 && col ~= 1
		isLastImgCol = false;
		isFirstImgCol = false;
		[ gps_coord_tmp, tmpSlope, tmp_row_crop_width, left_pix ] = getGPScoord_sub_map( sub_map_file_name, sub_map_meta_file_name, sub_map_output_file_name, resolution, isLastImgCol, isFirstImgCol, left_pix, files_dir );

    elseif col == 1

		isLastImgCol = false;
		isFirstImgCol = true;
		left_pix = 0;
		[ gps_coord_tmp, tmpSlope, tmp_row_crop_width, left_pix ] = getGPScoord_sub_map( sub_map_file_name, sub_map_meta_file_name, sub_map_output_file_name, resolution, isLastImgCol, isFirstImgCol, left_pix, files_dir );

	else
		
		isLastImgCol = true;
		isFirstImgCol = false;
		[ gps_coord_tmp, tmpSlope, tmp_row_crop_width, left_pix ] = getGPScoord_sub_map( sub_map_file_name, sub_map_meta_file_name, sub_map_output_file_name, resolution, isLastImgCol, isFirstImgCol, left_pix, files_dir );
	end

	slope_m = slope_m + tmpSlope;
	row_crop_width_m = row_crop_width_m + tmp_row_crop_width;

	gps_coord_i = gps_coord_i + length( gps_coord_tmp );
	gps_coord = [ gps_coord; gps_coord_tmp ];

	% save_gps_to_utm_file( gps_coord_tmp, 'gps_coordinates.txt', files_dir );
	% disp('Press a key !');
	% pause;

end

slope_m = slope_m / image_num;
row_crop_width_m = row_crop_width_m / image_num;

gps_coord = gps_coord( 1:gps_coord_i, : );

% gps_coord = sortPath( gps_coord, slope_m );

% lon = gps_coord( :, 1 );
% lat = gps_coord( :, 2 );

% [ x, y, utmzone ] = deg2utm( lat, lon );

% number = str2num( utmzone( :, 1:2 ) );

% A = [ number, x, y ];
% C = cellstr( utmzone( :, 4 ) );
% D = [ C(:), num2cell( A ) ]';

% letter,number,East-West position,North-South position
% kml_file_name = 'View_kml_vin_utm_coords.txt';
% kml_file_name = strcat( files_dir, kml_file_name );
% fileID = fopen( kml_file_name,'w' );
% fprintf( fileID, '%s,%d,%6.2f,%7.2f\n', D{:} );
% fclose( fileID );
% fprintf('UTM for KML saved here: %s\n', kml_file_name);

% East-West position,North-South position
% utm_file_name = 'Vin_utm_coords.txt';
% utm_file_name = strcat( files_dir, utm_file_name );
% fileID = fopen( utm_file_name,'w' );
% fprintf( fileID, '%6.2f,%7.2f\n', [x, y]' );
% fclose( fileID );
% fprintf('UTM saved here: %s\n', utm_file_name);

% gps_file_name = 'Vin_gps_coords.txt';
% gps_file_name = strcat( files_dir, gps_file_name );
% dlmwrite( gps_file_name, gps_coord, 'precision', 16 );
% fprintf('GPS coords saved here: %s\n', gps_file_name);

%% save_gps_to_utm_file: function description
function [ utm ] = save_gps_to_utm_file( gps_coord, file_name, files_dir )

	lon = gps_coord( :, 1 );
	lat = gps_coord( :, 2 );

	[ x, y, utmzone ] = deg2utm( lat, lon );
	utm = [ x, y ];

	% East-West position,North-South position
	file_name = strcat( files_dir, file_name );
	fileID = fopen( file_name, 'w' );
	fprintf( fileID, '%6.2f,%7.2f\n', [x, y]' );
	fclose( fileID );
	fprintf('UTM saved here: %s\n', file_name);

end