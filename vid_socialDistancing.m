[filename,pathname]=uigetfile('*.*','Select the Input Video');
filewithpath=strcat(pathname,filename);
%I = imread(filewithpath);

videoReader = vision.VideoFileReader(filewithpath);
videoPlayer = vision.VideoPlayer('Position',[300 100 1200 500]);

detector = peopleDetectorACF('caltech-50x21');
%detector = peopleDetectorACF();
%writeObj = VideoWriter('New1.avi');
%writeObj.FrameRate = 8;
%open(writeObj);

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
%close(writeObj);

%save frames to video