% 2D Homography and Stitching of NIR images
clear all
close all
clc

% Number of Images for panorama
numImages = 9;

% Load image 1 of the panorama
IM1 = rgb2gray(imread('1.png'));

% Select appropriate subsection of image to get rid of extraneous effects
% not part of the image to be analyzed
IM1 = IM1(200:600, 250:950);

% Extract important features of the extracted vein images
points = detectSURFFeatures(IM1);

% Obtain the locations of feature pts - pts
[features, pts] = extractFeatures(IM1,points);

for n = 2:numImages
    
    % Store points and features for I(n-1)
    pointsPrevious = points;
    featuresPrevious = features;
    ptsPrevious = pts;
    
    % Read Images
    filename = [num2str(n) '.png'];
    I = imread(filename);
    I = rgb2gray(I);
    I = I(200:600, 250:950);
      
    % Detect and extract features for I(n)
    points = detectSURFFeatures(I);
    [features, pts] = extractFeatures(I, points);
    
    % Find matches between I and I(n-1)
    Pairs = matchFeatures(featuresPrevious,features,'Method','Approximate','Unique',true);
    
    % Locations of the points in each image
    matchedPoints = pts(Pairs(:,2),:);
    matchedPointsPrev = ptsPrevious(Pairs(:,1),:);

    % Get only the strongest matches (inlier Points)
    [tform, inlierPointsPrev, inlierPoints] = ...
    estimateGeometricTransform(matchedPointsPrev, matchedPoints,'similarity');

    % Locations of the Inlier Points are found in the inlierPoints class. The
    % values must be made integer values to plot. detectSURFFeatures has
    % subpixel accuracy, so this is a valid step.
    % Coordinates gives the [x,y] coordinates of the inlier points.
    Coordinates = round(inlierPoints.Location);
    CoordinatesPrev = round(inlierPointsPrev.Location);

    % Get the transformation and show the overlay
    TForms(n) = fitgeotrans(Coordinates,CoordinatesPrev,'nonreflectivesimilarity');
    TForms(n).T = TForms(n-1).T*TForms(n).T;  
end

imageSize = size(IM1);

% Initialize Panorama
for i = 1:numel(TForms)
    [xlim(i,:), ylim(i,:)] = outputLimits(TForms(i), [1 imageSize(2)], [1 imageSize(1)]);
end

% Find the minimum and maximum output limits
xMin = min([1; xlim(:)]);
xMax = max([imageSize(2); xlim(:)]);

yMin = min([1; ylim(:)]);
yMax = max([imageSize(1); ylim(:)]);

% Width and height of panorama.
width  = round(xMax - xMin);
height = round(yMax - yMin);

% Initialize the "empty" panorama.
panorama = zeros([height width], 'like', IM1);

blender = vision.AlphaBlender('Operation', 'Binary Mask', ...
    'MaskSource', 'Input port');

% Create a 2-D spatial reference object defining the size of the panorama.
xLimits = [xMin xMax];
yLimits = [yMin yMax];
panoramaView = imref2d([height width], xLimits, yLimits);

% Create the panorama.

for i = 1:numImages

      filename = [num2str(i) '.png'];
      I = imread(filename);
      I = rgb2gray(I);
      I = I(200:600, 250:950);
      
    % Transform I into the panorama.
     warpedImage = imwarp(I, TForms(i),'OutputView', panoramaView);
    
    % Generate a binary mask.
     mask = imwarp(true(size(I,1),size(I,2)), TForms(i),'OutputView', panoramaView);
 
    % Overlay the warpedImage onto the panorama.
    panorama = step(blender, panorama, warpedImage, mask);
end

figure()
imshow(panorama)
