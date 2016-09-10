function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 19-Jul-2016 21:00:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @gui_OpeningFcn, ...
    'gui_OutputFcn',  @gui_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp_fmt=getappdata(handles.axes1,'fmt_src');
if ~isempty(temp_fmt)
    sound(temp_fmt,8000);
else
    h=errordlg('没有读入文件！');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
h=inputdlg('请输入文件名：');
if ~isempty(h)&&isempty(h{1})
    h2=errordlg('输入不能为空！');
else
    if ~isempty(h)&&~isempty(h{1})
        fmt=wavread(char(h));
        fmt_src=getappdata(handles.pushbutton1,'fmt_src');
        plot((1:length(fmt)),fmt);
        axis([0,14e4,-0.6,0.6]);
        setappdata(handles.axes1,'fmt_src',fmt);
    end
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fmt=getappdata(handles.axes1,'fmt_src');
if ~isempty(fmt)
    Fs=8000;
    Length=length(fmt);
    wave_temp=abs(fmt);
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
    position=[position;length(fmt)];
    axes(handles.axes2);
    plot(fmt);
    hold on;
    plot([position(:) position(:)],[-1 1],'red');
    axis([0,14e4,-0.6,0.6]);
    setappdata(handles.pushbutton3,'position',position);
else
    h=errordlg('没有读入文件！');
end



% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Fs=8000;
fmt=getappdata(handles.axes1,'fmt_src');
if ~isempty(fmt)
    position=getappdata(handles.pushbutton3,'position');
    if ~isempty(position)
        num=getappdata(handles.edit1,'num');
        if ~isempty(num)&&~isnan(num)
            if(num>length(position)-1||num<1)
                h=errordlg(['输入编号不合法,请输入1-',num2str(length(position)-1),' 的整数'],'错误');
            else
                NFFT1=2^nextpow2(40000);
                f1=Fs/2*linspace(0,1,NFFT1/2+1);
                temp=fmt(position(num)+1:position(num)+400);
                analysis_sample=temp(:)/max(temp(:));
                temp_100=zeros(40000,1);
                for j=1:100
                    temp_100((j-1)*400+1:j*400)=analysis_sample;
                end
                F1=fft(temp_100,NFFT1)/length(temp_100);
                axes(handles.axes3);
                plot(f1,2*abs(F1(1:NFFT1/2+1)));
                axis([0,2000,0,0.5]);
            end
        else
            h=errordlg('没有输入编号！');
        end
    else
        h=errordlg('没有分割音符！');
    end
else
    h=errordlg('没有读入文件！');
end


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
num=str2double(get(handles.edit1,'String'));
position=getappdata(handles.pushbutton3,'position');
if ~isempty(position)
    if(num>length(position)-1||num<1)
        h=errordlg(['输入编号不合法,请输入1-',num2str(length(position)-1),' 的整数'],'错误');
    end
    setappdata(handles.edit1,'num',num);
else
    h=errordlg('没有分割音符！');
end


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
y=getappdata(handles.axes1,'fmt_src');
if ~isempty(y)
    position=getappdata(handles.pushbutton3,'position');
    if ~isempty(position)
        position(end)=[];
        Fs=8000;
        Length=length(y);
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
        %分析音调
        analysis_sample=zeros(400,length(position));
        fre_max=zeros(length(position),1);
        for i=1:length(position)
            temp=y(position(i)+1:position(i)+400);
            analysis_sample(:,i)=temp(:)/max(temp(:));
            temp_100=zeros(40000,1);
            for j=1:100
                temp_100((j-1)*400+1:j*400)=analysis_sample(:,i);
            end
            NFFT1=2^nextpow2(length(temp_100));
            F1=fft(temp_100,NFFT1)/length(temp_100);
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
        end
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
        num=zeros(length(position),2);
        dis=cell(length(position),3);
        for i=1:length(position)
            ten=char(i/10);
            if ten==0
                num(i,:)=[char(48+i),' '];
            else
                num(i,:)=[char(48+ten),char(48+i-ten*10)];
            end
            dis(i,:)={char(num(i,:)),char(tune(i,:)),char(pat(i,:))};
        end
        set(handles.uitable,'Data',dis);
%         set(handles.edit2,'string',char(65));
    else
        h=errordlg('没有分割音符！');
    end
else
    h=errordlg('没有读入文件！');
end

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load envelope.mat;
f_low_do=174.61;
K=2^(1/12);
Fs=8000;
frequency=zeros(2,12);
frequency(1,1)=f_low_do;
for i=2:12
frequency(1,i)=frequency(1,i-1)*K;
end
i=1:12;
frequency(2,i)=frequency(1,i)*2;
f_basic=frequency(2,1);
frequency_step=zeros(1,14);
for j=1:2
i=1:3;
frequency_step(1,i+7*(j-1))=frequency(j,2*i-1);
frequency_step(1,4+7*(j-1))=frequency(j,6);
i=5:7;
frequency_step(1,i+7*(j-1))=frequency(j,2*i-2);
end
length=16;
dfh=[12,12,12,13,9,9,9,9,8,8,8,6,9,9,9,9];
parameter6=[1,0.3514,0.2202,0.1707,0.1235,0,0.2287];
parameter8=[1,0.1403,0.3535,0,0,0,0];
parameter9=[1,0.3920,0,0.1093,0,0,0.1408];
parameter12=[1,2.6253,0.7736,0.9474,0,0.1064,0];
parameter13=[1,0.4217,0,0.1687,0,0,0];
f=[1;2;3;4;5;6;7];
t1=1:length*Fs/4;
t1(1:Fs/2)=(1:Fs/2).*2/Fs;
t1(Fs/2+1:Fs*3/4)=(1:Fs/4).*4/Fs;
t1(Fs*3/4+1:Fs)=(1:Fs/4).*4/Fs;
t1(Fs+1:2*Fs)=(1:Fs).*1/Fs;
t1(2*Fs+1:2*Fs+Fs/2)=(1:Fs/2).*2/Fs;
t1(2*Fs+Fs/2+1:2*Fs+Fs*3/4)=(1:Fs/4).*4/Fs;
t1(2*Fs+Fs*3/4+1:2*Fs+Fs)=(1:Fs/4).*4/Fs;
t1(2*Fs+Fs+1:2*Fs+2*Fs)=(1:Fs).*1/Fs;
y1(1:Fs/2)=parameter12*sin(2*0.5*f*pi*frequency_step(12)*t1(1:Fs/2)).*exp_envelope_four;
y1(Fs/2+1:Fs*3/4)=parameter12*sin(2*0.25*f*pi*frequency_step(12)*t1(Fs/2+1:Fs*3/4)).*exp_envelope_eight;
y1(Fs*3/4+1:Fs)=parameter13*sin(2*0.25*f*pi*frequency_step(13)*t1(Fs*3/4+1:Fs)).*exp_envelope_eight;
y1(Fs+1:2*Fs)=parameter9*sin(2*f*pi*frequency_step(9)*t1(Fs+1:2*Fs)).*exp_envelope_two;
y1(2*Fs+1:2*Fs+Fs/2)=parameter8*sin(2*0.5*f*pi*frequency_step(8)*t1(2*Fs+1:2*Fs+Fs/2)).*exp_envelope_four;
y1(2*Fs+Fs/2+1:2*Fs+Fs*3/4)=parameter8*sin(2*0.25*f*pi*frequency_step(8)*t1(2*Fs+Fs/2+1:2*Fs+Fs*3/4)).*exp_envelope_eight;
y1(2*Fs+Fs*3/4+1:2*Fs+Fs)=parameter6*sin(2*0.25*f*pi*frequency_step(6)*t1(2*Fs+Fs*3/4+1:2*Fs+Fs)).*exp_envelope_eight;
y1(2*Fs+Fs+1:2*Fs+2*Fs)=parameter9*sin(2*f*pi*frequency_step(9)*t1(2*Fs+Fs+1:2*Fs+2*Fs)).*exp_envelope_two;
axes(handles.axes4);
plot(y1);
setappdata(handles.axes4,'y1',y1);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton1.
function pushbutton1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
y1=getappdata(handles.axes4,'y1');
Fs=8000;
sound(y1,Fs);
