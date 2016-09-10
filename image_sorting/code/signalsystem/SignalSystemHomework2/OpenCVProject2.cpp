#include <iostream>
#include <opencv2/opencv.hpp>
#include <fstream>
#include <vector>
#include <algorithm>
using namespace std;
using namespace cv;
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
	fstream outdoor_file("A12.txt");
	int i=0,j=0,ii=0,jj=0;
	char name[10]={0,0,0,0,0,0,0,0,0,0};
	char name2[30]="unsorted_images/";
	int outdoor_count=0;
	Picture2 temp;
	//Picture2 *outdoor_img=new Picture2[outdoor_count];
	vector <Picture2> outdoor_img;
	vector <Picture2> compressed_outdoor_img;
	outdoor_file.seekg(0,ios_base::beg);
	for(i=0;outdoor_file.peek()!=EOF;i++)
	{
		outdoor_file.getline(name,10);
		strcat(name,".jpg");
		for(j=16;j<26&&name[j-16]!='\0';j++)
			name2[j]=name[j-16];
		outdoor_img.push_back(temp);
		outdoor_img[i].image=imread(name2,1);
		temp=outdoor_img[i];
		//compress the image with Gaussian Pyramid Algorithm
		for(ii=0;ii<4;ii++)
			pyrDown(temp.image,temp.image);
		temp.outdoor_order=i;
		compressed_outdoor_img.push_back(temp);
	}
	outdoor_count=i;
	outdoor_file.seekg(0,ios_base::beg);
	for(i=0;i<(int)compressed_outdoor_img.size();i++)
		outdoor_file>>compressed_outdoor_img[i].number;
	outdoor_file.clear();
	outdoor_file.close();
	Mat temp_mat1,temp_mat12;
	//the distance[i][j] stands for the distance
	//between outdoor_img[i] and outdoor_img[j]
	Mat distance(outdoor_count,outdoor_count,CV_64FC1);
	vector <vector <Picture2>> sets;
	vector <Picture2> temp_push,temp_vector;
	for(i=0;i<outdoor_count;i++)
		for(j=i+1;j<outdoor_count;j++)
		{
			distance.at<double>(i,j)=norm(compressed_outdoor_img[i].image,compressed_outdoor_img[j].image,CV_L2);
			distance.at<double>(j,i)=distance.at<double>(i,j);
		}
	for(i=0;i<outdoor_count;i++)
		distance.at<double>(i,i)=2147483647.0;
	//fix_distance is used in the fixing process
	Mat fix_distance=distance.clone();
	int sum=outdoor_count;
	while(sum>10)
	{
		//here I use the optimized HierarchicalCluster method
		//to figure out different scenes
		double minVal=0.0,maxVal=0.0;
		int minIdx[2]={0,0},maxIdx[2]={0,0};
		//find the overall minium distance and the matrices
		minMaxIdx(distance,&minVal,&maxVal,minIdx,maxIdx);
		sets.push_back(temp_push);
		//use the matrices that have the smallest distance to gain a set
		sets.back().push_back(compressed_outdoor_img[minIdx[0]]);
		sets.back().push_back(compressed_outdoor_img[minIdx[1]]);
		int minIdx_front[2]={0,0},minIdx_back[2]={0,0};
		double minVal_front=0.0,minVal_back=0.0;
		while((int)sets.back().size()<outdoor_count)
		{
			//get the other pictures' distance to the front and back pictures
			temp_mat1=distance.row(sets.back().front().outdoor_order).clone();
			temp_mat12=distance.row(sets.back().back().outdoor_order).clone();
			//set the distance of the front and back to maximum
			for(i=0;i<(int)sets.back().size();i++)
			{
				temp_mat1.at<double>(0,sets.back()[i].outdoor_order)=2147483647;
				temp_mat12.at<double>(0,sets.back()[i].outdoor_order)=2147483647;
			}
			//temp_mat1 and temp_mat12 are all row vectors 
			//so the number of the min_distance is minIdx[1] 
			minMaxIdx(temp_mat1,&minVal_front,&maxVal,minIdx_front,maxIdx);
			minMaxIdx(temp_mat12,&minVal_back,&maxVal,minIdx_back,maxIdx);
			//if the smallest distance is smaller than some value,
			//put it into the current set,else the picture belongs to a new set
			if(minVal_front<2200||minVal_back<2200)
			{
				if(minVal_front<minVal_back)
					sets.back().insert(sets.back().begin(),compressed_outdoor_img[minIdx_front[1]]);
				else 
					sets.back().insert(sets.back().end(),compressed_outdoor_img[minIdx_back[1]]);
			}
			else break;
		}
		//set the distances to pictures in current sets to maximum
		//logically delete the known pictures from the unknown sets
		for(i=0;i<(int)sets.back().size();i++)
		{
			temp_mat1=Mat::ones(1,outdoor_count,CV_64FC1)*2147483647.0;
			temp_mat12=Mat::ones(outdoor_count,1,CV_64FC1)*2147483647.0;
			temp_mat1.copyTo(distance.row(sets.back()[i].outdoor_order));
			temp_mat12.copyTo(distance.col(sets.back()[i].outdoor_order));
		}
		sum-=(int)sets.back().size();
	}
	//the test array is used to examine 
	//whether there is any picture still unknown
	bool *test=new bool[outdoor_count];
	for(i=0;i<outdoor_count;i++)
		test[i]=false;
	//if one picture is missed, the number of 
	//the picture in the test array stay false
	for(i=0;i<(int)sets.size();i++)
		for(j=0;j<(int)sets[i].size();j++)
			test[sets[i][j].outdoor_order]=true;
	int first_minIdx[2]={0,0},first_maxIdx[2]={0,0};
	double first_minVal=0.0,first_maxVal=0.0;
	//find the nearest picture to the missed picture 
	//to decide which set is the missed picture from
	for(i=0;i<outdoor_count;i++)
	{
		if(test[i]==false)
		{
			minMaxIdx(fix_distance.row(i),&first_minVal,&first_maxVal,
				first_minIdx,first_maxIdx);
			for(ii=0;ii<(int)sets.size();ii++)
			{
				for(jj=0;jj<(int)sets[ii].size();jj++)
				{
					if(sets[ii][jj].outdoor_order==first_minIdx[1])
					{
						sets[ii].insert(sets[ii].begin()+sets[ii].size()/2,compressed_outdoor_img[i]);
						test[i]=true;
						temp_mat1=Mat::ones(1,outdoor_count,CV_64FC1)*2147483647.0;
						temp_mat12=Mat::ones(outdoor_count,1,CV_64FC1)*2147483647.0;
						temp_mat1.copyTo(fix_distance.row(sets[ii].back().outdoor_order));
						temp_mat12.copyTo(fix_distance.col(sets[ii].back().outdoor_order));
						break;
					}
				}
				if(test[i]==true)
					break;
			}
		}
	}
	for(i=0;i<sets.size();i++)
		for(j=0;j<sets[i].size();j++)
			sets[i][j].set_order=i;
	//outdoor_mask is the Mat array that stands for
	//the 'earth' area in the outdoor_img
	//the size of the area is small enough that needs no compression
	Picture2 *outdoor_mask=new Picture2[outdoor_count];
	vector <vector <Picture2>> rightorder_sets;
	for(i=0;i<outdoor_count;i++)
	{
		outdoor_mask[i].number=compressed_outdoor_img[i].number;
		outdoor_mask[i].outdoor_order=compressed_outdoor_img[i].outdoor_order;
		outdoor_mask[i].image=outdoor_img[i].image(cv::Rect(55,398,65,37));
	}
	for(i=0;i<(int)sets.size();i++)
		for(j=0;j<(int)sets[i].size();j++)
		{
			outdoor_mask[sets[i][j].outdoor_order].set_order=sets[i][j].set_order;
			outdoor_img[sets[i][j].outdoor_order].set_order=sets[i][j].set_order;
		}
	double temp_distance_front=0.0,temp_distance_back=0.0;
	double min_distance_front=2147483647.0,min_distance_back=2147483647.0;
	int outdoor_position_front=0,outdoor_position_back=0;
	for(i=0;i<(int)sets.size();i++)
	{
		vector <Picture2> wrongorder=sets[i];
		rightorder_sets.push_back(temp_push);
		rightorder_sets.back().push_back(outdoor_mask[sets[i][sets[i].size()/2].outdoor_order]);
		wrongorder.erase(wrongorder.begin()+sets[i].size()/2);
		while(wrongorder.size()>0)
		{
			for(ii=0,min_distance_front=2147483647.0,min_distance_back=2147483647.0;
				ii<(int)wrongorder.size();ii++)
			{
				temp_distance_front=norm(rightorder_sets.back().front().image,
					outdoor_mask[wrongorder[ii].outdoor_order].image,CV_L1);
				temp_distance_back=norm(rightorder_sets.back().back().image,
					outdoor_mask[wrongorder[ii].outdoor_order].image,CV_L1);
				if(temp_distance_front<min_distance_front)
				{
					min_distance_front=temp_distance_front;
					outdoor_position_front=ii;
				}
				if(temp_distance_back<min_distance_back)
				{
					min_distance_back=temp_distance_back;
					outdoor_position_back=ii;
				}
			}
			if(min_distance_front<min_distance_back)
			{
				rightorder_sets.back().insert(rightorder_sets.back().begin(),
					outdoor_mask[wrongorder[outdoor_position_front].outdoor_order]);
				wrongorder.erase(wrongorder.begin()+outdoor_position_front);
			}
			else 
			{
				rightorder_sets.back().push_back(
					outdoor_mask[wrongorder[outdoor_position_back].outdoor_order]);
				wrongorder.erase(wrongorder.begin()+outdoor_position_back);
			}
		}
	}
	//check the last picture of a vector
	for(i=0;i<(int)rightorder_sets.size();i++)
	{
		j=rightorder_sets[i].size();
		double distance_behind=norm(outdoor_mask[rightorder_sets[i][j-1].outdoor_order].image,
			outdoor_mask[rightorder_sets[i][j-2].outdoor_order].image,CV_L1);
		double temp_distance=0.0,min_distance=2147483647.0;
		int position=0;
		double distance_forward=0.0,distance_next=0.0;
		if(distance_behind>50000)
		{
			temp=rightorder_sets[i][j-1];
			rightorder_sets[i].pop_back();
			for(jj=0,min_distance=2147483647.0;jj<(int)rightorder_sets[i].size();jj++)
			{
				temp_distance=norm(outdoor_mask[temp.outdoor_order].image,
					outdoor_mask[rightorder_sets[i][jj].outdoor_order].image,CV_L1);
				if(temp_distance<min_distance)
				{
					min_distance=temp_distance;
					position=jj;
				}
			}
			if(position>0&&position<(int)rightorder_sets[i].size()-1) 
			{
				distance_forward=norm(outdoor_mask[rightorder_sets[i][position].outdoor_order].image,
					outdoor_mask[rightorder_sets[i][position-1].outdoor_order].image,CV_L1);
				distance_next=norm(outdoor_mask[rightorder_sets[i][position].outdoor_order].image,
					outdoor_mask[rightorder_sets[i][position+1].outdoor_order].image,CV_L1);
				if(distance_forward<distance_next)
					rightorder_sets[i].insert(rightorder_sets[i].begin()+position,temp);
				else 
					rightorder_sets[i].insert(rightorder_sets[i].begin()+position+1,temp);
			}
			else if(position==rightorder_sets[i].size()-1)
				rightorder_sets[i].insert(rightorder_sets[i].end()-1,temp);
			else 
				rightorder_sets[i].insert(rightorder_sets[i].begin(),temp);
		}
		else continue;
	}
	//check the first picture of the vector
	for(i=0;i<(int)rightorder_sets.size();i++)
	{
		double distance_before=norm(outdoor_mask[rightorder_sets[i][0].outdoor_order].image,
			outdoor_mask[rightorder_sets[i][1].outdoor_order].image,CV_L1);
		double temp_distance=0.0,min_distance=2147483647.0;
		int position=0;
		double distance_forward=0.0,distance_next=0.0;
		if(distance_before>80000)
		{
			temp=rightorder_sets[i][0];
			rightorder_sets[i].erase(rightorder_sets[i].begin());
			for(jj=0,min_distance=2147483647.0;jj<(int)rightorder_sets[i].size();jj++)
			{
				temp_distance=norm(outdoor_mask[temp.outdoor_order].image,
					outdoor_mask[rightorder_sets[i][jj].outdoor_order].image,CV_L1);
				if(temp_distance<min_distance)
				{
					min_distance=temp_distance;
					position=jj;
				}
			}
			if(position>0&&position<(int)rightorder_sets[i].size()-1) 
			{
				distance_forward=norm(outdoor_mask[rightorder_sets[i][position].outdoor_order].image,
					outdoor_mask[rightorder_sets[i][position-1].outdoor_order].image,CV_L1);
				distance_next=norm(outdoor_mask[rightorder_sets[i][position].outdoor_order].image,
					outdoor_mask[rightorder_sets[i][position+1].outdoor_order].image,CV_L1);
				if(distance_forward<distance_next)
					rightorder_sets[i].insert(rightorder_sets[i].begin()+position,temp);
				else 
					rightorder_sets[i].insert(rightorder_sets[i].begin()+position+1,temp);
			}
			else if(position==rightorder_sets[i].size()-1)
				rightorder_sets[i].insert(rightorder_sets[i].end(),temp);
			else 
				rightorder_sets[i].insert(rightorder_sets[i].begin()+1,temp);
		}
		else continue;
	}
	//we get the rightorder_sets and now order the sets using the 'earth' area
	vector <vector <Picture2>> outdoor_rightorder;
	outdoor_rightorder.push_back(rightorder_sets.front());
	rightorder_sets.erase(rightorder_sets.begin());
	double min_head_head=2147483647.0,temp_head_head=0.0;
	double min_head_end=2147483647.0,temp_head_end=0.0;
	double min_end_head=2147483647.0,temp_end_head=0.0;
	double min_end_end=2147483647.0,temp_end_end=0.0;
	int position_head_head=0;
	int position_head_end=0;
	int position_end_head=0;
	int position_end_end=0;
	while(rightorder_sets.size()>0)
	{
		for(i=0,min_head_head=2147483647.0,min_head_end=2147483647.0,
			min_end_head=2147483647.0,min_end_end=2147483647.0;i<(int)rightorder_sets.size();i++)
		{
			temp_head_head=norm(outdoor_mask[outdoor_rightorder.front().front().outdoor_order].image,
				outdoor_mask[rightorder_sets[i].front().outdoor_order].image,CV_L1);
			temp_head_end=norm(outdoor_mask[outdoor_rightorder.front().front().outdoor_order].image,
				outdoor_mask[rightorder_sets[i].back().outdoor_order].image,CV_L1);
			temp_end_head=norm(outdoor_mask[outdoor_rightorder.back().back().outdoor_order].image,
				outdoor_mask[rightorder_sets[i].front().outdoor_order].image,CV_L1);
			temp_end_end=norm(outdoor_mask[outdoor_rightorder.back().back().outdoor_order].image,
				outdoor_mask[rightorder_sets[i].back().outdoor_order].image,CV_L1);
			if(temp_head_head<min_head_head)
			{
				min_head_head=temp_head_head;
				position_head_head=i;
			}
			if(temp_head_end<min_head_end)
			{
				min_head_end=temp_head_end;
				position_head_end=i;
			}
			if(temp_end_head<min_end_head)
			{
				min_end_head=temp_end_head;
				position_end_head=i;
			}
			if(temp_end_end<min_end_end)
			{
				min_end_end=temp_end_end;
				position_end_end=i;
			}
		}
		//the rightorder's head match some sets_vector's head
		if(min_head_head < min_head_end && min_head_head < min_end_head && min_head_head < min_end_end)
		{
			reverse(rightorder_sets[position_head_head].begin(),rightorder_sets[position_head_head].end());
			outdoor_rightorder.insert(outdoor_rightorder.begin(),rightorder_sets[position_head_head]);
			rightorder_sets.erase(rightorder_sets.begin()+position_head_head);
		}
		//the rightorder's head match some sets_vector's end
		if(min_head_end < min_head_head && min_head_end < min_end_head && min_head_end < min_end_end)
		{
			outdoor_rightorder.insert(outdoor_rightorder.begin(),rightorder_sets[position_head_end]);
			rightorder_sets.erase(rightorder_sets.begin()+position_head_end);
		}
		//the rightorder's end match some sets_vector's head
		if(min_end_head < min_head_head && min_end_head < min_head_end && min_end_head < min_end_end)
		{
			outdoor_rightorder.insert(outdoor_rightorder.end(),rightorder_sets[position_end_head]);
			rightorder_sets.erase(rightorder_sets.begin()+position_end_head);
		}
		//the rightorder's end match some sets_vector's end
		if(min_end_end < min_head_head && min_end_end < min_head_end && min_end_end < min_end_head)
		{
			reverse(rightorder_sets[position_end_end].begin(),rightorder_sets[position_end_end].end());
			outdoor_rightorder.insert(outdoor_rightorder.end(),rightorder_sets[position_end_end]);
			rightorder_sets.erase(rightorder_sets.begin()+position_end_end);
		}
	}
	rightorder_sets.clear();
	rightorder_sets.push_back(outdoor_rightorder.front());
	for(i=1;i<(int)outdoor_rightorder.size();i++)
	{
		j=(int)outdoor_rightorder[i-1].size();
		double distance_between=norm(outdoor_mask[outdoor_rightorder[i][24].outdoor_order].image,
			outdoor_mask[outdoor_rightorder[i-1][j-25].outdoor_order].image,CV_L1);
		//if distance_between < 100000, it means that rightorder[i-1] and rightorder[i] twist in different orders
		if(distance_between>=100000.0)
		{
			rightorder_sets.back().insert(rightorder_sets.back().end(),
				outdoor_rightorder[i].begin(),outdoor_rightorder[i].end());
		}
		else 
			rightorder_sets.push_back(outdoor_rightorder[i]);
	}
	for(i=1;i<(int)rightorder_sets.size();i=i+2)
		reverse(rightorder_sets[i].begin(),rightorder_sets[i].end());
	outdoor_rightorder.clear();
	outdoor_rightorder.push_back(rightorder_sets.front());
	rightorder_sets.erase(rightorder_sets.begin());
	//rightorder_sets is the known sequence and outdoor_rightorder is the output sequence
	outdoor_position_front=0;outdoor_position_back=0;
	while(rightorder_sets.size()>0)
	{
		for(i=0,min_distance_front=2147483647.0,min_distance_back=2147483647.0;i<(int)rightorder_sets.size();i++)
		{
			//find the best match for front
			temp_distance_front=norm(outdoor_mask[outdoor_rightorder.front().front().outdoor_order].image,
				outdoor_mask[rightorder_sets[i].back().outdoor_order].image,CV_L1);
			//find the best match for back
			temp_distance_back=norm(outdoor_mask[outdoor_rightorder.back().back().outdoor_order].image,
				outdoor_mask[rightorder_sets[i].front().outdoor_order].image,CV_L1);
			if(temp_distance_front<min_distance_front)
			{
				min_distance_front=temp_distance_front;
				outdoor_position_front=i;
			}
			if(temp_distance_back<min_distance_back)
			{
				min_distance_back=temp_distance_back;
				outdoor_position_back=i;
			}
		}
		if(min_distance_front<min_distance_back)
		{
			outdoor_rightorder.insert(outdoor_rightorder.begin(),rightorder_sets[outdoor_position_front]);
			rightorder_sets.erase(rightorder_sets.begin()+outdoor_position_front);
		}
		else 
		{
			outdoor_rightorder.push_back(rightorder_sets[outdoor_position_back]);
			rightorder_sets.erase(rightorder_sets.begin()+outdoor_position_back);
		}
	}
	fstream output3("A3.txt");
	int previous_scene_number=2147483647;
	int scene_number=0;
	for(i=0,scene_number=0;i<(int)outdoor_rightorder.size();i++)
		for(j=0;j<(int)outdoor_rightorder[i].size();j++)
		{
			if(previous_scene_number!=outdoor_rightorder[i][j].set_order)
				scene_number++;
			output3<<outdoor_rightorder[i][j].number<<","<<scene_number<<endl;
			previous_scene_number=outdoor_rightorder[i][j].set_order;
		}
	output3.clear();
	output3.close();
	return 0;
}