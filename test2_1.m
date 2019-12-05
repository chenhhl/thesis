im1 = imread('C:\Users\Holly Chen\Dropbox (MIT)\MIT_Group_HollyChen\Holly_vein_project\Raw_Img\112619\001940.tif');
im2 = imread('C:\Users\Holly Chen\Dropbox (MIT)\MIT_Group_HollyChen\Holly_vein_project\Raw_Img\112619\002940.tif');
im3 = imread('C:\Users\Holly Chen\Dropbox (MIT)\MIT_Group_HollyChen\Holly_vein_project\Raw_Img\112619\003940.tif');
im4 = imread('C:\Users\Holly Chen\Dropbox (MIT)\MIT_Group_HollyChen\Holly_vein_project\Raw_Img\112619\004940.tif');

amb= imread('C:\Users\Holly Chen\Dropbox (MIT)\MIT_Group_HollyChen\Holly_vein_project\Raw_Img\112719\amb11.tif');
vein= imread('C:\Users\Holly Chen\Dropbox (MIT)\MIT_Group_HollyChen\Holly_vein_project\Raw_Img\112719\vein1.tif');

montage({amb,vein,adapthisteq(amb),adapthisteq(vein)},'Size',[1 4]);
figure;imshow(vein);
figure;imshow(amb);

% imrect(gca,mask1)

im1 = imcrop(amb, mask1);
im2 = imcrop(vein, mask2);

size(im1)
size(im2)
imshowpar(im1,im2,'montage');
imshowpar(im1,im2);

imshow(imabsdiff(im1,im2));


figure;
im1thresh = amb;
% im1thresh(im1thresh >100) = 0;
im1thresh(im1thresh <50) = 0;
imshow(im1thresh)


im12=imfuse(im1,im2);
imshow(im12)
im123=imfuse(im12,im3);
imshow(im123)
im1234=imfuse(123,im4);
imshow(im1234)
mask=getrect();

im1 = imcrop(im1, mask);
im2 = imcrop(im2, mask);
im3 = imcrop(im3, mask);
im4 = imcrop(im4, mask);

montage({im4,im3,im2,im1},'Size',[1 4]);

