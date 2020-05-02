%% computeEdgesInfo: function description
function [ slope, row_crop_width, space_betw_rows ] = computeEdgesInfo( row_crop_edges )

	slope = 0;
	row_crop_width = 0;
	space_betw_rows = intmax;

	for i = 1:length( row_crop_edges )

		top = row_crop_edges{ i, 1 };
		bot = row_crop_edges{ i, 2 };

		% Calculate slope
		slope = slope + ( ( top( end, 2 ) - top( 1, 2 ) ) / ( top( end, 1 ) - top( 1, 1 ) ) );
		slope = slope + ( ( bot( end, 2 ) - bot( 1, 2 ) ) / ( bot( end, 1 ) - bot( 1, 1 ) ) );

		% Calculate row crop width
		row_crop_width = row_crop_width + abs( bot( 1, 2 ) - top( 1, 2 ) );

		% Calculate the space between the crop rows
		if i < ( length( row_crop_edges ) - 1 )

			bot_i = row_crop_edges{ i, 2 };
			top_i_plus_1 = row_crop_edges{ i + 1, 1 };

			if abs( top_i_plus_1( 1, 2 ) - bot_i( 1, 2 ) ) < space_betw_rows
				space_betw_rows = abs( top_i_plus_1( 1, 2 ) - bot_i( 1, 2 ) );
			end
			
		end

	end

	slope = slope / ( length( row_crop_edges ) * 2 );
	row_crop_width = row_crop_width / length( row_crop_edges );

end