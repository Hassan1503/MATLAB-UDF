classdef balanceData
    % Balance Data of Imgae datset
    % Split Image and csv Data
    methods(Static)
        %% Split Imds and save
        function []=splitImds(percent)
            arguments
                percent double  = 0.8
            end
            
            imds=imageDatastore(uigetdir(),"IncludeSubfolders",true,"LabelSource","foldernames");
            [train,test]=splitEachLabel(imds,percent); %split Data
            
            % Save Train image files
            files=readall(train);
            label=train.Labels;
            delete(gcp('nocreate'))
            parpool('threads')
            dir=uigetdir(matlabroot,"Select Folder to save image");
            for i=1:numel(label)
                folderName=string(label(i));
                imLoc=fullfile(dir,folderName);
                imFileName = strcat(folderName,'_',num2str(i),'.jpg');
                if ~exist( imLoc, 'dir')
                    mkdir( imLoc);
                end
                
                imwrite(files{i},fullfile(imLoc,imFileName));
            end
            delete(gcp('nocreate'))
            
            %             Save Test image files
            files=readall(test);
            label=test.Labels;
            delete(gcp('nocreate'))
            parpool('threads')
            dir=uigetdir(matlabroot,"Select Folder to save image");
            for i=1:numel(label)
                folderName=string(label(i));
                imLoc=fullfile(dir,folderName);
                imFileName = strcat(folderName,'_',num2str(i),'.jpg');
                if ~exist( imLoc, 'dir')
                    mkdir( imLoc);
                end
                
                imwrite(files{i},fullfile(imLoc,imFileName));
            end
            delete(gcp('nocreate'))
        end
        
        %%         Split csv Data
        function [Train,Test]=balanceCSVData(data,testSize,fileType)
            arguments
                data
                testSize double  = 0.2
                fileType string {mustBeMember(fileType,["csv","txt","dat","xls", "xlsm","xlsx","xlsb"])} = "csv" 
            end
            cv = cvpartition(size(data,1),"HoldOut",testSize);
            
            Train = data(cv.training,:) ;
            Test = data(cv.test,:) ;
            
            if fileType == "txt"
                writematrix(Train,"Train.txt")
                writematrix(Test,"Test.txt")
            elseif fileType == "csv"
                writematrix(Train,"Train.txt")
                writematrix(Test,"Test.txt")
            elseif fileType == "dat"
                writematrix(Train,"Train.dat")
                writematrix(Test,"Test.dat")
            elseif fileType == "xls"
                writematrix(Train,"Train.xls")
                writematrix(Test,"Test.xls")
            elseif fileType == "xlsm"
                writematrix(Train,"Train.xlsm")
                writematrix(Test,"Test.xlsm")
            elseif fileType == "xlsx"
                writematrix(Train,"Train.xlsx")
                writematrix(Test,"Test.xlsx")
            elseif fileType == "xlsb"
                writematrix(Train,"Train.xlsb")
                writematrix(Test,"Test.xlsb")
            end
        end
        
        %%         Balanced Image Data
        function []= balanceImageData(plot)
            arguments
                plot string {mustBeMember(plot,["Yes","No"])} = "Yes"
            end
            
            imds=imageDatastore(uigetdir(), ...
                'IncludeSubfolders',true,'LabelSource','foldernames');
            % labelCount = countEachLabel(imdsTrain);
            if plot == "Yes"
                histogram(imds.Labels);
                title('label frequency after balance');
            end
            labels=imds.Labels;
            [G,~] = findgroups(labels);
            numObservations = splitapply(@numel,labels,G);
            desiredNumObservationsPerClass = max(numObservations);
            files = splitapply(@(x){balanceData.randReplicateFiles(x,desiredNumObservationsPerClass)},imds.Files,G);
            files = vertcat(files{:});
            labels=[];
            info=strfind(files,'\');
            for i=1:numel(files)
                idx=info{i};
                dirName=files{i};
                targetStr=dirName(idx(end-1)+1:idx(end)-1);
                targetStr2=cellstr(targetStr);
                labels=[labels;categorical(targetStr2)];
            end
            imds.Files = files;
            imds.Labels=labels;
            % labelCount_oversampled = countEachLabel(imdsTrain);
            if plot =="Yes"
                histogram(imds.Labels);
                title('label frequency after balance');
            end
            %             read all image files and label
            files=readall(imds);
            label=imds.Labels;
            %             save the balance image datastore
            dir=uigetdir(matlabroot,"Select Folder to save image");
            delete(gcp('nocreate'))
            parpool('threads')
            for i=1:numel(label)
                folderName=string(label(i));
                imLoc=fullfile(dir,folderName);
                imFileName = strcat(folderName,'_',num2str(i),'.jpg');
                if ~exist( imLoc, 'dir')
                    mkdir( imLoc);
                end
                
                imwrite(files{i},fullfile(imLoc,imFileName));
            end
            delete(gcp('nocreate'))
        end
        
    end
    methods
        %% helper function
        function files = randReplicateFiles(files,numDesired)
            n = numel(files);
            ind = randi(n,numDesired,1);
            files = files(ind);
        end
    end
end
