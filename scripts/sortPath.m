%% sortPath: function description
function [ points_sorted, points_sorted_by_row ] = sortPath( ref_gps_pnt, gps_coord )
% function [ points_sorted, points_sorted_by_row ] = sortPath( ref_gps_pnt, gps_coord, slope_m, row_width_m )

	gps_coord = sortrows( gps_coord, 2, 'descend' );
	% gps_coord_rad = deg2rad( gps_coord );
	% [x, y] = getMercatorFromGPS( gps_coord_rad( :, 1 ), gps_coord_rad( :, 2 ) );

	% gps_coord_merca = [ gps_coord, x, y ];

	% gps_coord_distances = computeDistances( ref_gps_pnt, gps_coord_merca );
	distances = computeDistances( ref_gps_pnt, gps_coord );

	diff_dis = diff( distances( :, 1 ) );

	% gps_coord_distances = [ gps_coord_distances, [ diff_dis; 0 ] ];
	gps_coord_distances = [ gps_coord, [ diff_dis; 0 ] ];

	threshold = 100.0;
	n_col = 3;
	[ points_sorted, points_sorted_by_row ] = sortDiff( gps_coord_distances, n_col, threshold );

	% [m, ~] = size( gps_coord_distances );
	% closePoints = [];

	% while m ~= 0

	% 	[ M, I ] = min( gps_coord_distances );

	% 	lon = gps_coord_distances( I( 3 ), 1 );
	% 	lat = gps_coord_distances( I( 3 ), 2 );

	% 	[ gps_coord_distances, tmpClosePoints ] = findClosePoints( [ lon, lat ], gps_coord_distances, slope_m, row_width_m );
	% 	closePoints = [ closePoints; tmpClosePoints ];
	% 	[m, ~] = size( gps_coord_distances );

	% end

end

%% computeDistances: function description
function [ distances ] = computeDistances( point, points )

	[ m, ~ ] = size( points );
	distances = zeros( m, 1 );

	for i = 1:m
		tmpDistance = getDistanceFromLatLonInM( point( 1 ), point( 2 ), points( i, 1 ), points( i, 2 ) );
		% points( i, 5 ) = tmpDistance;
		distances( i, 1 ) = tmpDistance;
	end
end

%% findClosePoints: function description
% function [ points, closePoints ] = findClosePoints( point, points, slope_m, row_width_m )
	
% 	closePoints = [];

% 	x = point( 1 );
% 	y = point( 2 );
% 	m = slope_m;

% 	b_up = y - m * x + row_width_m / 2;
% 	b_down = y - m * x - row_width_m / 2;

% 	for i = 1:length( points )

% 		x = points( i, 1 );
% 		y = points( i, 2 );

% 		% Calculate the upper limit
% 		y_up = m * x + b_up;

% 		% Calculate the lower limit
% 		y_down = m * x + b_down;

% 		if y <= y_up && y >= y_down
			
% 			closePoints = [ closePoints; [ x, y ] ];
% 			[ points, ~ ] = removerows( points, 'ind', [ i ] );

% 		end

% 	end

% end

%% sortDiff: function description
function [points_sorted, points_sorted_by_row] = sortDiff( points, n_col, threshold )

	points_l = length( points );
	points_sorted = [];
	points_sorted_tmp = [];
	points_sorted_by_row = {};
	vin_i = 1;
	est_num_pnt_per_row = 100;

	% reshape
	for i = 1:points_l
		if points( i, n_col ) > threshold
			points_sorted_tmp = [ points_sorted_tmp; points( i, : ) ];
			points_sorted_tmp = sortrows( points_sorted_tmp, 1 );

			points_sorted = [ points_sorted; points_sorted_tmp ];
			points_sorted_by_row = [ points_sorted_by_row; cell( 1, est_num_pnt_per_row )];
			[ m, ~ ] = size( points_sorted_tmp );

			for i = 1:m
				points_sorted_by_row{ vin_i, i } = points_sorted_tmp( i, 1:2 );
			end

			vin_i = vin_i + 1;

			points_sorted_tmp = [];
		else
			points_sorted_tmp = [ points_sorted_tmp; points( i, : ) ];
		end
	end

	points_sorted_tmp = [ points_sorted_tmp; points( points_l, : ) ];
	points_sorted_tmp = sortrows( points_sorted_tmp, 1 );

	points_sorted = [ points_sorted; points_sorted_tmp ];
	points_sorted_by_row = [ points_sorted_by_row; cell( 1, est_num_pnt_per_row ) ];

	[ m, ~ ] = size( points_sorted_tmp );

	for i = 1:m
		points_sorted_by_row{ vin_i, i } = points_sorted_tmp( i, 1:2 );
	end
end

%% getDistanceFromLatLonInM: function description
function [tmpDistance] = getDistanceFromLatLonInM( lon1, lat1, lon2, lat2 )
  R = 6371000; % Radius of the earth in meters
  dLat = deg2rad(lat2-lat1);  % deg2rad below
  dLon = deg2rad(lon2-lon1); 
  a = sin(dLat/2) .* sin(dLat/2) + cos(deg2rad(lat1)) .* cos(deg2rad(lat2)) .* sin(dLon/2) .* sin(dLon/2); 
  c = 2 * atan2(sqrt(a), sqrt(1-a)); 
  tmpDistance = R * c; % Distance in km
end

%% deg2rad: function description
function [rad] = deg2rad(deg)
	rad = deg * (pi/180);
end