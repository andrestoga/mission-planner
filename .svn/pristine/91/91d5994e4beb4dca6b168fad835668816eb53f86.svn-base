%% getSeg_Images: function description
function [ seg_images, X, idx, C ] = getSeg_Images( img, k )

	[imageHeight imageWidth ~] = size( img );

	% ***Using k-means in RGB space
	r = img( :, :, 1 );
	g = img( :, :, 2 );
	b = img( :, :, 3 );

	m = r( : );
	n = g( : );
	o = b( : );

	X = [ m, n, o ];
	X = double( X( :, : ) );
	[ idx, C ] = kmeans( X, k );



 %    color = zeros( numel( idx ), 3 );
 %    for i = 1:numel( idx )
 %       switch idx( i )
 %           case 1
 %                color( i, : ) = [ 1 0 0 ];
 %           case 2
 %                color( i, : ) = [ 0 1 0 ];
 %           case 3
 %                color( i, : ) = [ 0 0 1 ];
 %       end
 %    end
    
 %    figure;
 %    scatter3( m, n, o, 5, color );
 %    disp('Press a key !');
	% pause;
        
	% ***Using k-means in RGB space

	% ***Using k-means in lab space

	% lab_he = rgb2lab( img );
	% ab = lab_he(:,:,2:3);
	% nrows = size(ab,1);
	% ncols = size(ab,2);
	% ab = reshape(ab,nrows*ncols,2);

	% nColors = 3;
	% repeat the clustering 3 times to avoid local minima
	% [idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', 'Replicates',3);

	% ***Using k-means in lab space

	pixel_labels = reshape( idx, imageHeight, imageWidth );

	% figure;
	% imshow( pixel_labels, [] ), title( 'image labeled by cluster index' );

	seg_images = cell( 1, k );
	rgb_label = repmat( pixel_labels, [1 1 k] );

	for i = 1:k
		color = img;
		color( rgb_label ~= i ) = 0;
		seg_images{ i } = color;
	end

end