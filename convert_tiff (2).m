% im_name = white1;    %the name of your input image
% out_name = 'xyz_converted.jpg';   %the name of the desired output
% name = white1
IM1 = imread('white1.tif');   %read in the image
IM2 = imread('green1.tif');   %read in the image
IM3 = imread('blue1.tif');   %read in the image
IM4 = imread('red1.tif');   %read in the image

% [J, rect] = imcrop(IM);
% whos
IM11 = imcrop(IM,[1.5 0.5 2047 1045]);
IM22 = imcrop(IM,[1.5 0.5 2047 1045]);
IM33 = imcrop(IM,[1.5 0.5 2047 1045]);
IM44 = imcrop(IM,[1.5 0.5 2047 1045]);
% 
% imwrite(IM11, 'white1.png');  %write it out
% imwrite(IM22, 'green1.png');
% imwrite(IM33, 'blue1.png');
% imwrite(IM44, 'red1.png');

% subplot(2,2,1);
% imshow(IM11);title('white LED');
% subplot(2,2,2);
% imshow(IM22);title('green LED');
% subplot(2,2,3);
% imshow(IM33);title('blue LED');
% subplot(2,2,4);
% imshow(IM44);title('red LED');

IM1 = immultiply(uint16(IM11),uint16(IM11));

IM12 = imfuse(IM11,IM22);
% figure;imshow(IM12)
IM12_sub = imabsdiff(IM11,IM22);
figure;imshow(IM12_sub)

IM12_sub = imabsdiff(IM11,IM22);
figure;imshow(IM12_sub)

IM12_sub = imabsdiff(IM11,IM22);
figure;imshow(IM12_sub)
