#include <opencv2/opencv.hpp>
#include <iostream>
#include <fstream>
#include <vector>

using namespace std;
using namespace cv;

class Picture
{
public:
	int number;
	int original_talking_order;
	Picture()
	{
		number=0;original_talking_order=0;
	}
};
class Picture2
{
	public:
	Mat image;
	int number;
	int outdoor_order;
	int set_order;
	Picture2()
	{
		number=0;
		outdoor_order=0;
		set_order=0;
	}
};
int main()
{
	//initialization
	fstream file("all_image.txt");
	fstream filea11("A11.txt",ios_base::out|ios_base::trunc);
	fstream filea12("A12.txt",ios_base::out|ios_base::trunc);
	int i=0,j=0,ii=0,jj=0;
	int random_col=0;
	int random_row=0;
	int random_blue=0,random_green=0,random_red=0;
	int blue_count=0;
	int talking_count=0;
	int outdoor_count=0;
	Mat img[4000],img_gray[4000];
	char filename[30];
	for(i=1;i<4000;i++)
	{
		sprintf(filename,"unsorted_images/%d.jpg",i);
		Mat count=imread(filename,1);
		if(count.empty())
			break;
	}
	int total_number=i-1;
	char name[10]={0,0,0,0,0,0,0,0,0,0};
	char name2[30]="unsorted_images/";
	vector <Mat> talking_img;
	//file operating
	for(i=0;i<total_number;i++)
		file<<i+1<<".jpg"<<endl;
	file.seekg(0,ios::beg);
	filea11.seekg(0,ios::beg);
	filea12.seekg(0,ios::beg);
	//pick out talking scenes and outdoor scenes
	Mat temp_temp;
	vector <Picture> wrongorder;
	vector <Picture> rightorder;
	Picture temp_picture;
	for(i=0,talking_count=0,outdoor_count=0;i<total_number;i++)
	{
		//loading images
		file.getline(name,10);
		for(j=16;j<26&&name[j-16]!='\0';j++)
			name2[j]=name[j-16];
		img[i]=imread(name2,1);
		//decrease dimensions to 1/64 of the original image through Gaussian Pyramid algorithm
		pyrDown(img[i],temp_temp);
		pyrDown(temp_temp,temp_temp);
		pyrDown(temp_temp,temp_temp);
		//convert RGB images to HSV images
		cvtColor(temp_temp,temp_temp,CV_BGR2HSV);
		//if the average of all the pixels is blue, writing to the talking file
		if((mean(temp_temp).val[0]>105&&mean(temp_temp).val[0]<135)
			&&(mean(temp_temp).val[1]>50&&mean(temp_temp).val[1]<255)
			&&(mean(temp_temp).val[2]>50&&mean(temp_temp).val[2]<255))
		{
			filea11<<i+1<<endl;
			cvtColor(img[i],img_gray[i],CV_RGB2GRAY);
			talking_img.push_back(img_gray[i]);
			wrongorder.push_back(temp_picture);
			wrongorder.back().original_talking_order=talking_count;
			wrongorder.back().number=i+1;
			talking_count++;
		}
		else 
		{
			filea12<<i+1<<endl;
			outdoor_count++;
		}
	}
	double **error_matrix=new double*[talking_count];
	for(i=0;i<talking_count;i++)
		error_matrix[i]=new double[talking_count];
	//calculate the distance from the ith image to the jth image
	Mat temp_mat;
	for(i=0;i<talking_count;i++)
	{
		for(j=i;j<talking_count;j++)
		{
			if(i==j) error_matrix[i][j]=0;
			else
			{
				//temp_mat=talking_img[i]-talking_img[j];
				error_matrix[i][j]=norm(talking_img[i],talking_img[j],CV_L2);
				error_matrix[j][i]=error_matrix[i][j];
			}
		}
	}
	//search for the min_distance image for the front and back of the set of right order
	//choose the smallest distance in order to decide whether put the new image in the front or the back 
	rightorder.push_back(wrongorder[0]);
	wrongorder.erase(wrongorder.begin());
	Mat error_mat_front,error_mat_back;double temp_min_front=2147483647,temp_min_back=2147483647,min_error_front=2147483647,min_error_back=2147483647;
	int position_front=0,position_back=0;double iTemp_error_front=0,iTemp_error_back=0;
	for(i=0;(int)rightorder.size()<talking_count;i++)
	{
		for(j=0,temp_min_front=2147483647,temp_min_back=2147483647,min_error_front=2147483647,
			min_error_back=2147483647;j<(int)wrongorder.size();j++)
		{
			iTemp_error_front=error_matrix[rightorder.front().original_talking_order][wrongorder[j].original_talking_order];
			if(iTemp_error_front<min_error_front)
			{
				min_error_front=iTemp_error_front;
				position_front=j;
			}
			iTemp_error_back=error_matrix[rightorder.back().original_talking_order][wrongorder[j].original_talking_order];
			if(iTemp_error_back<min_error_back)
			{
				min_error_back=iTemp_error_back;
				position_back=j;
			}
		}
		if(min_error_front<min_error_back)
		{
			rightorder.insert(rightorder.begin(),wrongorder[position_front]);
			wrongorder.erase(wrongorder.begin()+position_front);
		}
		else 
		{
			rightorder.insert(rightorder.end(),wrongorder[position_back]);
			wrongorder.erase(wrongorder.begin()+position_back);
		}
	}
	//write correct order to the file
	//namedWindow("windows");
	//for(i=0;i<talking_count;i++)
	//{
	//	imshow("windows",talking_img[rightorder[i].original_talking_order]);
	//	waitKey(0);
	//}
	fstream talking_writeorder("A2.txt",ios_base::out);
	for(i=0;i<talking_count;i++)
		talking_writeorder<<rightorder[i].number<<endl;
	return 0;
}