%% getGPScoord_sub_map: function description
function [ gps_coord_tmp, slope_m, row_crop_width_m, left_pix ] = getGPScoord_sub_map(sub_map_file_name, sub_map_meta_file_name, sub_map_output_file_name, resolution, isLastImgCol, isFirstImgCol, pix_to_fill, files_dir )

	k = 3;
	I  = imread( sub_map_file_name );
	[imageHeight imageWidth ~] = size( I );
	real_meters = @( y ) ( 5 * y ) / 4;

	fileID = fopen( sub_map_meta_file_name, 'r' );
	formatSpec = '%f';
	sub_map_meta = fscanf( fileID, formatSpec );

	[ segmented_images, X, idx, C ] = getSeg_Images( I, k );

	top_left.longitude = sub_map_meta( 1 );
	top_left.latitute = sub_map_meta( 2 );
	meters_per_pixel = resolution;

	persistent trainData;
	persistent i_trained_img;
	persistent numb_train_img;
	persistent centroid;

	if isempty(trainData)
		trainData = [];
		i_trained_img = 1;
		numb_train_img = 5;
		centroid = [];
	end

	if i_trained_img > numb_train_img
		disp('Image chosen by training');
		dista = eucl_distance3D( centroid, C );
		[ M, x ] = min( dista );
		figure;
		imshow( segmented_images{ x } ), title( 'Image 3' );
		pause( 5 );
		close;
	else
		figure;
		subplot( 2, 2, 1 )
		imshow( I ), title( 'Original image' );
		% imwrite( I, 'original.png' );
		subplot( 2, 2, 2 )
		imshow( segmented_images{ 1 } ), title( 'Image 1' );
		% imwrite( segmented_images{ 1 }, 'cluster1.png' );
		subplot( 2, 2, 3 )
		imshow( segmented_images{ 2 } ), title( 'Image 2' );
		% imwrite( segmented_images{ 2 }, 'cluster2.png' );
		subplot( 2, 2, 4 )
		imshow( segmented_images{ 3 } ), title( 'Image 3' );
		% imwrite( segmented_images{ 3 }, 'cluster3.png' );
		set(gcf, 'Position', get(0, 'ScreenSize'));

		prompt = 'In which number of image are the roads? 1, 2 or 3?: ';
		x = input( prompt );
		close;

		tmp = getImgCluster( x, idx, X );
		trainData = [ trainData; tmp ];

		if i_trained_img == numb_train_img
			centroid = mean( trainData );
        %     figure;
        % plot3( centroid(1), centroid(2), centroid(3), 'marker','x','color','k',...
        % 'markersize',30,'linewidth',10 );
		else
        % figure;
		end

		% scatter3( trainData( :, 1 ), trainData( :, 2 ), trainData( :, 3 ) );
		% disp('Check the train data !');
		% msj = sprintf('Train data number: %d\n', i_trained_img);
		% disp(msj);
		% close;

		i_trained_img = i_trained_img + 1;

	end

	raw_row_crops = segmented_images{ x };
	% imwrite( row_crops, sub_map_output_file_name );
	% fprintf('File name written: %s\n', sub_map_output_file_name);

	proc_row_crops = processRowCrops( raw_row_crops );

	% figure;
	% subplot( 2, 2, 1 )
	% imshow( I ), title( 'Original image' );
	% subplot( 2, 2, 2 )
	% imshow( raw_row_crops ), title( 'Segmented row crops' );
	% subplot( 2, 2, 3 )
	% imshow( proc_row_crops ), title( 'Processed row crops' );
	% set(gcf, 'Position', get(0, 'ScreenSize'));

	row_crop_edges = getRowCropEdges( proc_row_crops );

	% Add an extra column
	for i = 1:length( row_crop_edges )

		top = row_crop_edges{ i, 1 };
		row_crop_edges{ i, 3 } = top( 1, 2 );

	end	

	% Sort rows by that extra column in descending order
	row_crop_edges = sortrows( row_crop_edges, 3 );

	row_crop_edges = row_crop_edges( :, 1:2 );

	[ slope_pix, row_crop_width_pix, space_betw_rows ] = computeEdgesInfo( row_crop_edges )

    % figure;
	% imshow( I );
	% hold on

	% for i = 1:length( row_crop_edges )

	% 	top = row_crop_edges{ i, 1 };
	% 	bot = row_crop_edges{ i, 2 };

	% 	plot( top( :, 1 ), top( :, 2 ), 'r' );
	% 	plot( bot( :, 1 ), bot( :, 2 ), 'b' );

	% end

	% hold off;

	% Add missing crop rows
	row_crop_edges = correctRowCropEdges( row_crop_edges, slope_pix, row_crop_width_pix, space_betw_rows, imageWidth );

	save_file_crop_row_meta( row_crop_edges, top_left, slope_pix, files_dir );

	spaced_mts = real_meters( 10 );

	slope_m = slope_pix * meters_per_pixel;
	row_crop_width_m = row_crop_width_pix * meters_per_pixel;

    % h = figure;
    % set(h, 'Visible', 'off');
    % imshow( I );
    % hold on

	% for i = 1:length( row_crop_edges )

	% 	top = row_crop_edges{ i, 1 };
	% 	bot = row_crop_edges{ i, 2 };

	% 	plot( top( :, 1 ), top( :, 2 ), 'r' );
	% 	plot( bot( :, 1 ), bot( :, 2 ), 'b' );

	% end

	% hold off;
	% img_filename = 'straight_line_edges.png';
	% saveas( h, img_filename )
	% fprintf('Output image written here: %s\n', img_filename);

	[ robot_path_pix, robot_path_gps, left_pix ] = computeRobotPath( row_crop_edges, top_left, spaced_mts, slope_pix, meters_per_pixel, imageWidth, isLastImgCol, isFirstImgCol, pix_to_fill );

	h = figure;
	set(h, 'Visible', 'off');
	imshow( I );
	hold on

	for i = 1:length( row_crop_edges )

		top = row_crop_edges{ i, 1 };
		bot = row_crop_edges{ i, 2 };

		plot( top( :, 1 ), top( :, 2 ), 'r' );
		plot( bot( :, 1 ), bot( :, 2 ), 'b' );

	end

	plot( robot_path_pix( :, 1 ), robot_path_pix( :, 2 ), 's',...
		'MarkerSize',10,...
		'MarkerEdgeColor','y',...
		'MarkerFaceColor','y' );

	hold off;
	saveas( h, sub_map_output_file_name )
	fprintf('Output image written here: %s\n', sub_map_output_file_name);
	% dlmwrite( 'Husky_coords_algorithm.txt', robot_path_gps, 'precision', 16 );
	% fprintf('GPS coords saved here: %s\n', sub_map_output_file_name);

	gps_coord_tmp = robot_path_gps;
end

%% getImgCluster: function description
function [outputs] = getImgCluster( x, idx, X )

	outputs = zeros( length( idx ), 3 );
	counter = 1;

	for i = 1:length( idx )
		if idx( i ) == x
			outputs( counter, : ) = X( i, : );
			counter = counter + 1;
		end
	end

	counter = counter - 1;
	outputs = outputs( 1:counter, : );

end

%% eucl_distance: function description
function [ dista ] = eucl_distance3D( point, points )

	dista = sqrt( sum( ( points - point ).^2, 2 ) );

end

%% save_file_crop_row_meta: function description
function save_file_crop_row_meta(row_crop_edges, top_left_gps, slope_pix, files_dir)

	persistent num_image;

	if isempty(num_image)
		num_image = 1;
	end

	to_file = zeros( length( row_crop_edges ) + 2, 1 );

	to_file( 1, 1 ) = top_left_gps.longitude;
	to_file( 2, 1 ) = top_left_gps.latitute;
	to_file( 3, 1 ) = slope_pix;

	counter = 4;

	for i = 1:length( row_crop_edges )

		top = row_crop_edges{ i, 1 };
		to_file( counter, 1 ) = floor( abs( top( 1, 2 ) ) );
		counter = counter + 1;

	end

	filename = sprintf( '%s%s%d%s', files_dir, 'crop_row_metadata_', num_image, '.txt' );
	dlmwrite( filename, to_file, 'precision', 16 );
	num_image = num_image + 1;
	fprintf('Metada save here: %s\n', filename);
end