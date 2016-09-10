result=zeros(10,3);
load coff_data.mat;
for i=1:10
    [Loc_row,Loc_column]=find(coff_data==max(max(coff_data)));
    result(i,:)=[Loc_row,Loc_column,max(max(coff_data))];
    coff_data(Loc_row,Loc_column)=0;
    image1=imread(['ex_2_2_pic/ex_2_2_',num2str(Loc_row),'.jpg']);
    image2=imread(['ex_2_2_pic/ex_2_2_',num2str(Loc_column),'.jpg']);
    subplot(5,2,i);
    imshow([image1,image2]);
    title(['相关系数：',num2str(result(i,3))]);
end
