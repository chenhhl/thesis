% 2D Homography and Stitching of NIR images
clear all
close all
clc

% Load images
Template = rgb2gray(imread('C:\Users\inak\Dropbox (MIT)\Research\Image Processing\NIR\SizeUniqueness\2.png'));
Stitched = rgb2gray(imread('C:\Users\inak\Dropbox (MIT)\Research\Image Processing\NIR\SizeUniqueness\RB_S.png'));

Image1 = Template;
Image2 = Stitched;

% SURF to find points that are corner points and scale invariant. Use the
% surrounding information to get the descriptors
points1 = detectSURFFeatures(Image1);
points2 = detectSURFFeatures(Image2);

% Obtain the locations - pts
[features1, pts1] = extractFeatures(Image1,points1); % feature descriptor 
[features2, pts2] = extractFeatures(Image2,points2);

% Indices of the matching features of the two images
% Look for unique points and match
Pairs = matchFeatures(features1,features2,'Method','Approximate','Unique',true);

% Locations of the points in each image
matchedPoints1 = pts1(Pairs(:,1),:);
matchedPoints2 = pts2(Pairs(:,2),:);

% Get only the strongest matches (inlier Points)
[tform, inlier1Points, inlier2Points] = ...
    estimateGeometricTransform(matchedPoints1, matchedPoints2, 'similarity');

% Show the strongest matches. Make sure the lines are parallel for good
% homography
figure();
showMatchedFeatures(Image1, Image2, inlier1Points, ...
    inlier2Points, 'montage');
title('Matched Points (Inliers Only)');

% Locations of the Inlier Points are found in the inlierPoints class. The
% values must be made integer values to plot. detectSURFFeatures has
% subpixel accuracy, so this is a valid step.
% Coordinates gives the [x,y] coordinates of the inlier points.
Coordinates1 = round(inlier1Points.Location);
Coordinates2 = round(inlier2Points.Location);

% Get the transformation and show the overlay
TForm = fitgeotrans(Coordinates1,Coordinates2,'nonreflectivesimilarity');
Registered = imwarp(Template, TForm, 'OutputView', imref2d(size(Stitched)));
figure();imshowpair(Stitched,Registered); title('Template Within Stitched Image')