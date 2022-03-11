function [points] = nPoints(fileName,n,wake_angle,wake_len)

img = rgb2gray(imread(fileName));
edges = uint8(edge(img,"Sobel"))*255;

se = strel("disk",2);
dilated = imclose(edges,se);
filled = imfill(dilated,'holes');
perim = bwperim(filled);
pixelCount = length(find(perim~=0));
[row,col] = find(perim~=0);
traced = bwtraceboundary(perim,[row(end) col(end)],'N');

% placeholder point finder
points = traced(1:round(pixelCount/n):end,:);
points(end+1,:) = points(1,:);
points(end+1,:) = [ ...
        round(points(end,1)+sind(wake_angle)*wake_len) ...
        round(points(end,2)+cosd(wake_angle)*wake_len) ...
];
blank = zeros(size(img)*2);
for i=1:length(points)
    blank(points(i,1),points(i,2)) = 1;
end
% try using angle tolerances
% find starting angle off of a point
% Create new point if outside of a specific angle tolerance
% Change angle tolerance until desired number of points is reached
% angle_tol = 180;
% angle_range = 180;
% while length(points)~= n
%     points = [row(end) col(end)];
%     test_angle = atan2d(points(end,1)-traced(5,1),points(end,2)-traced(5,1));
%     for i=1:length(traced)
%         current_angle = atan2d(points(end,1)-traced(i,1),points(end,2)-traced(i,2));
%         if abs(test_angle-current_angle) > angle_tol
%            points(end+1,:) = [traced(i,1) traced(i,2)];
%            added=i+10;
%            if added>length(traced)
%               added = length(traced); 
%            end
%            test_angle = atan2d(points(end,1)-traced(added,1),points(end,2)-traced(added,1));
%         end
%     end
%     [len,~] = size(points);
%     disp(points);
%     fprintf("points: %d angle_tol: %d angle_range: %d\n",len,angle_tol,angle_range);
%     blank = zeros(size(img));
%     for k=1:len
%         blank(points(k,1),points(k,2)) = 1;
%     end
%     imshow(imdilate(blank,se));
%     pause
%     if len>n
%         angle_tol=angle_tol+angle_range/2;
%     elseif len<n
%         angle_tol = angle_tol-angle_range/2;
%     end
%     angle_range = angle_range/2;
% end
imshow(imdilate(blank,se));
end

