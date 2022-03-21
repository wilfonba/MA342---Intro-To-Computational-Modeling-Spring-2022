function [ds, thetas, normals] = OrientSurfaces(points, theta)
% Computes various values for a set of panels that approximate the 
% curve of a wing. Helper method for calculating circulation.
%
% OrientSurfaces(points) uses:
%
%   points: An n-by-2 matrix of points that define the wing.
%
% OrientSurfaces(points, theta) uses the same argument, and:
%
%   theta:  A scalar between zero and one that determines what convex cut 
%           to make. Default value is 0.5.
%
% [ds, thetas, normals] = OrientSurfaces(...) returns:
%
%   ds:         A column vector of ds
%   thetas:     A column vector of angles between the positive z axis and 
%               each panel.
%   normals:    The inward-facing normal vectors for each panel.
%

if nargin < 2
    theta = 0.5;
end

% Computes the vectors for each panel from the vector of points.
panels = points(1:end - 1, :) - points(2:end, :);

% Computes the inward-facing normal vectors for each panel.
prenormals = [-panels(:, 2) , panels(:, 1)];
normals = -1.*prenormals./vecnorm(prenormals, 2, 2);

% Computes angles to the z axis for each panel.
thetas = -sign(normals(:, 1)).*acos(-normals(:, 2));

% Computes d values for each panel.
ds = sqrt((points(2:end,1) - points(1:end-1,1)).^2 + (points(2:end,2) - points(1:end-1,2)).^2)*0.5;