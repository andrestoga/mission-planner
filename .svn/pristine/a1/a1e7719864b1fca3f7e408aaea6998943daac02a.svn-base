close all;
clc;
clear;
clear getGPScoord_sub_map;

% Read meta
% files_dir = 'TestingImgs/First_half/';
files_dir = '';
filename = strcat( files_dir, 'maps_meta.txt' );
disp(filename);
% pause;
fileID = fopen( filename, 'r' );
formatSpec = '%f';
sub_map_meta = fscanf( fileID, formatSpec );

n_images = sub_map_meta( 1 );
img_col = sub_map_meta( 2 );
img_row = sub_map_meta( 3 );
image_width = sub_map_meta( 4 );
m_pix = sub_map_meta( 6 );

top_left.lon = sub_map_meta( 8 );
top_left.lat = sub_map_meta( 9 );

top_right.lon = sub_map_meta( 10 );
top_right.lat = sub_map_meta( 11 );

bot_left.lon = sub_map_meta( 12 );
bot_left.lat = sub_map_meta( 13 );

bot_right.lon = sub_map_meta( 14 );
bot_right.lat = sub_map_meta( 15 );

real_meters = @( y ) ( 5 * y ) / 4;

% Parameters to tune
spaced_mts = real_meters( 10.0 );
shift_down_mts = real_meters( 1.0 );
left_outside_mts = real_meters( -6.0 );
right_outside_mts = real_meters( 4.0 );
vineyard_width_mts = real_meters( 395.0 );

spaced_pix = ceil( spaced_mts / m_pix );

image_name = 'sub_map_';
roads_name = 'crop_row_metadata_';
image_ext = '.png';
meta_ext = '.txt';

robot_path_pix = [];
robot_path_gps = [];

tmp_path_pix = zeros( image_width, 2 );
tmp_path_gps = zeros( image_width, 2 );

left_pix = 1;


for i = 1:n_images

	fileName_crop = sprintf( '%s%s%d%s', files_dir, roads_name, i, meta_ext );
	disp(fileName_crop);
	% pause;
	% msj = strcat( 'Procesing image: ', fileName_map );
	% disp( msj );

	fileID = fopen( fileName_crop, 'r' );
	formatSpec = '%f';
	sub_map_meta = fscanf( fileID, formatSpec );

	lon = sub_map_meta( 1 );
	lat = sub_map_meta( 2 );
	slope = sub_map_meta( 3 );

	map_gps_coord.longitude = lon;
	map_gps_coord.latitute = lat;

	i_robot_path = 1;

	col = mod( i, img_col );

	x_pos = [];

	% First col
	if col == 1
		i_pix = 1;

		right_outside_x = ceil( left_outside_mts / m_pix );
		x_pos = [ x_pos; right_outside_x ];

	else
		i_pix = left_pix;
	end

	% Last col
	if col == 0
		remain_pix = ( image_width * ( img_col - 1 ) ) + i_pix;
		vineyard_width_pix = ceil( vineyard_width_mts / m_pix );
		val = vineyard_width_pix - remain_pix;
	else
		val = image_width;
	end

	while left_pix > 0
		x_pos = [ x_pos; i_pix ];
		i_pix = i_pix + spaced_pix;
		% left_pix = image_width - i_pix;
		left_pix = val - i_pix;
	end

	% Plus 4 meters
	if col == 0
		right_outside_pix = ceil( right_outside_mts / m_pix );
		x_pos = [ x_pos; val + right_outside_pix ];
	end

	left_pix = abs( left_pix );

	for j = 4:length( sub_map_meta )

		b = sub_map_meta( j );

		shift_down_pix = -ceil( shift_down_mts / m_pix );

		b = b - shift_down_pix;

		for k = 1:length( x_pos )

			tmp_path_pix( i_robot_path, 1 ) = x_pos( k );
			tmp_path_pix( i_robot_path, 2 ) = ceil( abs( slope * x_pos( k ) + b ) );

			[ lon, lat ] = getGPScoord( tmp_path_pix( i_robot_path, 1 ), tmp_path_pix( i_robot_path, 2 ), map_gps_coord, m_pix );

			tmp_path_gps( i_robot_path, 1 ) = lon;
			tmp_path_gps( i_robot_path, 2 ) = lat;

			i_robot_path = i_robot_path + 1;

		end

		% while left_pix > 0

		% 	tmp_path_pix( i_robot_path, 1 ) = i_pix;
		% 	tmp_path_pix( i_robot_path, 2 ) = ceil( abs( slope * i_pix + b ) );

		% 	[ lon, lat ] = getGPScoord( tmp_path_pix( i_robot_path, 1 ), tmp_path_pix( i_robot_path, 2 ), map_gps_coord, m_pix );

		% 	tmp_path_gps( i_robot_path, 1 ) = lon;
		% 	tmp_path_gps( i_robot_path, 2 ) = lat;

		% 	i_pix = i_pix + spaced_pix;
		% 	i_robot_path = i_robot_path + 1;

		% 	left_pix = image_width - i_pix;

		% end

	end

	% Plot image
	tmp_path_pix = tmp_path_pix( 1:( i_robot_path - 1 ), : );
	tmp_path_gps = tmp_path_gps( 1:( i_robot_path - 1 ), : );

	% robot_path_pix = [ robot_path_pix; tmp_path_pix ];
	robot_path_gps = [ robot_path_gps; tmp_path_gps ];

	fileName = sprintf( '%s%s%d%s', files_dir, image_name, i, image_ext );
	disp(fileName);

	% I  = imread( fileName );

	% figure;
	% imshow( I );
	% hold on

	% plot( tmp_path_pix( :, 1 ), tmp_path_pix( :, 2 ), 's',...
	% 	'MarkerSize',10,...
	% 	'MarkerEdgeColor','y',...
	% 	'MarkerFaceColor','y' );

	% hold off;

	% pause(2);
	% close;

end

gps_file_name = 'vin_gps_coords.txt';
gps_file_name = strcat( files_dir, gps_file_name );
dlmwrite( gps_file_name, robot_path_gps, 'precision', 16 );
fprintf('GPS coords saved here: %s\n', gps_file_name);

% lon = robot_path_gps( :, 1 );
% lat = robot_path_gps( :, 2 );

% [ x, y, utmzone ] = deg2utm( lat, lon );

% utm_file_name = 'vin_utm_coords.txt';
% utm_file_name = strcat( files_dir, utm_file_name );
% fileID = fopen( utm_file_name,'w' );
% fprintf( fileID, '%6.2f,%7.2f\n', [x, y]' );
% fclose( fileID );
% fprintf('UTM saved here: %s\n', utm_file_name);