# Socialdistance Monitor
Real-time Social Distancing Monitoring using MATLAB

## Description of modules:
  1. peopleDetectorACF( ): peopleDetectorACF returns a pretrained upright people
  detector using aggregate channel features (ACF). The detector is an
  acfObjectDetector object, and is trained using the INRIA person data set.
  2. insertObjectAnnotation( ): Annotate detected people with bounding boxes and
  display the person’s risk of Covid transmissibility
  3. vision.VideoFileReader( ): returns a video file reader System object,
  videoFReader, that sequentially reads video frames or audio samples from an
  input file
  4. vision.VideoPlayer( ): returns a video player object, videoPlayer, for displaying
  video frames
  5. URL Filter: Used to scrape data from a webpage
  
## Outputs
![Output1](https://github.com/Abhishek4848/Socialdistance-Monitor/blob/main/output1.png)

![Output2](https://github.com/Abhishek4848/Socialdistance-Monitor/blob/main/output2.png)
