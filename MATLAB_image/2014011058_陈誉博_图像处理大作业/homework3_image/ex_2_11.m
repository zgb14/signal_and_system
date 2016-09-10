close all;clear all;clc;
load jpegcodes.mat;
load JpegCoeff.mat;
load result.mat;
load hall.mat;
num_of_block=row/8*column/8;
code_mat=zeros(64,num_of_block);
% DC����
for j=1:num_of_block
    for i=1:12
        Length=DCTAB(i,1);
        if (Length<=length(DCcode)) && (isequal(DCcode(1:Length),DCTAB(i,2:Length+1)))
            Category=i-1;
        end
    end
    Length1=DCTAB(Category+1,1);
    DCcode(1:Length1)=[];
    if Category~=0
        if DCcode(1)==1
            code_mat(1,j)=bin2dec(char(DCcode(1:Category)+48));
        else
            code_mat(1,j)=-bin2dec(char(double(DCcode(1:Category)==0)+48));
        end
        DCcode(1:Category)=[];
    else
        code_mat(1,j)=0;
    end
end
for i=2:num_of_block
    code_mat(1,i)=code_mat(1,i-1)-code_mat(1,i);
end
test1=isequal(code_mat(1,:),result(1,:))
EOB=[1,0,1,0];
ZRL=[ones(1,8),0,0,1];
j=1;
for i=1:num_of_block
    code_decode=[];
    while ~isequal(ACcode(1:length(EOB)),EOB)
        if (length(ZRL)<=length(ACcode))&&(isequal(ACcode(1:length(ZRL)),ZRL))
            code_decode=[code_decode;zeros(16,1)];
            ACcode(1:length(ZRL))=[];
        else
            for j=1:160
                Length=ACTAB(j,3);
                if (Length<=length(ACcode))&&(isequal(ACTAB(j,4:Length+3),ACcode(1:Length)))
                    Loc=j;
                    break;
                end
            end
            Run=ACTAB(Loc,1);
            Size=ACTAB(Loc,2);
            H_Length=ACTAB(Loc,3);
            Huffman=ACTAB(Loc,4:H_Length+3);
            ACcode(1:H_Length)=[];
            Amplitude=ACcode(1:Size);
            ACcode(1:Size)=[];
            code_decode=[code_decode;zeros(Run,1)];
            if Amplitude(1)==1
                code_decode=[code_decode;bin2dec(char(Amplitude+48))];
            else
                code_decode=[code_decode;-bin2dec(char(double(Amplitude==0)+48))];
            end
        end
    end
    ACcode(1:length(EOB))=[];
    code_mat(2:length(code_decode)+1,i)=code_decode;
end
test2=isequal(code_mat,result)
image_compressed=zeros(row,column);
for i=1:row/8
    for j=1:column/8
      temp_mat=iZigZag(code_mat(1,(i-1)*column/8+j),(code_mat(2:64,(i-1)*column/8+j))');
      temp_mat=temp_mat.*QTAB;
      temp_mat=idct2(temp_mat)+128*ones(8,8);
      image_compressed((i-1)*8+1:i*8,(j-1)*8+1:j*8)=temp_mat;
    end
end
subplot(1,2,1);
imshow(hall_gray);
subplot(1,2,2);
imshow(uint8(image_compressed));
psnr(uint8(image_compressed),hall_gray)