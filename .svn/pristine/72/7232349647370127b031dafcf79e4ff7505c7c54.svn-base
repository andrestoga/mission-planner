% sSpaced the points by 40-50 meters. Right now the units are pixels
%% computeRobotPath: function description
function [ robot_path_pix, robot_path_gps, left_pix ] = computeRobotPath( row_crop_edges, map_gps_coord, spaced_mts, slope_pix, meters_per_pixel, image_width_pix, isLastImgCol, isFirstImgCol, pix_to_fill )

	robot_path_pix = zeros( image_width_pix, 2 );
	robot_path_gps = zeros( image_width_pix, 2 );
	real_meters = @( y ) ( 5 * y ) / 4;
	i_robot_path = 1;
	j = 1;
	spaced_pix = ceil( spaced_mts / meters_per_pixel );

	% Connect different row points for navigation when you are computing the path
	% 	beginning row 10 meters to the left
	% 	ending row 50 meters to the right
	% shift the points down by one meter when you are computing the path

	shift_down_mts = real_meters( 1.0 );
	left_outside_mts = real_meters( -6.0 );
	right_outside_mts = real_meters( 4.0 );

	shift_down_pix = -ceil( shift_down_mts / meters_per_pixel );

	for i = 1:length( row_crop_edges )

		top = row_crop_edges{ i, 1 };
		bot = row_crop_edges{ i, 2 };

		if isFirstImgCol
			b_middle = top( 1, 2 ) - shift_down_pix;
			right_outside_x = ceil( left_outside_mts / meters_per_pixel );
			right_outside_y = slope_pix * right_outside_x + b_middle;
			[ lon, lat ] = getGPScoord( right_outside_x, right_outside_y, map_gps_coord, meters_per_pixel );
			robot_path_gps( i_robot_path, 1 ) = lon;
			robot_path_gps( i_robot_path, 2 ) = lat;
			i_robot_path = i_robot_path + 1;
			left_outside_mts = 10.0;
			right_outside_x = ceil( left_outside_mts / meters_per_pixel );
			j = spaced_pix - right_outside_x;
		else
			j = 1 + ( 1 * pix_to_fill );
		end

		left_pix = image_width_pix - j;

		while left_pix > 0

			robot_path_pix( i_robot_path, 1 ) = j;
			% robot_path_pix( i_robot_path, 2 ) = round( ( top( j, 2 ) + bot( j, 2 ) ) / 2 );
			robot_path_pix( i_robot_path, 2 ) = top( j, 2 ) - shift_down_pix;
			[ lon, lat ] = getGPScoord( robot_path_pix( i_robot_path, 1 ), robot_path_pix( i_robot_path, 2 ), map_gps_coord, meters_per_pixel );
			robot_path_gps( i_robot_path, 1 ) = lon;
			robot_path_gps( i_robot_path, 2 ) = lat;
			j = j + spaced_pix;
			i_robot_path = i_robot_path + 1;

			left_pix = image_width_pix - j;

		end

		if isLastImgCol

			spaced_out_pix = ceil( right_outside_mts / meters_per_pixel );
			j = j - spaced_pix + spaced_out_pix;
			b_middle = top( 1, 2 ) - shift_down_pix;

			for i = 1:2
				right_outside_x = j;
				right_outside_y = slope_pix * right_outside_x + b_middle;
				[ lon, lat ] = getGPScoord( right_outside_x, right_outside_y, map_gps_coord, meters_per_pixel );
				robot_path_gps( i_robot_path, 1 ) = lon;
				robot_path_gps( i_robot_path, 2 ) = lat;
				i_robot_path = i_robot_path + 1;
				j = j + spaced_out_pix;
			end
			
		end

	end

	robot_path_pix = robot_path_pix( 1:( i_robot_path - 1 ), : );
	robot_path_gps = robot_path_gps( 1:( i_robot_path - 1 ), : );
	left_pix = abs( left_pix );
end