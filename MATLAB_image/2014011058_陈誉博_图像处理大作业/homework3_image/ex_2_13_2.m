close all;clear all;clc;
load snow.mat;
load jpegcodes_snow.mat;
code_original=[];
code_compressed=[];
for i=1:row
    for j=1:column
        tempcode=double(dec2bin(snow(i,j)))-48;
        tempcode=[zeros(1,8-length(tempcode)),tempcode];
        code_original=[code_original,tempcode];
    end
end
code_compressed=[DCcode,ACcode];
compressed_ratio=length(code_original)/length(code_compressed)