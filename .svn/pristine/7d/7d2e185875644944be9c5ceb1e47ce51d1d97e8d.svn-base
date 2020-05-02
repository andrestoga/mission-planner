%% processRowCrops: 
function row_crops = processRowCrops( row_crops )

	[imageHeight imageWidth ~] = size( row_crops );

	row_crops = rgb2gray( row_crops );
	row_crops = imbinarize( row_crops );

	% img_filename = 'salt_and_pepper.png';
	% imwrite( row_crops, img_filename );
	% fprintf('File name written: %s\n', img_filename);
	% disp('Press a key !');
	% pause;
	
	% Get rid of small objects.
	smallestAcceptableArea = 50; % Keep areas only if they're bigger than this.
	row_crops = bwareaopen( row_crops, smallestAcceptableArea );

	row_crops = imfill( row_crops, 'holes' );

	structuringElement = strel( 'rectangle', [ 1, 20 ] );
	row_crops = imclose( row_crops, structuringElement );
	row_crops = imfill( row_crops, 'holes' );

	% img_filename = 'no_salt_and_pepper.png';
	% imwrite( row_crops, img_filename );
	% fprintf('File name written: %s\n', img_filename);
	% disp('Press a key !');
	% pause;

	CC = bwconncomp( row_crops );
	out_Image = regionprops( CC, 'Area', 'Extrema', 'BoundingBox' );

	% 	figure;
	% 	imshow( row_crops );
	% 	hold on;

	for i = 1:4
		ext_color = rand( i, 3 );
	end

	area_width = zeros( length( out_Image ), 2 );

	for i = 1:length( out_Image )

		% out_Image( i ).Area
		tmp_arr = out_Image( i ).Extrema;

				% Top left and top right
		% 		plot( tmp_arr( 1, 1 ), tmp_arr( 1, 2 ), 'Marker', '*', 'Color', ext_color( 1, : ) );
		% 		plot( tmp_arr( 2, 1 ), tmp_arr( 2, 2 ), 'Marker', '*', 'Color', ext_color( 1, : ) );
		% 		% Bottom right and bottom left
		% 		plot( tmp_arr( 5, 1 ), tmp_arr( 5, 2 ), 'Marker', '.', 'Color', ext_color( 3, : ) );
		% 		plot( tmp_arr( 6, 1 ), tmp_arr( 6, 2 ), 'Marker', '.', 'Color', ext_color( 3, : ) );
		% 		% Right top and right bottom. For Ransac.
		% 		plot( tmp_arr( 3, 1 ), tmp_arr( 3, 2 ), 'Marker', '+', 'Color', ext_color( 2, : ) );
		% 		plot( tmp_arr( 4, 1 ), tmp_arr( 4, 2 ), 'Marker', '+', 'Color', ext_color( 2, : ) );
		% 		% Left bottom and left top. For Ransac.
		% 		plot( tmp_arr( 7, 1 ), tmp_arr( 7, 2 ), 'Marker', 'x', 'Color', ext_color( 4, : ) );
		% 		plot( tmp_arr( 8, 1 ), tmp_arr( 8, 2 ), 'Marker', 'x', 'Color', ext_color( 4, : ) );

		top_left.x = tmp_arr( 1, 1 );
		top_left.y = tmp_arr( 1, 2 );
		top_right.x = tmp_arr( 2, 1 );
		top_right.y = tmp_arr( 2, 2 );

		right_top.x = tmp_arr( 3, 1 );
		right_top.y = tmp_arr( 3, 2 );
		right_bottom.x = tmp_arr( 4, 1 );
		right_bottom.y = tmp_arr( 4, 2 );

		left_bottom.x = tmp_arr( 7, 1 );
		left_bottom.y = tmp_arr( 7, 2 );
		left_top.x = tmp_arr( 8, 1 );
		left_top.y = tmp_arr( 8, 2 );

		bottom_right.x = tmp_arr( 5, 1 );
		bottom_right.y = tmp_arr( 5, 2 );
		bottom_left.x = tmp_arr( 6, 1 );
		bottom_left.y = tmp_arr( 6, 2 );

		% Measure their width. Save width and area.
		% TODO: Save the y coordinate for the top and bottom of the right and left width
		right_width = ( ( bottom_right.y + right_bottom.y ) / 2 ) - ( ( top_right.y + right_top.y ) / 2 );
		left_width = ( ( bottom_left.y + left_bottom.y ) / 2 ) - ( ( top_left.y + left_top.y ) / 2 );
		est_width = ( right_width + left_width ) / 2;

		area_width( i, 1 ) = est_width;
		area_width( i, 2 ) = out_Image( i ).Area;
	end

	% legend( 'top left', 'top right', 'right top', 'right bottom', 'bottom right', 'bottom left', 'left bottom', 'left top' );
	% set( gcf, 'Position', get( 0, 'ScreenSize' ) );

	% K-means with their width and area, two classes
	k = 2;
	[ idx, C ] = kmeans( area_width, k );

	% img_filename = 'noise_road_blobs.png';
	% imwrite( row_crops, img_filename );
	% fprintf('File name written: %s\n', img_filename);
	% waitforbuttonpress

	% [ M, I ] = min( area_width( :, 2 ) );
	[ M, I ] = max( area_width( :, 2 ) );
	label_del = idx( I( 1 ) );
	array_del = { length( area_width ) };
	j = 1;

	PixelIdxList = CC.PixelIdxList;

	for i = 1:length( area_width )
		if idx( i ) ~= label_del
			% array_del{ j } = PixelIdxList{ i };
			% j = j + 1;		
			row_crops( PixelIdxList{ i } ) = 0;
		end
	end

	% array_del = array_del( :, 1:j-1 );

	% img_filename = 'road_blobs.png';
	% imwrite( row_crops, img_filename );
	% fprintf('File name written: %s\n', img_filename);
	% disp('Press a key !');
	% pause;

end