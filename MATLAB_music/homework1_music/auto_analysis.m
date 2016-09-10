clear all;close all;clc;
Fs=8000;
T=1/Fs;
y=wavread('fmt.wav');
Length=length(y);
wave_temp=abs(y);
average=sum(wave_temp)/Length;
position=1;
for i=1:Length
    if i<232
        back=1;
    else
        back=i-231;
    end
    if i>Length-100
        form=Length;
    else
        form=i+100;
    end
    max_back=max(wave_temp(back:i));
    max_form=max(wave_temp(i:form));
    if (max_back*1.5<max_form)&&(wave_temp(i)>1.5*average)&&(i>position(end)+900)
        position=[position;i];
    end
end
position(1)=[];
% plot(y);
% hold on;
% plot([position(:) position(:)],[-0.6 0.6],'red');
% axis([0,14e4,-0.6,0.6]);

%·ÖÎö½ÚÅÄ
rhythm=zeros(length(position),1);
rhythm_length=zeros(length(position),1);
for i=1:length(position)
    if(i~=length(position))
        temp=y(position(i):position(i+1));
    else
        temp=y(position(end):Length);
    end
    rhythm_length(i)=length(temp);
end
standard_length=[8000,4000,2000,12000,6000];
standard_pat=['2  ';'4  ';'8  ';'2+4';'4+8'];
error=abs(rhythm_length(:,ones(1,5))-standard_length(ones(length(position),1),:));
error_min=min(error,[],2);
min_error_pos=zeros(length(position),1);
for i=1:length(position)
    min_error_pos(i)=find(error(i,:)==error_min(i));
end
pat=zeros(length(position),3);
pat(1:length(position),:)=standard_pat(min_error_pos(1:length(position)),:);
pat_length=zeros(length(position),1);
pat_length(1:length(position))=standard_length(min_error_pos(1:length(position)));
%disp(char(pat));
%·ÖÎöÒôµ÷
analysis_sample=zeros(400,length(position));
fre_max=zeros(length(position),1);
for i=1:length(position)
    temp=y(position(i)+1:position(i)+400);
    analysis_sample(:,i)=temp(:)/max(temp(:));
    temp_100=zeros(40000,1);
    for j=1:100
        temp_100((j-1)*400+1:j*400)=analysis_sample(:,i);
    end
    t=(0:length(temp_100)-1)*T;
    NFFT1=2^nextpow2(length(temp_100));
    F1=fft(temp_100,NFFT1)/length(temp_100);
    f1=Fs/2*linspace(0,1,NFFT1/2+1);
    fre_max(i)=find(2*abs(F1(1:NFFT1/2+1))==max(2*abs(F1(1:NFFT1/2+1))));
    fre_max(i)=fre_max(i)/(NFFT1/2+1)*Fs/2;
    if fre_max(i)>600
        tempfre1=round(fre_max(i)/2);
        tempfre2=round(fre_max(i)/3);
        if 2*abs(F1(tempfre1))>2*abs(F1(tempfre2))
            fre_max(i)=tempfre1;
        else
            fre_max(i)=tempfre2;
        end
    end
    %     subplot(5,6,i);
    %     plot(f1,2*abs(F1(1:NFFT1/2+1)));
    %     axis([0,2000,0,0.5]);
    %     title(['Òô·û',num2str(i),'ÆµÓò²¨ÐÎ']);
    %     hold on;
    %     plot([fre_max(i) fre_max(i)],[0,0.7],'red');
    %     if (i==2)||(i==6)||(i==7)||(i==18)||(i==3)
    %         figure;
    %         plot(f1,2*abs(F1(1:NFFT1/2+1)));
    %         axis([0,2000,0,1]);
    %         title(['Òô·û',num2str(i),'ÆµÓò²¨ÐÎ']);
    %     end
end
sound(y,Fs);
temp_fre=[261.63,277.18,293.66,311.13,329.63,349.23,369.99,392,415.30,440,466.16,493.88];
standard_fre=zeros(1,36);
standard_tune=['C- ';'Db-';'D- ';'Eb-';'E- ';'F- ';'Gb-';'G- ';'Ab-';'A- ';'Bb-';'B- ';'C  ';'Db ';'D  ';'Eb ';'E  ';'F  ';'Gb ';'G  ';'Ab ';'A  ';'Bb ';'B  ';'C+ ';'Db+';'D+ ';'Eb+';'E+ ';'F+ ';'Gb+';'G+ ';'Ab+';'A+ ';'Bb+';'B+ '];
for i=1:3;
    standard_fre((i-1)*12+1:i*12)=temp_fre(:)*(2.^(i-2));
end
error2=abs(standard_fre(ones(length(position),1),:)-fre_max(:,ones(1,length(standard_fre))));
error2_min=min(error2,[],2);
min_error2_pos=zeros(length(position),1);
for i=1:length(position)
    min_error2_pos(i)=find(error2(i,:)==error2_min(i));
end
tune=zeros(length(position),3);
tune(1:length(position),:)=standard_tune(min_error2_pos(1:length(position)),:);
tune_fre=zeros(length(position),1);
tune_fre(1:length(position))=standard_fre(min_error2_pos(1:length(position)));
num=zeros(length(position),1);
num(1:length(position))=1:length(position);
dis=cell(1,1);
for i=1:length(position)
    dis={num(i),char(tune(i,:)),char(pat(i,:))};
    disp(dis);
end
save auto_data.mat tune_fre pat_length y position;
