result=zeros(10,3);
load coff_colordata.mat;
for i=1:10
    [Loc_row,Loc_column]=find(coff_colordata==max(max(coff_colordata)));
    result(i,:)=[Loc_row,Loc_column,max(max(coff_colordata))];
    coff_colordata(Loc_row,Loc_column)=0;
    image1=imread(['ex_2_7/pic/ex_2_7_',num2str(Loc_row),'.jpg']);
    image2=imread(['ex_2_7/pic/ex_2_7_',num2str(Loc_column),'.jpg']);
    subplot(5,2,i);
    imshow([image1,image2]);
    title(['相关系数：',num2str(result(i,3))]);
end