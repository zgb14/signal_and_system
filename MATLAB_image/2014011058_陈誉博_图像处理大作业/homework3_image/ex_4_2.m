function ex_4_2(image_name,epcilon,rate)
load train.mat;
image_rgb=imread(image_name);
image_ycbcr=rgb2ycbcr(image_rgb);
cb=image_ycbcr(:,:,2);
cr=image_ycbcr(:,:,3);
image_bin=(cb>=95&cb<=122)&(cr>=133&cr<=170);
se=strel('square',3);
image_fill=imfill(image_bin,'holes');
image_fill=imerode(image_fill,se);
[L,num]=bwlabel(image_fill);
for i=1:num
    [r,c]=find(L==i);
    [row,column]=size(image_fill);
    area=length(r);
    if area<=row*column*0.001
        image_fill(L==i)=0;
    end
end
figure;imshow(image_rgb);
[L,num]=bwlabel(image_fill);
hold on;
u=zeros(2^(3*L2),1);
for i=1:num
    [r,c]=find(L==i);
    top=min(r);bottom=max(r);
    left=min(c);right=max(c);
    row=bottom-top+1;column=right-left+1;
    image_temp_bin=image_fill(top:bottom,left:right);
    left_edge=zeros(row,1);right_edge=zeros(row,1);
    top_edge=zeros(column,1);bottom_edge=zeros(column,1);
    for j=1:row
        white=find(image_temp_bin(j,:)==1);
        left_edge(j)=white(1);
        right_edge(j)=white(end);
    end
    for j=1:column
        white=find(image_temp_bin(:,j)==1);
        top_edge(j)=white(1);
        bottom_edge(j)=white(end);
    end
    [Ele,Num]=ElementNumber(right_edge);
    right=left+max(Ele(Num==max(Num)));
    [Ele,Num]=ElementNumber(left_edge);
    left=left+max(Ele(Num==max(Num)));
    [Ele,Num]=ElementNumber(bottom_edge);
    bottom=top+max(Ele(Num==max(Num)));
    [Ele,Num]=ElementNumber(top_edge);
    top=top+max(Ele(Num==max(Num)));
    row=bottom-top+1;column=right-left+1;
    image_temp=image_rgb(top:bottom,left:right,:);
    image_temp_convert=floor(double(image_temp)/(2^(8-L2)));
    image_temp_num=image_temp_convert(:,:,1)*2^(2*L2)+image_temp_convert(:,:,2)*2^(L2)+image_temp_convert(:,:,3);
    for j=1:2^(3*L2)
        u(j)=length(find(image_temp_num==j-1));
    end
    u=u/(row*column);
    distance=1-sum(sqrt(u.*v));
    if (distance<=epcilon)&&((row/column<=rate)&&(row/column>=1/rate))
        plot([left left],[top bottom],'r');
        plot([right right],[top bottom],'r');
        plot([left right],[top top],'r');
        plot([left right],[bottom bottom],'r');
    end
end
hold off;