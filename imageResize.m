function []=imageResize(options)

% % file initialize
% dir="C:\Users\hassa\Desktop\website\2d map\2d map"
% folderName="resizeNew"
% fileName="Image"
% imSize=[1294 1080]
arguments
    options.folderName (1,:) string {mustBeTextScalar}="New Folder"
    options.fileName (1,1) string {mustBeTextScalar}="Image"
    options.imSize (2,1) int64 {mustBeNumeric}=[1920 1080]
    options.imType (1,1) string {mustBeMember(options.imType,["jpg","png","tff","tfff","bmp","jpeg","gif","eps","raw","cr2","nef","orf","sr2"])}  ="jpg"
    options.replace (1,1) string {mustBeMember(options.replace,["Yes","No"])}="No"
end
%% 
% 
dir=uigetdir();
imds=imageDatastore(dir);

fig = uifigure;
d = uiprogressdlg(fig,'Title','Convert & Resize Image','Message','Opening the application');
d.ShowPercentage="on";
d.Cancelable="on";
d.CancelText="Stop";
pause(2)
d.Message = 'Loading Images';
% Cancellation
if d.CancelRequested
    close(d)
    fig.Visible="off";        
end
%% 
% 

% Load image files in imageDataStore
fileLocation=imds.Files;

imnew=readall(imds);
imgLoc = fullfile(dir,options.folderName);
l=length(imnew);


d.Value=1/l;
d.Message = 'Start Image Conversion & Resizing';
% Cancellation
if d.CancelRequested
    close(d)
    fig.Visible="off";        
end

for i=1:l
    d.Message = strcat('Fetching Image-',num2str(i));
    im=imnew{i,:};
    
    if options.replace=="Yes"
        imLocation=fileLocation{i};
    else
        imFileName = strcat(options.fileName,num2str(i),'.',options.imType);
        imLocation=fullfile(imgLoc,imFileName);
        
        if ~exist( imgLoc, 'dir')
            mkdir( imgLoc);
        end
    end
    d.Message = strcat('Processing Image--',num2str(i));
    imwrite(imresize(im,options.imSize),fullfile(imLocation));
%     strcat("complete: ",imFileName)
    d.Value=(i-1)/l;
    % Cancellation
    if d.CancelRequested
        close(d)
        fig.Visible="off";
    end    
end

d.Message = 'Finished';
pause(1)
close(d)
fig.Visible='off';
winopen(imgLoc);

end