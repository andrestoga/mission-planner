%% getRowCropEdges: function description
function [ row_crop_edges ] = getRowCropEdges( row_crops )

	[imageHeight imageWidth ~] = size( row_crops );

	[ B, L ] = bwboundaries( row_crops, 'noholes' );
	L( :, : ) = 0;

	% figure;
	% imshow(L);
	% hold on

	% for k = 1:length(B)
	% 	boundary = B{k};
	% 	plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
	% end

	% hold off;

	blob_edges = cell( length( B ), 2 );

	for k = 1:length( B )
		blob_boundary = B{ k };
		map = sort_bnd( blob_boundary );

		topEdge = getEdge( map, imageWidth, 0 );
		bottomEdge = getEdge( map, imageWidth, 1 );

		% figure;
		% imshow(L);
		% hold on

		% plot([ topEdge( :, 1 ); NaN; bottomEdge( :, 1 ) ] , [ topEdge( :, 2 ); NaN; bottomEdge( :, 2 ) ], 'gs', 'LineWidth',1,...
		% 	'MarkerSize',1,...
		% 	'MarkerEdgeColor','b',...
		% 	'MarkerFaceColor',[0.5,0.5,0.5]);

		% hold off;

		blob_edges{ k, 1 } = topEdge;
		blob_edges{ k, 2 } = bottomEdge;
	end

	row_crop_edges_info = cell( length( blob_edges ), 2 );

	% figure;
	% imshow(L);
	% hold on

	for k = 1:length(blob_edges)

		topEdge = blob_edges{ k, 1 };
		bottomEdge = blob_edges{ k, 2 };

		% plot([ topEdge( :, 1 ); NaN; bottomEdge( :, 1 ) ] , [ topEdge( :, 2 ); NaN; bottomEdge( :, 2 ) ], 'gs', 'LineWidth',1,...
		% 	'MarkerSize',1,...
		% 	'MarkerEdgeColor','b',...
		% 	'MarkerFaceColor',[0.5,0.5,0.5]);

		iterNum = 100;
		thDist = 3;
		thInlrRatio = .1;
		[t_top,r_top] = ransac( topEdge', iterNum, thDist, thInlrRatio );
		[t_bot,r_bot] = ransac( bottomEdge', iterNum,thDist, thInlrRatio );

		k1 = -tan(t_top);
		b1 = r_top/cos(t_top);
		tmp = [ topEdge( :, 1 ), k1 * topEdge( :, 1 ) + b1 ];
		row_crop_edges_info{ k, 1 } = tmp;
		% plot( tmp( :, 1 ), tmp( :, 2 ), 'r' );

		k1 = -tan(t_bot);
		b1 = r_bot/cos(t_bot);
		tmp =  [ bottomEdge( :, 1 ), k1 * bottomEdge( :, 1 ) + b1 ];
		row_crop_edges_info{ k, 2 } = tmp;
		% plot( tmp( :, 1 ), tmp( :, 2 ), 'g' );

	end

	row_crop_edges = getLinesInfo( row_crop_edges_info, imageWidth );

	% figure;
	% imshow(orig_row_crops);
	% hold on

	% for i = 1:length( new_edges )

	% 	top = new_edges{ i, 1 };
	% 	bot = new_edges{ i, 2 };

	% 	plot( top( :, 1 ), top( :, 2 ), 'r' );
	% 	plot( bot( :, 1 ), bot( :, 2 ), 'b' );

	% end

end

%% getLinesInfo: function description
function [ new_edges ] = getLinesInfo( row_crop_edges, imageWidth )

	new_edges = cell( length(row_crop_edges), 2 );

	for i = 1:length(row_crop_edges)
		new_edges{ i, 1 } = getLine( row_crop_edges{ i, 1 }, imageWidth );
		new_edges{ i, 2 } = getLine( row_crop_edges{ i, 2 }, imageWidth );
	end
end

%% getLine: function description
function [ line2d ] = getLine( samples, x_width )
	
	parameter1 = ( samples( length( samples ), 2 ) - samples( 1, 2 ) ) / ( samples( length( samples ), 1 ) - samples( 1, 1 ) );
	parameter2 = samples( 1, 2 ) - parameter1 * samples( 1, 1 );
	xAxis = 1:x_width;
	yAxis = parameter1*xAxis + parameter2;
	line2d = [ xAxis', yAxis' ];

end

%% getEdge: edge_type = 0 is top and 1 is botton
function [crop_edge] = getEdge(map, imageWidth, edge_type)

	crop_edge = zeros( imageWidth, 2 );

	j = 1;
	
	for i = 1:imageWidth

		if isKey( map, i )

			pix_col_val = map( i );
			y = 0;

			if edge_type == 0
				y = min( cell2mat( [ pix_col_val{ : } ]' ) );
			else
				y = max( cell2mat( [ pix_col_val{ : } ]' ) );
			end

			crop_edge( j, 1 ) = i;
			crop_edge( j, 2 ) = y;
			j = j + 1;
		end

	end

	crop_edge = crop_edge( 1:(j - 1), : );

end

%% sort_bnd: 
function [map] = sort_bnd(blob_boundary)

	num_pix = length( blob_boundary );

	value = blob_boundary( 1, 1 );
	key = blob_boundary( 1, 2 );
	map = containers.Map( key, { { value } } );

	for i = 2:num_pix

		value = blob_boundary( i, 1 );
		key = blob_boundary( i, 2 );

		if isKey( map, key )

			addValToMap( map, key, value );
			tmp = values(map);

		else
			map( key ) = { { value } };
		end

		tmp = values(map);

	end

end

%% addValToMap: 
function [ map ] = addValToMap( map, key, val )
	tmp = map( key );
	tmp = [ tmp( : ); { { val } } ];
	map( key ) = tmp;
end