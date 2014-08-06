close all
clear all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%reading an image
%I=imread('IMG_0141.JPG');    
%I=imread('test1.JPG');
I = imread('face7.jpg');
%I = imread('IMG_0143.JPG');
%I = imread('IMG_0146.JPG');

[Ix,Iy,Iz]=size(I);
if Ix>400&Iy>300
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%reducing the scale of image, let the high is 400
    %%%by using bi-linear interpolation
    I=imresize(I,[400,Iy*400/Ix],'bilinear');
end
figure
imshow(I)
title('normal image')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%skin detection 
I=double(I);             %converting the integer into decimal fraction
[hue,s,v]=rgb2hsv(I);    %converting RGB space into HSV space
cb=0.148*I(:,:,1)-0.291*I(:,:,2)+0.439*I(:,:,3)+128;%converting RGB space into YCrCb space
cr=0.439*I(:,:,1)-0.368*I(:,:,2)-0.071*I(:,:,3)+128;  

%ycbcr=rgb2ycbcr(I);
%y=ycbcr(:,:,1);
%cb=ycbcr(:,:,2);
%cr=ycbcr(:,:,3);

[w h]=size(I(:,:,1)); %size of the image 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% let the skin pels points in the YCrCb space as 1
for i=1:w
    for j=1:h 
        % segmenting the yellow skin colour areas      
        if  140<=cr(i,j) && cr(i,j)<=160 && 160<=cb(i,j) && cb(i,j)<=180 && 0.01<=hue(i,j) && hue(i,j)<=0.15      
            segment(i,j)=1; %skin areas        
        else       
            segment(i,j)=0;
        end    
    end
end
figure
imshow(segment);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% processing on the detected areas
skin=segment;
% removing small connected pixels
  skin=bwareaopen(skin,round(w*h/900));
%dilating
  se=strel('disk',5);
  skin=imdilate(skin,se);        

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%display skin areas 
im(:,:,1)=I(:,:,1).*skin;   
im(:,:,2)=I(:,:,2).*skin; 
im(:,:,3)=I(:,:,3).*skin; 
figure
imshow(uint8(im));
title('skin areas')

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% detection of face object
BW = skin;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% marking the connected areas
L = bwlabel(BW,8);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% calculating acreage of every connected area and converting the data
%%%%%% of cell into array
BB  = regionprops(L, 'BoundingBox');
BB1=struct2cell(BB);
%saving the begining point of connected frame and its high and wide
BB2=cell2mat(BB1);
figure,imshow(uint8(I));
title('result image');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% show the target in rectangular frame
[s1 s2]=size(BB2);
for k=3:4:s2-1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%BB2(1,k)wide??BB2(1,k+1)high
    if (BB2(1,k)/BB2(1,k+1)) < 1.8 &&....
        (BB2(1,k)/BB2(1,k+1)) > 0.4 &&....
         (BB2(1,k)*BB2(1,k+1)) > 1000
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %%%%% considering the areas which have 0.4<W/H<1.8 and their pixels acreage is bigger than 1000 as face
     hold on;
     rectangle('Position',[BB2(1,k-2),BB2(1,k-1),BB2(1,k),BB2(1,k+1)],'EdgeColor','r' )
    end
end



