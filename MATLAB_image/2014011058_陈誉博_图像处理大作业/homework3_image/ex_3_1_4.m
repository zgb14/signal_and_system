close all;clear all;clc;
load image_compressed;
[row,column]=size(image_compressed);
code_compressed=[];
for i=1:row
    for j=1:column
        tempcode=double(dec2bin(image_compressed(i,j)))-48;
        tempcode=[zeros(1,8-length(tempcode)),tempcode];
        code_compressed=[code_compressed,tempcode];
    end
end
a=[zeros(1,7),1];
b=repmat(a,1,7);
tempcode=code_compressed(1:length(b));
tempcode=tempcode.*b;
tempcode=find(tempcode~=0)/8;
information_length=zeros(1,7);
information_length(tempcode)=1;
information_length=bin2dec(char(information_length+48));
code_compressed(1:length(b))=[];
information=zeros(1,information_length);
for i=1:information_length
    tempcode=code_compressed(1:length(b));
    tempcode=tempcode.*b;
    tempcode=find(tempcode~=0)/8;
    tempinfo=zeros(1,7);
    tempinfo(tempcode)=1;
    tempinfo=bin2dec(char(tempinfo+48));
    info(i)=tempinfo;
    code_compressed(1:length(b))=[];
end
information=char(info)