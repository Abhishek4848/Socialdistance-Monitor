function varargout = window_gui(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @window_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @window_gui_OutputFcn, ...
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

function window_gui_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

function varargout = window_gui_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function img_upload_Callback(hObject, eventdata, handles)
[filename,pathname]=uigetfile('*.*','Select the Input Image');
filewithpath=strcat(pathname,filename);
I = imread(filewithpath);
detector = peopleDetectorACF();
[bboxes,scores] = detect(detector,I);
axes(handles.axes1);
cond = zeros(size(bboxes,1),1);
if ~isempty(bboxes)
    for i=1:(size(bboxes,1)-1)
        for j=(i+1):(size(bboxes,1)-1)
             dis1_v = abs(bboxes(i,1)+bboxes(i,3)-bboxes(j,1));
             dis2_v = abs(bboxes(j,1)+bboxes(j,3)-bboxes(i,1));
             dis1_h = abs(bboxes(i,2)-bboxes(j,2));
             dis2_h = abs(bboxes(i,2)+bboxes(i,4)-bboxes(j,2)-bboxes(j,4));
             if((dis1_v<75 || dis2_v<75) && (dis1_h<50 || dis2_h<50))
                cond(i)=cond(i)+1;
                cond(j)=cond(j)+1;
             else
                cond(i)=cond(i)+0; 
             end
        end
    end
end
I = insertObjectAnnotation(I,'rectangle',bboxes((cond>0),:),'danger','color','r');
I = insertObjectAnnotation(I,'rectangle',bboxes((cond==0),:),'safe','color','g');
imshow(I)


% --- Executes on button press in vid_upload.
function vid_upload_Callback(hObject, eventdata, handles)
[filename,pathname]=uigetfile('*.*','Select the Input Video');
filewithpath=strcat(pathname,filename);
videoReader = vision.VideoFileReader(filewithpath);
videoPlayer = vision.VideoPlayer('Position',[300 100 1200 500]);

detector = peopleDetectorACF('caltech-50x21');
%detector = peopleDetectorACF();

while ~isDone(videoReader)
    frame = step(videoReader);
    I=double(frame);
    [bboxes,scores] = detect(detector,I);
    
    cond = zeros(size(bboxes,1),1);
    if ~isempty(bboxes)
        for i=1:(size(bboxes,1)-1)
            for j=(i+1):(size(bboxes,1)-1)
                 dis1_v = abs(bboxes(i,1)+bboxes(i,3)-bboxes(j,1));
                 dis2_v = abs(bboxes(j,1)+bboxes(j,3)-bboxes(i,1));
                 dis1_h = abs(bboxes(i,2)-bboxes(j,2));
                 dis2_h = abs(bboxes(i,2)+bboxes(i,4)-bboxes(j,2)-bboxes(j,4));
                 if((dis1_v<75 || dis2_v<75) && (dis1_h<50 || dis2_h<50))
                    cond(i)=cond(i)+1;
                    cond(j)=cond(j)+1;
                 else
                    cond(i)=cond(i)+0; 
                 end
            end
        end
    end
    I = insertObjectAnnotation(I,'rectangle',bboxes((cond>0),:),'danger','color','r');
    I = insertObjectAnnotation(I,'rectangle',bboxes((cond==0),:),'safe','color','g');
        
    step(videoPlayer,I);  
    %frame = im2frame(I);
    %writeVideo(writeObj,frame);
end
release(videoReader);
release(videoPlayer);

function countryName_Callback(hObject, eventdata, handles)
url = 'https://www.worldometers.info/coronavirus/country/';
cntry = get(handles.countryName,'String');
cntryURL = strcat(url,cntry);
target = 'Coronavirus Cases:';
confCases = urlfilter(cntryURL,target);
set(handles.caseDisplay,'String',confCases);
target2 = 'Deaths:';
dead = urlfilter(cntryURL,target2);
set(handles.deathDisplay,'String',dead);
target3 = 'Recovered:';
recov = urlfilter(cntryURL,target3);
set(handles.recoverDisplay,'String',recov);

% --- Executes during object creation, after setting all properties.
function countryName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to countryName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function caseDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to caseDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function deathDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deathDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function recoverDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to recoverDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
