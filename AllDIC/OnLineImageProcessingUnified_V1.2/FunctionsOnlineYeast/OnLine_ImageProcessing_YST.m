
%% On-line image processing core

% This script performs the necessary image processing tasks of 
% microfluidic experiment images to obtain the cell citrine levels in real
% time. It is divided in 4 sections, Addition of required libraries and
% functions, Generation of ROI indexes to cut images, On-Line processing
% and Off-line postprocessing (which in the future will be included
% on-line)
function [handles, INP, CitFreq, ident, datenow] = OnLine_ImageProcessing_YST(ident, mainDir, pDIC, bacpat, handles)

%% Include necessary paths for the tasks
addpath('FunctionsOnLine');
subs = genpath(mainDir);
addpath(subs);

%% Get index for ROI

answer1 = questdlg('Let''s proceed with the ROIs selection for cells?', ...
            'ROI Check', ...
            'Yes','No','none');

if strcmp(answer1, 'Yes')
    handles.Status.String{3} = 'Cutting Images';
    pause(0.5);
    
    cutcor = DICindexROI(pDIC);
    % cutcor = DICindexROIpre2018b(K);
    
    if isempty(cutcor)
        disp('Please, take a DIC image from the chamber and try again or check if the directory path is correct.')
        return
    end
    save([pDIC,'\ROIindexCells.mat'],'cutcor')
    
else
    handles.Status.String{3} = 'Image Processing Stopped  :(';
    return
end    

answer = questdlg('Is there a second position for the background?', ...
            'ROI Check', ...
            'Yes','No','none');
switch answer
    case 'Yes'
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [cutcorBACK1, cutcorBACK2] = DICindexROIBackground(bacpat); % SECOND POSITION
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'No'
        bacpat='';
        cutcorBACK1=[];
        cutcorBACK2=[];
end

%% On-line processing (during experiment)

% Get path of the file containing the input design
% disp('Select the text file containing the input design')
% [file1,path1] = uigetfile('*.txt');
inps = load('D:\AcquisitionDataRiddler\InputInfo.mat');
file1 = inps.filIn;
path1 = inps.dirIn;
try
    copyfile([path1,file1], [pDIC, '\..'])
catch
end

% Get the input values and step durations to compute the maximum time of
% the experiment in seconds
fid = fopen([path1,file1]);
inputs = strsplit(regexprep(fgetl(fid),'\t+',' '), ' ');
fclose(fid);
inputs = inputs(~cellfun('isempty',inputs));

% Maximum time of the experiment
maxt = str2double(inputs{1})*(length(inputs)-1);

DicFreq = exps.tis(2)/60;

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

handles.Status.String{3} = 'Checking for empty folders...';
answer2 = CheckEmptyFoldersP1(pDIC);

% Select location of the RSA file for the instance
% disp('Select the location of the RSA key file')
% [file2,path2] = uigetfile('*.pem');
RSA = 'D:\David\OED_invivo-master\ImageProcessing\ExtractFluorescenceMicrofluidics\lin002Test.pem';

%%%%%%%%%%%%%%%%%%%%% DEFINE VARIABLES %%%%%%%%%%%%%%%%%%%%%
IP = '129.215.193.4'; % Floating IP of the instance
Cmod = 'CChNewFin3'; % Name of the weights file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

WriteMacroSegmentation(pDIC,ident,IP,Cmod,RSA,cutcor); % Write macro ImageJ script for segmentation

% Background segmentation
if ~isempty(cutcorBACK1)
    CheckEmptyFoldersP2(bacpat, answer2);
    WriteMacroSegmentationBack(bacpat,ident,IP,Cmod,RSA,cutcorBACK1,cutcorBACK2);
    save([bacpat,'\CoordROIBackground.mat'],'cutcorBACK1', 'cutcorBACK2')
end

% Add ImageJ to the path
handles.Status.String{3} = 'Loading ImageJ ...';
pause(1)
addpath 'D:\David\fiji-win64\Fiji.app\scripts'
ImageJ;

% Generate Necessary Directories
GenDirectories(pDIC, cutcorBACK1,cutcorBACK2, bacpat)

try
    [ch,~] = size(exps.chans);
    for i=1:ch
        if strcmp(exps.chans{i,1}, 'mCitrineTeal') || strcmp(exps.chans{i,1}, 'mCitrineCyan')
            CitFreq = DicFreq*exps.chans{i,3};
        end
    end
catch
    CitFreq = DicFreq*exps.chans{2,3};
end

% Structures that will contain the temporary results for
% on-line check
tfluo = nan(2,(maxt)/(CitFreq*60));
save([pDIC,'\Segmentation\TemporaryFluorescence.mat'],'tfluo');
tBKGround = nan(1,(maxt)/(CitFreq*60));
save([pDIC,'\Segmentation\TemporaryBackground.mat'],'tBKGround');
tBKGroundS = nan(1,(maxt)/(CitFreq*60));
save([pDIC,'\Segmentation\TemporaryBackgroundShort.mat'],'tBKGroundS');
tSulf = nan(1,(maxt)/(CitFreq*60));
save([pDIC,'\Segmentation\TemporaryDye.mat'],'tSulf');
tBKGroundROI1 = nan(1,(maxt)/(CitFreq*60));
save([pDIC,'\Segmentation\TemporaryBackgroundROI1.mat'],'tBKGroundROI1');

if ~isempty(cutcorBACK1)
    cBacka = nan(1,(maxt)/(CitFreq*60));
    save([bacpat,'\SegmentationOne\TemporaryCellCount.mat'],'cBacka');
end
if ~isempty(cutcorBACK2)
    cBackb = nan(1,(maxt)/(CitFreq*60));
    save([bacpat,'\SegmentationTwo\TemporaryCellCount.mat'],'cBackb');
end

datenow = date;


switch char(java.lang.System.getProperty('user.name'))
    case {'David'}
        webPath = ['C:\Users\David\Dropbox\BacteriaMicrofluidicExperiments\',datenow,'_Microfluidics'];
    case {'s1778490'}
        webPath = ['C:\Users\s1778490\Dropbox\BacteriaMicrofluidicExperiments\',datenow,'_Microfluidics'];
    case {'lbandier'}
        webPath = ['C:\Users\Lucia\Dropbox\BacteriaMicrofluidicExperiments\',datenow,'_Microfluidics'];
end
    
try
    
    if ~exist(webPath,'dir')
        mkdir(webPath);
        addpath(webPath);
    end
    WriteWebSite_v2(webPath, ident);
    
catch
    warning('No access to Dropbox directory!');
end



t = timer;
t.Period = DicFreq*60; % Time delay in seconds
t.TasksToExecute = (maxt+150)/(DicFreq*60); % Number of times that the function will be executed
t.ExecutionMode = 'fixedRate';
t.TimerFcn = {@ImProcSegm,cutcor,pDIC,ident,INP,CitFreq,DicFreq,webPath,bacpat,cutcorBACK1,cutcorBACK2};



disp('                                                **                       ');
disp('                                            **********                   ');
disp('                                  ******************************         ');
disp('                         ************************************************');
disp('                        *      **      EXPERIMENT STARTED!      **      *');
disp('                         ************************************************');
      
handles.Status.String{3} = 'Image Processing Started  :)';
pause(1)

% % pause(300)% Wait 30 seconds for images to be taken
% start(t)
% % wait(t)
% pause(maxt+900)
% stop(t)
% 
% ExtractDataAsCSVOnLineTemp(pDIC, INP, CitFreq, ident);
% 
% % disp('Experiment Finished!')
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


handles.myTimer = t;
handles.maxt = maxt;




% %% Off-line processing (after experiment)
% 
% % Save necessary images in matlab structures to be used
% disp('Extracting necessary images.....')
% [CDs, CCs, Segs, BGMask] = SaveImgMat(pDIC,ident,CitFreq,DicFreq);
% disp('Finished!')
% 
% 
% % Move Indexed masks to the temporeraly directory
% if ~exist([pwd,'\Temp_Masks'],'dir')
%     mkdir([pwd,'\Temp_Masks']);
%     addpath([pwd,'\Temp_Masks']);
% end
% 
% if ~exist([pwd,'\Temp_Track'],'dir')
%     mkdir([pwd,'\Temp_Track']);
%     addpath([pwd,'\Temp_Track']);
% end
% 
% masks = [pDIC,'\Segmentation\Components\img_*'];
% copyfile(masks,'Temp_Masks')
% disp('Images Moved!')
% 
% % Perform cell trking with Lineage Mapper
% % Increase Java memory in Matlab --> https://imagej.net/MATLAB_Scripting
% LineageMapperTrackingOnLine(pDIC,ident);
% 
% % Check when tracking is finished
% Folder=['Temp_Track'];
% filePattern = fullfile(Folder, strcat('trk-img*'));
% Files2 = dir(filePattern);
% % Get number of frames for channel
% maxidT=length(Files2);
% 
% while length(Segs)~=maxidT
%     Files2 = dir(filePattern);
%     % Get number of frames for channel
%     maxidT=length(Files2);
% end
% 
% disp('Tracking Finished!')
% 
% 
% % Move tracking masks and empty Temp_Masks directory
% tempT = [pwd,'\Temp_Track\*'];
% finalT = [pDIC, '\Tracking'];
% 
% rmpath([pwd,'\Temp_Track\trk-lineage-viewer'])
% try
%     movefile(tempT, finalT)
% catch
%     disp('Issue with the tracking folder...')
% end
% delete([pwd,'\Temp_Masks\img_*'])
% disp('Masks moved')
% 
% 
% % Fluorescence data extraction
% 
% disp('Extracting Single-Cell fluorescence ...')
% [sct,sct2,scts] = SingleCellDataOnLine(pDIC,ident,CitFreq,DicFreq);
% disp('Finished!')
% 
% disp('Curating Traces ...')
% [dat,sct6,sct62] = SingleCellDataCurationOnLine(pDIC, ident,CitFreq,DicFreq);
% disp('Finished!')
% 
% 
% % Plot comparison between full traces and curated traces
% 
% fina = [];
% for i=1:length(sct62)
%     fina = [fina;sct62{i}];
% end
% 
% time = 0:CitFreq:(length(tfluo)-1)*CitFreq;
% figure
% hold on
% yyaxis left
% shadedErrorBar(time, dat(:,1)', dat(:,2)','lineprops', '-r','transparent', 0)
% shadedErrorBar(time, mean(fina,'omitnan'), std(fina, 'omitnan'),'lineprops', '-g','transparent', 1)
% 
% xlabel('time(min)')
% ylabel('Fluorescence (AU)')
% title(['All Cells (',num2str(length(sct2)),' traces) VS Final Filter (',num2str(length(sct6)),' traces)'])
% 
% yyaxis right
% stairs(INP(2,:), INP(1,:), 'b') % Input design
% ylabel('IPTG(uM)')
% 
% legend('All Cells', 'Filtered', 'Input')
% 
% hold off
% savefig([pDIC, '\',ident,'_FluorescencePlot.fig']);
% 
% % Make a CSV file containing the experimental data
% swt = timeIn(1:end-1)';
% ft = repelem(timeIn(end),length(swt))';
% iptg = inp(1:end-1)';
% datMat = [swt,ft,iptg];
% header = strings(1,3);
% header(1) = 'SwitchTime';
% header(2) = 'FinalTime';
% header(3) = 'IPTG';
% 
% % Write CSV file
% cHeader = num2cell(header); %dummy header
% for i=1:length(cHeader)
% cHeader{i} = char(cHeader{i});
% end
% textHeader = strjoin(cHeader, ',');
% 
% %write header to file
% fid = fopen([pDIC,'\',ident,'-Inputs.csv'],'w'); 
% fprintf(fid,'%s\n',textHeader);
% fclose(fid);
% %write data to end of file
% dlmwrite([pDIC,'\',ident,'-Inputs.csv'],datMat,'-append');
% 
% % Generate CSV files with the results of the experiment
% disp('Generating CSV files ...')
% ExtractDataAsCSVOnLine(pDIC, ident)
% disp('Finished!')
% 
% 
% disp('                         ************************************************');
% disp('                        *      **      EXPERIMENT FINISHED!      **      *');
% disp('                         ************************************************');
% disp('                                  ******************************         ');
% disp('                                            **********                   ');
% disp('                                                **                       ');
%      
%                  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 %      **      THE END      **      %
%                  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 


end



