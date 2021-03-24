%% On-line image processing core

% This script performs the necessary image processing tasks of 
% microfluidic experiment (bacteria) images to obtain the cell fluorescence levels in real
% time. It is divided in 4 sections, Addition of required libraries and
% functions, Generation of ROI indexes to cut images, On-Line processing
% and Off-line postprocessing (which in the future will be included
% on-line)


function [handles, mainDir, INP, CitFreq, ident, IndInf] = OnLine_ImageProcessing_Unif(ident, mainDir, CellDirs, BackDirs, handles)

%% Include necessary paths for the tasks
addpath('FunctionsOnLine');
if ~exist([mainDir,'\',ident,'_OutputFiles'],'dir')
    mkdir([mainDir,'\',ident,'_OutputFiles']);
    addpath([mainDir,'\',ident,'_OutputFiles']);
end

% Get directory of the experiment in the path
subs = genpath(mainDir);
addpath(subs);

% Save the paths for cells and background just in case
save([mainDir,'\',ident,'_OutputFiles\', 'CellDirectories.mat'],'CellDirs')
save([mainDir,'\',ident,'_OutputFiles\', 'BackgroundDirectories.mat'],'BackDirs')

%% Get index for ROIs

% Select directory where microscope images will be saved
handles.Status.String{3} = 'Checking for empty folders...';
answer23 = [];
switch handles.Device
    case 'Yeast'
        answer23 = CheckEmptyFoldersP1(CellDirs{1,1});
        CheckEmptyFoldersP2(BackDirs{1,1}, answer23);
    case 'Bacteria'
        answer23 = CheckEmptyFolders_Bact(CellDirs);
%         answer24 = CheckEmptyFolders_Bact(BackDirs);
end

switch handles.Device
    case 'Yeast'
        answer1 = questdlg('Let''s proceed with the ROIs selection for cells (Unless selection already exist)?', ...
                    'ROI Check', ...
                    'Yes','No','none');

        if strcmp(answer1, 'Yes')
            
            if strcmp(answer23, 'No') && isfile(([mainDir,'\',ident,'_OutputFiles', '\ROIindexCells.mat']))
                load([mainDir,'\',ident,'_OutputFiles', '\ROIindexCells.mat'],'cutcor')
            else
                handles.Status.String{3} = 'Cutting Images';
                pause(0.5);

                cutcor1 = DICindexROI(CellDirs{1,1});
                % cutcor = DICindexROIpre2018b(K);

                if isempty(cutcor1)
                    disp('Please, take a DIC image from the chamber and try again or check if the directory path is correct.')
                    return
                end
                cutcor{1,1} = cutcor1;
            
                save([mainDir,'\',ident,'_OutputFiles', '\ROIindexCells.mat'],'cutcor')
            end
            
        else
            handles.Status.String{3} = 'Image Processing Stopped  :(';
            return
        end    
        
        if strcmp(answer23, 'No') && isfile(([mainDir,'\',ident,'_OutputFiles', '\ROIindexBackground.mat']))
            load([mainDir,'\',ident,'_OutputFiles', '\ROIindexBackground.mat'],'cutcorBACK1', 'cutcorBACK2')
            cutcorBACK{1,1} = cutcorBACK1;
            cutcorBACK{1,2} = cutcorBACK2;
        else
            answer = questdlg('Is there a second position for the background?', ...
                        'ROI Check', ...
                        'Yes','No','none');
            switch answer
                case 'Yes'
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    [cutcorBACK1, cutcorBACK2] = DICindexROIBackground(BackDirs{1,1}); % SECOND POSITION
                    save([mainDir,'\',ident,'_OutputFiles', '\ROIindexBackground.mat'],'cutcorBACK1', 'cutcorBACK2')
                    cutcorBACK{1,1} = cutcorBACK1;
                    cutcorBACK{1,2} = cutcorBACK2;
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                case 'No'
                    bacpat='';
                    cutcorBACK1=[];
                    cutcorBACK2=[];
                    cutcorBACK{1,1} = cutcorBACK1;
                    cutcorBACK{1,2} = cutcorBACK2;
            end
        end
    case 'Bacteria'
        % ROIs with cells
        if strcmp(answer23, 'No') && isfile(([mainDir,'\',ident,'_OutputFiles', '\ROIindexCells.mat']))
            load([mainDir,'\',ident,'_OutputFiles', '\ROIindexCells.mat'],'cutcor')
        else
            answer1 = questdlg('Let''s proceed with the ROIs selection for cells (Unless selection already exist)?', ...
                        'ROI Check', ...
                        'Yes','No','none');

            if strcmp(answer1, 'Yes')
                handles.Status.String{3} = 'Cutting Images';
                pause(0.5);

                cutcor = DICindexROI_Bact(CellDirs);
                if isempty(cutcor{1,1})
                    disp('Please, take a DIC image from the chamber and try again or check if the directory path is correct.')
                    return
                end
                save([mainDir,'\',ident,'_OutputFiles', '\ROIindexCells.mat'],'cutcor')
            else
                handles.Status.String{3} = 'Image Processing Stopped  :(';
                return
            end    
        end


        % ROIs for background
        if strcmp(answer23, 'No') && isfile(([mainDir,'\',ident,'_OutputFiles', '\ROIindexBackground.mat']))
            load([mainDir,'\',ident,'_OutputFiles', '\ROIindexBackground.mat'],'cutcorBACK')
        else
            if ~isempty(BackDirs)
                answer2 = questdlg('Now, let''s proceed with the ROIs selection for background?', ...
                        'ROI Check', ...
                        'Yes','No','none');
                if strcmp(answer2, 'Yes')
                    cutcorBACK = DICindexROI_Bact(BackDirs);
                    if isempty(cutcorBACK{1,1})
                        disp('Please, take a DIC image from the chamber and try again or check if the directory path is correct.')
                        return
                    end
                    save([mainDir,'\',ident,'_OutputFiles', '\ROIindexBackground.mat'],'cutcorBACK')
                else
                    handles.Status.String{3} = 'Image Processing Stopped  :(';
                    return
                end    
            else
                cutcorBACK = [];
                save([mainDir,'\',ident,'_OutputFiles', '\ROIindexBackground.mat'],'cutcorBACK')
            end
        end
end

    
%% On-line processing (during experiment)
try
    exps = load('D:\AcquisitionDataRiddler\ExptInfo.mat');
catch

%         answer23 = CheckEmptyFoldersP1(CellDirs{1,1});
%         CheckEmptyFoldersP2(BackDirs{1,1}, answer23);
%     case 'Bacteria'
%         CheckEmptyFolders_Bact(CellDirs);
%         CheckEmptyFolders_Bact(BackDirs);
% end
    exps.dirs = '.';
    % Second entry indicates DICFreq (150=2.5min, 300 = 5 min, ...)
    
    exps.chans = cell(4,8);
    exps.chans{1,1} = 'DIC';
    exps.chans{1,2} = [30];
    exps.chans{1,3} = [1];
    exps.chans{1,4} = [0];
    exps.chans{1,5} = [1];
    exps.chans{1,6} = [2];
    exps.chans{1,7} = [270];
    exps.chans{1,8} = [100];
    
    switch handles.Device
        case 'Yeast'
            exps.tis = [1         150         576       86400];
            
            exps.chans{2,1} = 'mCitrineTeal';
            exps.chans{2,2} = [250];
            exps.chans{2,3} = [2];
            exps.chans{2,4} = [0];
            exps.chans{2,5} = [1];
            exps.chans{2,6} = [2];
            exps.chans{2,7} = [270];
            exps.chans{2,8} = [100];

            exps.chans{3,1} = 'cy5';
            exps.chans{3,2} = [50];
            exps.chans{3,3} = [2];
            exps.chans{3,4} = [0];
            exps.chans{3,5} = [1];
            exps.chans{3,6} = [2];
            exps.chans{3,7} = [270];
            exps.chans{3,8} = [100];

        case 'Bacteria'    
            exps.tis = [1         300         576       86400];
    
            exps.chans{2,1} = 'mKate2';
            exps.chans{2,2} = [250];
            exps.chans{2,3} = [1];
            exps.chans{2,4} = [0];
            exps.chans{2,5} = [1];
            exps.chans{2,6} = [2];
            exps.chans{2,7} = [270];
            exps.chans{2,8} = [100];

            exps.chans{3,1} = 'GFP';
            exps.chans{3,2} = [50];
            exps.chans{3,3} = [1];
            exps.chans{3,4} = [0];
            exps.chans{3,5} = [1];
            exps.chans{3,6} = [2];
            exps.chans{3,7} = [270];
            exps.chans{3,8} = [100];

            exps.chans{4,1} = 'cy5';
            exps.chans{4,2} = [50];
            exps.chans{4,3} = [1];
            exps.chans{4,4} = [0];
            exps.chans{4,5} = [1];
            exps.chans{4,6} = [2];
            exps.chans{4,7} = [270];
            exps.chans{4,8} = [100];
            
    end
end
% Get path of the file containing the input design
% disp('Select the text file containing the input design')
% [file1,path1] = uigetfile('*.txt');
try
    inps = load('D:\AcquisitionDataRiddler\InputInfo.mat');
    file1 = inps.filIn;
    path1 = inps.dirIn;
catch
    file1 = 'StepExample.txt';
    path1 = '.\';
end


% Get the input values and step durations to compute the maximum time of
% the experiment in seconds
fid = fopen([path1,'\',file1]);
inputs = strsplit(regexprep(fgetl(fid),'\t+',' '), ' ');
fclose(fid);
inputs = inputs(~cellfun('isempty',inputs));

% Maximum time of the experiment
maxt = str2double(inputs{1})*(length(inputs)-1);

DicFreq = exps.tis(2)/60;

try
    [ch,~] = size(exps.chans);
    for i=1:ch
        if strcmp(exps.chans{i,1}, 'GFP') || strcmp(exps.chans{i,1}, 'Sulforhodamine') || strcmp(exps.chans{i,1}, 'mCitrineCyan') ...
                || strcmp(exps.chans{i,1}, 'mCitrineTeal') || strcmp(exps.chans{i,1}, 'cy5') || strcmp(exps.chans{i,1}, 'mKate2')
            CitFreq = DicFreq*exps.chans{i,3};
            break
        end
    end
catch
    CitFreq = DicFreq*exps.chans{2,3};
end


% Matrix with inputs and corresponding time vector to be included in the
% final plot
timeIn=0:(str2double(inputs{1})/60):((str2double(inputs{1})/60)*(length(inputs)-1));
inp = zeros(1,length(timeIn));
for i=1:length(inputs)-1
    inp(i) = str2double(inputs{i+1});
end
inp(end) = str2double(inputs{length(inputs)});
INP = zeros(2,length(inp));
INP(1,:)=inp; INP(2,:)=timeIn;

% % Select directory where microscope images will be saved
% handles.Status.String{3} = 'Checking for empty folders...';
% 
% switch handles.Device
%     case 'Yeast'
%         answer23 = CheckEmptyFoldersP1(CellDirs{1,1});
%         CheckEmptyFoldersP2(BackDirs{1,1}, answer23);
%     case 'Bacteria'
%         CheckEmptyFolders_Bact(CellDirs);
%         CheckEmptyFolders_Bact(BackDirs);
% end


% Select location of the RSA file for the instance
% disp('Select the location of the RSA key file')
% [file2,path2] = uigetfile('*.pem');
RSA = 'D:\lin002Test.pem';

%%%%%%%%%%%%%%%%%%%%% DEFINE VARIABLES %%%%%%%%%%%%%%%%%%%%%
IP = '129.215.193.4'; % Floating IP of the instance
switch handles.Device
    case 'Yeast'
        Cmod = 'CChNewFin3'; % Name of the weights file
        WriteMacroSegmentation(CellDirs{1,1},ident,IP,Cmod,RSA,cutcor{1,1}); % Write macro ImageJ script for segmentation

        % Background segmentation
        if ~isempty(cutcorBACK{1,1})
            WriteMacroSegmentationBack(BackDirs{1,1},ident,IP,Cmod,RSA,cutcorBACK{1,1},cutcorBACK{1,2});
        end
        
    case 'Bacteria'
        Cmod = 'BacteriaGFPTest1'; % Name of the weights file
        WriteMacroSegmentationFluo_Bact(CellDirs,ident,IP,Cmod,RSA,cutcor); % Write macro ImageJ script for segmentation for cell directories
        WriteMacroSegmentationFluo_Bact(BackDirs,ident,IP,Cmod,RSA,cutcorBACK); % Write macro ImageJ script for segmentation for background directories
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% Add ImageJ to the path
handles.Status.String{3} = 'Loading ImageJ ...';
pause(1)
addpath 'D:\Fiji.app\scripts'
ImageJ;

switch handles.Device
    case 'Yeast' 
        % Generate Necessary Directories
        GenDirectories(CellDirs{1,1}, cutcorBACK{1,1},cutcorBACK{1,2}, BackDirs{1,1})
        
        % Structures that will contain the temporary results for
        % on-line check
        tfluo = nan(2,(maxt)/(CitFreq*60));
        save([mainDir,'\',ident,'_OutputFiles\TemporaryFluorescence.mat'],'tfluo');

        tBKGround = nan(1,(maxt)/(CitFreq*60));
        save([mainDir,'\',ident,'_OutputFiles\TemporaryBackground.mat'],'tBKGround');

        tBKGroundS = nan(1,(maxt)/(CitFreq*60));
        save([mainDir,'\',ident,'_OutputFiles\TemporaryBackgroundShort.mat'],'tBKGroundS');

        tSulf = nan(2,(maxt)/(CitFreq*60));
        save([mainDir,'\',ident,'_OutputFiles\TemporaryDye.mat'],'tSulf');

        tBKGroundROI1 = nan(1,(maxt)/(CitFreq*60));
        save([mainDir,'\',ident,'_OutputFiles\TemporaryBackgroundROI1.mat'],'tBKGroundROI1');
        
        singCell = cell(1,(maxt)/(CitFreq*60));
        save([mainDir,'\',ident,'_OutputFiles\TemporarySingleCellFluoCitrine.mat'],'singCell');
        
        sizeCell = cell(1,(maxt)/(CitFreq*60));
        save([mainDir,'\',ident,'_OutputFiles\TemporarySingleCellSize.mat'],'sizeCell');

        if ~isempty(cutcorBACK{1,1})
            cBacka = nan(1,(maxt)/(CitFreq*60));
            save([BackDirs{1,1},'\SegmentationOne\TemporaryCellCount.mat'],'cBacka');
        end
        if ~isempty(cutcorBACK{1,2})
            cBackb = nan(1,(maxt)/(CitFreq*60));
            save([BackDirs{1,1},'\SegmentationTwo\TemporaryCellCount.mat'],'cBackb');
        end

    case 'Bacteria'
        % Generate Necessary Directories
        GenDirectories_Bact(CellDirs, BackDirs)
        % Structures that will contain the temporary results for
        % on-line check

        % Where fluorescence is going to be saved. 1 is for GFP and 2 for RFP
        tfluo1 = nan(2,(maxt)/(CitFreq*60));
        save([mainDir,'\',ident,'_OutputFiles\TemporaryFluorescence1.mat'],'tfluo1');
        tfluo2 = nan(2,(maxt)/(CitFreq*60));
        save([mainDir,'\',ident,'_OutputFiles\TemporaryFluorescence2.mat'],'tfluo2');

        % Where background values from the background positions are going to be
        % saved
        GtBKGround = nan(1,(maxt)/(CitFreq*60));
        save([mainDir,'\',ident,'_OutputFiles\TemporaryBackgroundGFP.mat'],'GtBKGround');
        RtBKGround = nan(1,(maxt)/(CitFreq*60));
        save([mainDir,'\',ident,'_OutputFiles\TemporaryBackgroundRFP.mat'],'RtBKGround');
        GtBKGroundS = nan(1,(maxt)/(CitFreq*60));

        % Where the applied background to the cells is going to be saved (except if
        % it is the average of the past background)
        save([mainDir,'\',ident,'_OutputFiles\TemporaryBackgroundShortGFP.mat'],'GtBKGroundS');
        RtBKGroundS = nan(1,(maxt)/(CitFreq*60));
        save([mainDir,'\',ident,'_OutputFiles\TemporaryBackgroundShortRFP.mat'],'RtBKGroundS');

        % Where the fluorescence values for the dye are going to be saved
        tSulf = nan(2,(maxt)/(CitFreq*60));
        save([mainDir,'\',ident,'_OutputFiles\TemporaryDye.mat'],'tSulf');

        % Where the background from the cell images is going to be saved. 
        GtBKGroundROI1 = nan(length(CellDirs),(maxt)/(CitFreq*60));
        save([mainDir,'\',ident,'_OutputFiles\TemporaryBackgroundROI1GFP.mat'],'GtBKGroundROI1');
        RtBKGroundROI1 = nan(length(CellDirs),(maxt)/(CitFreq*60));
        save([mainDir,'\',ident,'_OutputFiles\TemporaryBackgroundROI1RFP.mat'],'RtBKGroundROI1');

        % Count of cells for the background images
        cBack = cell(1,length(BackDirs));
        for i=1:length(BackDirs)
            cBack{1,i} = nan(1,(maxt)/(CitFreq*60));
        end
        save([mainDir,'\',ident,'_OutputFiles\TemporaryCellCountBackground.mat'],'cBack');

        % Fluorescence values for each cell at each timepoint (all cell positions
        % together, so no distinction)
        singCellG = cell(length(CellDirs),(maxt)/(CitFreq*60));
        save([mainDir,'\',ident,'_OutputFiles\TemporarySingleCellFluoGFP.mat'],'singCellG');
        singCellR = cell(length(CellDirs),(maxt)/(CitFreq*60));
        save([mainDir,'\',ident,'_OutputFiles\TemporarySingleCellFluoRFP.mat'],'singCellR');
        
        sizeCellR = cell(length(CellDirs),(maxt)/(CitFreq*60));
        save([mainDir,'\',ident,'_OutputFiles\TemporarySingleCellSizeRFP.mat'],'sizeCellR');
        sizeCellG = cell(length(CellDirs),(maxt)/(CitFreq*60));
        save([mainDir,'\',ident,'_OutputFiles\TemporarySingleCellSizeGFP.mat'],'sizeCellG');
end




%% Create webpage to check experimental results on real time
datenow = date;

switch handles.Device
    case 'Yeast'
        fol = 'OEDinVivoMicrofluidicExperiments';
    case 'Bacteria'
        fol = 'BacteriaMicrofluidicExperiments';
end
webPath='';
switch char(java.lang.System.getProperty('user.name')) % Technically not required but just as a control to avoid other people overwitting things by accident
    case {'David'}
        webPath = ['C:\Users\',char(java.lang.System.getProperty('user.name')),'\Dropbox\',fol,'\',datenow,'_Microfluidics'];
    case {'s1778490'}
        webPath = ['C:\Users\',char(java.lang.System.getProperty('user.name')),'\Dropbox\',fol,'\',datenow,'_Microfluidics'];
    case {'lbandier'}
        webPath = ['C:\Users\Lucia\Dropbox\',fol,'\',datenow,'_Microfluidics'];
    case {'Lucia'}
        webPath = ['C:\Users\Lucia\Dropbox\',fol,'\',datenow,'_Microfluidics'];
end


try
    
    if ~exist(webPath,'dir')
        mkdir(webPath);
        addpath(webPath);
    end
    
    WriteWebSite_v3(ident, webPath, CellDirs, BackDirs, handles.Device);

catch
    warning('No access to Dropbox directory!');
end

%% 

Ind1 = nan(1,(maxt)/(CitFreq*60));
for i=1:length(INP(2,:))-1
    Ind1((INP(2,i)/CitFreq)+1:(INP(2,i+1)/CitFreq)) = INP(1,i);
end

switch handles.Device
    case 'Yeast'
        Ind2 = [];
        IndInf = [];
    case 'Bacteria'
        handles.Status.String{3} = 'Introduce Inputs Info';
        pause(1)

        % Information about inducers
        inp = InducersInfo;
        uiwait(inp);
        IndInf = load('TempFileInputs.mat', 'IndInf');
        IndInf = IndInf.IndInf;
        save([mainDir,'\',ident,'_OutputFiles\InfoInputs.mat'], 'IndInf');

        % Computation of the vector for the second inducer
        Ind2 = nan(1,(maxt)/(CitFreq*60));
        if ~isempty(IndInf.Inducer2)
            if strcmp(IndInf.Ind2Type,'Constant')
                for j=1:(maxt)/(CitFreq*60)
                    Ind2(j) = IndInf.Ind2Con;
                end
            elseif strcmp(IndInf.Ind2Type,'Complementary')
                ind1norm = Ind1/max(Ind1);
                ind2norm = 1-ind1norm;
                Ind2 = IndInf.Ind2Con * ind2norm;
            end
        else
            Ind2 = zeros(1,((maxt)/(CitFreq*60)));
        end
end


%% GET CHANNEL NAMES
try
    Chan.Flu1 = 'none';
    Chan.Flu2 = 'none';
    Chan.Dye = 'none';
    [ch,~] = size(exps.chans);
    for i=1:ch
        if strcmp(exps.chans{i,1}, 'GFP')
            Chan.Flu1 = 'GFP';
        elseif strcmp(exps.chans{i,1}, 'mCitrineTeal')
            Chan.Flu1 = 'mCitrineTeal';
        elseif strcmp(exps.chans{i,1}, 'mCitrineCyan')
            Chan.Flu1 = 'mCitrineCyan';
            
        elseif strcmp(exps.chans{i,1}, 'Sulforhodamine')
            Chan.Flu2 = 'Sulforhodamine';
        elseif strcmp(exps.chans{i,1}, 'mKate2')
            Chan.Flu2 = 'mKate2';
        elseif strcmp(exps.chans{i,1}, 'mCherry')
            Chan.Flu2 = 'mCherry';
            
        elseif strcmp(exps.chans{i,1}, 'cy5')
            Chan.Dye = 'cy5';
        end

    end
catch
    Chan.Flu1 = 'GFP';
    Chan.Flu2 = 'mKate2';
    Chan.Dye = 'cy5';
end


%% Image Processing call

% In case image processing starts late, all the big bulk at the beggining
% is not processed in the timer function
ImProcSegm_Unif([],[],cutcor,CellDirs,ident,INP,Ind2,CitFreq,DicFreq,BackDirs,cutcorBACK,mainDir,IndInf,Chan,webPath,handles.Device);

if isfolder('D:\AcquisitionDataRiddler')
    t = timer;
    t.Period = DicFreq*60; % Time delay in seconds
    t.TasksToExecute = (maxt+150)/(DicFreq*60); % Number of times that the function will be executed
    t.ExecutionMode = 'fixedSpacing'; % fixedRate

    t.TimerFcn = {@ImProcSegm_Unif,cutcor,CellDirs,ident,INP,Ind2,CitFreq,DicFreq,BackDirs,cutcorBACK,mainDir,IndInf,Chan,webPath,handles.Device};
    handles.tim = t;
end

disp('                                                **                       ');
disp('                                            **********                   ');
disp('                                  ******************************         ');
disp('                         ************************************************');
disp('                        *      **      EXPERIMENT STARTED!      **      *');
disp('                         ************************************************');
      

handles.Status.String{3} = 'Image Processing Started  :)';
pause(1)

% pause(300)% Wait 30 seconds for images to be taken
% start(t)
% % wait(t)
% pause(maxt+900)
% stop(t)
% 
% ExtractDataAsCSVOnLineTemp_Bact(mainDir, INP, CitFreq, ident, IndInf);
% 
% % disp('Experiment Finished!')
% handles.Status.String{3} = 'Image Processing Finished!  ;)';
% 
% disp('                         ************************************************');
% disp('                        *      **      EXPERIMENT FINISHED!      **      *');
% disp('                         ************************************************');
% disp('                                  ******************************         ');
% disp('                                            **********                   ');
% disp('                                                **                       ');
% 
% % Quit ImageJ
% ij.IJ.run("Quit","");

if isfolder('D:\AcquisitionDataRiddler')
    handles.myTimer = t;
    handles.maxt = maxt;
end
















end