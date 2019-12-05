clear all
close all

%Number of images to be analyzed
N = 500; 

% Segment veins on all images used to make template
for i = 1:N
    i
    %Load image
    file = ['VimbaImage__New_' int2str(i) '.png'];
    img = imread(file);
    
    %Select values for Difference of Gaussians (DoG) Technique
    sigma1 = 7;
    sigma2 = 80;
    k = 15;
    
    %Process Image with DoG
    gauss1 = fspecial('gaussian', round([k*sigma1 k*sigma1]), sigma1);
    gauss2 = fspecial('gaussian', round([k*sigma2 k*sigma2]), sigma2);
    blur1 = imgaussfilt(double(img),sigma1);
    blur2 = imgaussfilt(double(img),sigma2);
    dogImg = blur1 - blur2;

    % Filtering to get rid of speckle noise and clean image
    Final = medfilt2(dogImg,[4 4]);
    Final = imbinarize(Final,'adaptive','ForegroundPolarity','dark','Sensitivity',0.4);
    Final = bwmorph(Final,'majority');
    Final = medfilt2(Final,[15 10]);
    
    %Save Image
    Gray = mat2gray(Final);
    imwrite(Gray,strcat('vein',int2str(i)));
end