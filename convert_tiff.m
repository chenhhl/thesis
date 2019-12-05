im_name = white1;    %the name of your input image
% out_name = 'xyz_converted.jpg';   %the name of the desired output
IM = imread('im_name.tif');   %read in the image
imwrite(IM, 'im_name.png');  %write it out