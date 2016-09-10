close all;clear all;clc;
load hidden.mat;
a=[zeros(1,7),1];
b=repmat(a,1,7);
tempcode=code_hidden(1:length(b));
tempcode=tempcode.*b;
tempcode=find(tempcode~=0)/8;
information_length=zeros(1,7);
information_length(tempcode)=1;
information_length=bin2dec(char(information_length+48));
code_hidden(1:length(b))=[];
information=zeros(1,information_length);
for i=1:information_length
    tempcode=code_hidden(1:length(b));
    tempcode=tempcode.*b;
    tempcode=find(tempcode~=0)/8;
    tempinfo=zeros(1,7);
    tempinfo(tempcode)=1;
    tempinfo=bin2dec(char(tempinfo+48));
    info(i)=tempinfo;
    code_hidden(1:length(b))=[];
end
information=char(info)