clc
close all
clear all

%Calling the images files 
cd ('Directory to images');
Image = {'cycle_0.jpg','cycle_1.jpg','cycle_2.jpg','cycle_3.jpg','cycle_4.jpg','cycle_5.jpg','cycle_6.jpg','cycle_7.jpg','cycle_8.jpg','cycle_9.jpg','cycle_10.jpg'};

%Initial parameters
slope_black_old = 0;
x = [0:1:10];

%1st loop - calculates Avg-RGB values for all images
for j=1:length(Image)
    
    I = imread(Image{j});
    red = I(:,:,1); green = I(:,:,2); blue = I(:,:,3);

    Ravg = mean2(red);
    Gavg = mean2(green);
    Bavg = mean2(blue);
    RGB_average(j) = round((Ravg+Gavg+Bavg)/3,2);     
end

% Slope of the RGB values
a = polyfit(x, RGB_average, 1);
slope_RGB = a(1);

%2nd loop - starts with a threshold=20 and moving by 1 increment to optimise the threshold value
for Threshold=20:1:100
   
    %loop - applies the threshold on all images to generate binary images
    for j=1:length(Image)

    I = imread(Image{j});
    red = I(:,:,1); green = I(:,:,2); blue = I(:,:,3);

    out = red < Threshold | green < Threshold | blue < Threshold;
    out2=bwmorph(out,'dilate',1);
    
    %Calculate the percentage of black pixels
    PB(j) = (nnz(~out2) / numel(out2))*100;

    end

% Slope of the %_black_pixels
b = polyfit(x, PB, 1);
slope_black = b(1);

%if statement - compares slope of %_black_pixels with slope of RGB values 
 if (abs(slope_RGB - slope_black) <= abs(slope_RGB - slope_black_old))
       slope_black_old = slope_black; 
 else
     break
 end
end

slope_RGB
slope_black_old
Threshold_final=Threshold-1

folder = 'Directory to folder for svaing images';

%3rd loop - uses the selected threshold and saves the binary images generated  
for j=1:length(Image)
    
    I = imread(Image{j});
    red = I(:,:,1); green = I(:,:,2); blue = I(:,:,3);

    out = red < Threshold_final | green < Threshold_final | blue < Threshold_final;
    out2=bwmorph(out,'dilate',1);
    PB(j) = (nnz(~out2) / numel(out2))*100; 
    
    pngFileName = Image{j};
    fullFileName = fullfile(folder, pngFileName);
    imwrite(out2, fullFileName);
end
 
