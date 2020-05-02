%% getMercatorFromGPS: function description
function [x, y] = getMercatorFromGPS(lng, lat)
	x = 6371000 * lng;
	y = 6371000 * log(tan(pi/4 + lat/2));
end