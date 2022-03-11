function [points] = nPoints(fileName,n)

img = rgb2gray(imread(fileName));
edges = uint8(edge(img,"Sobel"))*255;

se = strel("disk",2);
dilated = imclose(edges,se);
filled = imfill(dilated,'holes');
perim = bwperim(filled);
pixelCount = length(find(perim~=0));
[row,col] = find(perim~=0);
traced = bwtraceboundary(perim,[row(end) col(end)],'N');
blank = zeros(size(img));
% placeholder point finder
points = traced(1:round(pixelCount/n):end,:);
for i=1:n
    blank(points(i,1),points(i,2)) = 1;
end
% try using angle tolerances
% find starting angle off of a point
% Create new point if outside of a specific angle tolerance
% Change angle tolerance until desired number of points is reached
% angle_tol = 90;
% while length(points)~= n
%     points = [row(end) col(end)];
%     current_angle = 0;
%     for i=1:length(traced)
%         current_angle = atan2d(points(end,1)-traced(i,1),points(end,2)-traced(end,1));
%         
%     end
%     len = length(points);
%     if len>n
%         angle_tol=angle_tol*2;
%     elseif len<n
%         angle_tol = angle_tol/2;
%     end
% end
imshow(imdilate(blank,se));
end

