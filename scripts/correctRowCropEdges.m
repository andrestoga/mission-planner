%% correctRowCropEdges: With the above info, recalculate the edges of the crop rows and add the missing crop rows.
function [new_row_crop_edges] = correctRowCropEdges( row_crop_edges, slope, row_crop_width, space_betw_rows, imageWidth )

	% new_row_crop_edges = cell( length( row_crop_edges ), 2 );
	% m = slope;
	% line_length = length( row_crop_edges{ 1, 1 } );

	% Correct the existent crop rows using only the slope
	% for i = 1:length( row_crop_edges )

	% 	% 1 = x, 2 = y
	% 	top = row_crop_edges{ i, 1 };
	% 	bot = row_crop_edges{ i, 2 };

	% 	b = top( 1, 2 );
	% 	new_row_crop_edges{ i, 1 } = calculateLine( b, m, line_length );

	% 	b = bot( 1, 2 );
	% 	new_row_crop_edges{ i, 2 } = calculateLine( b, m, line_length );

	% end

	% TODO: Plot the row crop edges corrected and the original ones to see if there are any better the corrected ones.

	% TODO: Add the missing row crops
	new_row_crop_edges = computeParallelLines( row_crop_edges, slope, row_crop_width, space_betw_rows, imageWidth, 'up' );
	new_row_crop_edges = computeParallelLines( new_row_crop_edges, slope, row_crop_width, space_betw_rows, imageWidth, 'middle' );
	new_row_crop_edges = computeParallelLines( new_row_crop_edges, slope, row_crop_width, space_betw_rows, imageWidth, 'down' );

	% row_crop_edges = ;
end

%% computeParallelLines: function description
function [lines] = computeParallelLines( lines, slope, line_width, space_betw_lines, imageWidth, direction )

	new_lines = cell( 100, 2 );

	if strcmp( direction, 'up' ) || strcmp( direction, 'down' )

		new_line_i = 0;

		if strcmp( direction, 'up' )

			% Bot edge
			Line = lines{ 1, 2 };
			line_width = -line_width;
			space_betw_lines = -space_betw_lines;

		else
			% Top edge
			Line = lines{ end, 1 };

		end

		y_i = Line( 1, 2 );
		y_i = y_i + space_betw_lines + line_width;

		while( y_i > 0 && y_i <= imageWidth )

			new_line_i = new_line_i + 1;

			if strcmp( direction, 'up' )

				% Calculating bot edge
				new_lines{ new_line_i, 2 } = calculateLine( slope, y_i, imageWidth );

				other_y_i = y_i + line_width;

				% Calculating top edge
				new_lines{ new_line_i, 1 } = calculateLine( slope, other_y_i, imageWidth );

			else

				% Calculating top edge
				new_lines{ new_line_i, 1 } = calculateLine( slope, y_i, imageWidth );

				other_y_i = y_i + line_width;

				% Calculating bot edge
				new_lines{ new_line_i, 2 } = calculateLine( slope, other_y_i, imageWidth );

			end

			y_i = y_i + space_betw_lines + line_width;

		end

		new_lines = new_lines( 1:new_line_i, : );

		if strcmp( direction, 'up' )

			new_lines = flipud( new_lines );
			lines = [ new_lines; lines ];

		else

			lines = [ lines; new_lines ];

		end

	elseif strcmp( direction, 'middle' )

		if line_width > space_betw_lines
			biggest = line_width;
			lowest = space_betw_lines;
		else
			biggest = space_betw_lines;
			lowest = line_width;
		end

		lines_i = 1;
		num_lines = length( lines );

		while( lines_i < ( num_lines - 1 ) )

			Line = lines{ lines_i, 1 };
			y_i = Line( 1, 2 );

			y_i = y_i + space_betw_lines + line_width;

			n_line = lines{ lines_i + 1, 1 };
			n_y_i = n_line( 1, 2 );

			if abs( y_i - n_y_i ) > ( biggest + lowest / 2 )

				% Calculating top edge
				top = calculateLine( slope, y_i, imageWidth );

				other_y_i = y_i + line_width;

				% Calculating bot edge
				bot = calculateLine( slope, other_y_i, imageWidth );

				lines = insertCell( lines, { top; bot }, lines_i + 1 );
                
                num_lines = length( lines );

			end

			lines_i = lines_i + 1;

		end

	else
		disp('Error');
	end
end

%% insertCell: function description
function [ a ] = insertCell( a, b, row_no )
	a( 1 : row_no - 1, : ) = a( 1 : row_no - 1, : ); 
	tp = a( row_no : end, : );
	a( row_no, : ) = b;
	a( row_no + 1 : end + 1, : ) = tp;
end

%% calculateLine: function description
function [ line_2d ] = calculateLine( m, b, line_length )

	line_2d = zeros( line_length, 2 );

	for i = 1:line_length

		x = i;
		y = m * i + b;

		if y < 1 || y > line_length

			x = -1;
			y = -1;

			line_2d( i, 1 ) = x;
			line_2d( i, 2 ) = y;

			break;
		end

		line_2d( i, 1 ) = x;
		line_2d( i, 2 ) = y;

	end

end