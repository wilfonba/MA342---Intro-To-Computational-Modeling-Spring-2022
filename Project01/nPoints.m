function [points] = nPoints(fileName,n,wake_angle,wake_len)
maxItr = 100;
img = rgb2gray(imread(fileName));
edges = uint8(edge(img,"Sobel"))*255;

se = strel("disk",2);
dilated = imclose(edges,se);
filled = imfill(dilated,'holes');
perim = bwperim(filled);
[row,col] = find(perim~=0);
traced = bwtraceboundary(perim,[row(end) col(end)],'N');
imshow(perim);
pause
% placeholder point finder
% points = traced(1:round(pixelCount/n):end,:);
% points(end+1,:) = points(1,:);
% points(end+1,:) = [ ...
%         round(points(end,1)+sind(wake_angle)*wake_len) ...
%         round(points(end,2)+cosd(wake_angle)*wake_len) ...
% ];
% blank = zeros(size(img)*2);
% for i=1:length(points)
%     blank(points(i,1),points(i,2)) = 1;
% end

angle_tol = 30;
angle_range = 30;
points = [row(end) col(end)];
itCount = 0;
stepSize = 25;
while length(points)~= n
    itCount = itCount+1;
    if angle_range<1e-10
       angle_range = 180;
    end
    points = [row(end) col(end)];
    test_angle = atan2d(points(end,1)-traced(15,1),points(end,2)-traced(15,2));
    for i=1:stepSize:length(traced)
        current_angle = atan2d(points(end,1)-traced(i,1),points(end,2)-traced(i,2));
        if abs(test_angle-current_angle) >= angle_tol
           points(end+1,:) = [traced(i,1) traced(i,2)];
           added=i+stepSize;
           if added>length(traced)
              break; 
           end
           test_angle = atan2d(points(end,1)-traced(added,1),points(end,2)-traced(added,2));
        end
    end
    [len,~] = size(points);
      fprintf("it: %d points: %d angle_tol: %d angle_range: %d\n",itCount,len,angle_tol,angle_range);
    if len>n
        angle_tol=angle_tol+angle_range/2;
    elseif len<n
        angle_tol = angle_tol-angle_range/2;
    end
    angle_range = angle_range/2;
    if itCount>maxItr
       stepSize=stepSize+1;
       angle_tol = 30;
        angle_range = 30;
        itCount = 0;
%       disp("iteration count reached");
    end
end
points(end+1,:) = points(1,:);
points(end+1,:) = [ ...
        round(points(end,1)+sind(wake_angle)*wake_len) ...
        round(points(end,2)+cosd(wake_angle)*wake_len) ...
];
blank = zeros(size(img)*2);
for i=1:length(points)
    blank(points(i,1),points(i,2)) = 1;
end
imshow(imdilate(blank,se));
end

