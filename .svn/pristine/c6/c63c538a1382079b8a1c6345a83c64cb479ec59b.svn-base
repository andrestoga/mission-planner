%% getGPSFromMercator: function description
function [lng, lat] = getGPSFromMercator(x, y)
	lng = x/6371000;
	lat = 2*atan(exp(y/6371000)) - pi/2;
end