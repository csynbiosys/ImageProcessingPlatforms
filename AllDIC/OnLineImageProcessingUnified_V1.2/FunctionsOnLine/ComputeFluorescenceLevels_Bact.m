%% 
function [tfluo1,tfluo2,GtBKGround,RtBKGround,GtBKGroundS,RtBKGroundS,singCellG,singCellR,sizeCell] = ComputeFluorescenceLevels_Bact ...
    (tfluo1,tfluo2,GtBKGround,RtBKGround,GtBKGroundS,RtBKGroundS,singCellG,singCellR, sizeCell, cutcorBACK, CitFreq, DicFreq, maxidD, Chan, CellDirs, ...
    BackDirs, cBack, mainDir, maxidF1, maxidF2, maxidF1b, maxidF2b, tempse, ident)


if isempty(cutcorBACK)
    r = 1:CitFreq/DicFreq:min(cell2mat(maxidD)); % You take the min of each channel to consider the case that the images of one possition might not have been processed yet. 
    
    if strcmp(Chan.Flu1, 'none')% Check if there is a secon fluorescence protein been measure, if so consider the minimum index for both (to take into account that one possition has not been processed yet). If not, then only consider the indexes for protein 1. 
        fluoind = min(cell2mat(maxidF2));
    elseif strcmp(Chan.Flu2, 'none')
        fluoind = min(cell2mat(maxidF1));
    elseif ~strcmp(Chan.Flu1, 'none') && ~strcmp(Chan.Flu2, 'none')
        fluoind = min(min(cell2mat(maxidF1)), min(cell2mat(maxidF2))); 
    else
        fluoind = [];
    end
    [le, ~] = size(GtBKGround); % If this is the case, it is the first iteration, so we will append as many rows as positions with cells
    if le==1
        for h = 2:length(CellDirs)
            GtBKGround(h,:)=nan;
            RtBKGround(h,:)=nan;
            GtBKGroundS(h,:)=nan;
            RtBKGroundS(h,:)=nan;
        end
    end
        
    for i=1:fluoind
        if isnan(tfluo1(1,i)) || isnan(tfluo2(1,i))
            num = num2str(r(i),'%.3u');
            for di=1:length(CellDirs)
                filePattern4 = fullfile([CellDirs{1,di},'\Segmentation'], 'exp*DIC_001.tif');
                Files4 = dir(filePattern4);
                
                tBKG=imread([CellDirs{1,di},'\Segmentation\BKG-',Files4(r(i)).name]); % Background image
                tSegs=imread([CellDirs{1,di},'\Segmentation\Components\img_',num,'.tif']); % Mask
                
                if ~strcmp(Chan.Flu1, 'none') && ~strcmp(Chan.Flu2, 'none') % 2 fluorescent proteins present
                    tGFP=double(imread([CellDirs{1,di},'\CutFluo1\exp_000',num,'_',Chan.Flu1,'_001.png'])); % Cut GFP image
                    tRFP=double(imread([CellDirs{1,di},'\CutFluo2\exp_000',num,'_',Chan.Flu2,'_001.png'])); % Cut RFP image
                elseif ~strcmp(Chan.Flu1, 'none') && strcmp(Chan.Flu2, 'none') % Only GFP measured
                    tGFP=double(imread([CellDirs{1,di},'\CutFluo1\exp_000',num,'_',Chan.Flu1,'_001.png'])); % Cut GFP image
                    tRFP=nan(size(tSegs)); % Cut RFP image
                elseif strcmp(Chan.Flu1, 'none') && ~strcmp(Chan.Flu2, 'none') % Only RFP measured
                    tGFP=nan(size(tSegs)); % Cut GFP image
                    tRFP=double(imread([CellDirs{1,di},'\CutFluo2\exp_000',num,'_',Chan.Flu2,'_001.png'])); % Cut RFP image
                end
                
                % Compute Background intensity
                GtBKGround(di,i)=mean(tGFP(logical(tBKG))); % Compute Background
                RtBKGround(di,i)=mean(tRFP(logical(tBKG))); % Compute Background

                [a,b] = size(tSegs); % Compute percentage of pixels from background
                if all(isnan(tRFP(:)))
                    np = length(tGFP(logical(tBKG)==1));
                elseif all(isnan(tGFP(:)))
                    np = length(tRFP(logical(tBKG)==1));
                else 
                    np = length(tGFP(logical(tBKG)==1));
                end

                
                if (np/(a*b)) > 0.50
                    GtBKGroundS(di,i)=GtBKGround(di,i);   % Save background value if condition is meet for the exception 
                    RtBKGroundS(di,i)=RtBKGround(di,i);   % Save background value if condition is meet for the exception 
                    
                    me1G = nan(1,length(unique(tSegs))-1); % Store mean fluorescence values per cell
                    me1R = nan(1,length(unique(tSegs))-1); % Store mean fluorescence values per cell
                    siz = nan(1,length(unique(tSegs))-1); % Store mean fluorescence values per cell
                    for j=1:(length(unique(tSegs))-1)
                        me1G(j)=mean(tGFP(tSegs==j)-GtBKGround(di,i),'omitnan');
                        me1R(j)=mean(tRFP(tSegs==j)-RtBKGround(di,i),'omitnan');
                        siz(j)=length(tSegs(tSegs==j));
                    end
                    singCellG{di,i} = me1G;
                    singCellR{di,i} = me1R;
                    sizeCell{di,i} = siz;

                else
                    me1G = nan(1,length(unique(tSegs))-1); % Store mean fluorescence values per cell
                    me1R = nan(1,length(unique(tSegs))-1); % Store mean fluorescence values per cell
                    siz = nan(1,length(unique(tSegs))-1); % Store mean fluorescence values per cell
                    for j=1:(length(unique(tSegs))-1)
                        me1G(j)=mean(tGFP(tSegs==j)-mean(GtBKGroundS(di,1:end),'omitnan'),'omitnan');
                        me1R(j)=mean(tRFP(tSegs==j)-mean(RtBKGroundS(di,1:end),'omitnan'),'omitnan');
                        siz(j)=length(tSegs(tSegs==j));
                    end
                    singCellG{di,i} = me1G;
                    singCellR{di,i} = me1R;
                    sizeCell{di,i} = siz;

                end
            end
            tfluo1(1,i)=mean([singCellG{:,i}],'omitnan');
            tfluo1(2,i)=std([singCellG{:,i}],'omitnan');
            tfluo2(1,i)=mean([singCellR{:,i}],'omitnan');
            tfluo2(2,i)=std([singCellR{:,i}],'omitnan');
        end
    end
else
    r = 1:CitFreq/DicFreq:min(cell2mat(maxidD)); % You take the min of each channel to consider the case that the images of one possition might not have been processed yet. 
    
    if strcmp(Chan.Flu1, 'none')% Check if there is a secon fluorescence protein been measure, if so consider the minimum index for both (to take into account that one possition has not been processed yet). If not, then only consider the indexes for protein 1. 
        fluoindB = min(cell2mat(maxidF2b));
    elseif strcmp(Chan.Flu2, 'none')
        fluoindB = min(cell2mat(maxidF1b));
    elseif ~strcmp(Chan.Flu1, 'none') && ~strcmp(Chan.Flu2, 'none')
        fluoindB = min(min(cell2mat(maxidF1b)), min(cell2mat(maxidF2b))); 
    else
        fluoindB = [];
    end
    
    % Extract background values
    for i=1:fluoindB
        if isnan(GtBKGround(1,i)) || isnan(RtBKGround(1,i))
            num = num2str(r(i),'%.3u');
            ALLroundG = [];
            ALLroundR = [];
            for bi=1:length(BackDirs)
                filePattern4 = fullfile([BackDirs{1,bi},'\Segmentation'], 'exp*DIC_001.tif');
                Files4 = dir(filePattern4);
                
                tSegsBACK=imread([BackDirs{1,bi},'\Segmentation\',Files4(r(i)).name]); % Background Mask
                
                if ~strcmp(Chan.Flu1, 'none') && ~strcmp(Chan.Flu2, 'none') % 2 fluorescent proteins present
                    tGFPBACK=double(imread([BackDirs{1,bi},'\CutFluo1\exp_000',num,'_',Chan.Flu1,'_001.png'])); % Cut GFP image
                    tRFPBACK=double(imread([BackDirs{1,bi},'\CutFluo2\exp_000',num,'_',Chan.Flu2,'_001.png'])); % Cut RFP image
                elseif ~strcmp(Chan.Flu1, 'none') && strcmp(Chan.Flu2, 'none') % Only GFP measured
                    tGFPBACK=double(imread([BackDirs{1,bi},'\CutFluo1\exp_000',num,'_',Chan.Flu1,'_001.png'])); % Cut GFP image
                    tRFPBACK=nan(size(tSegsBACK)); % Cut RFP image
                elseif strcmp(Chan.Flu1, 'none') && ~strcmp(Chan.Flu2, 'none') % Only RFP measured
                    tGFPBACK=nan(size(tSegsBACK)); % Cut GFP image
                    tRFPBACK=double(imread([BackDirs{1,bi},'\CutFluo2\exp_000',num,'_',Chan.Flu2,'_001.png'])); % Cut RFP image
                end

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Patch for segmentation issues when there is no cells
                firdrop = find((cBack{1,bi}<100)==1); 
                if isempty(firdrop)
                    firdrop=inf;
                end

                if i<360/CitFreq && cBack{1,bi}(i)>100 
                    tSegsBACK=tSegsBACK*0;
%                 elseif i>=360/CitFreq && firdrop(1)>=i %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% THIS MIGHT NOT BE NEDDED,DEPEND ON HOW THE WAIGHTS WORK
%                     tSegsBACK=tSegsBACK*0; 
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                tSegsBACK = imdilate(tSegsBACK,tempse); % Add extra pixels around cells
                % Compute Background intensity
                
                [a,b] = size(tSegsBACK); % Compute percentage of pixels from background
                if all(isnan(tRFPBACK(:)))
                    np = length(tGFPBACK(logical(tSegsBACK)==0));
                elseif all(isnan(tGFPBACK(:)))
                    np = length(tRFPBACK(logical(tSegsBACK)==0));
                else 
                    np = length(tGFPBACK(logical(tSegsBACK)==0));
                end
                
                if (np/(a*b))>=0.40
                    ALLroundG=[ALLroundG; tGFPBACK(tSegsBACK==0)]; % Compute Background
                    ALLroundR=[ALLroundR; tRFPBACK(tSegsBACK==0)]; % Compute Background
                else 
                    ALLroundG=[ALLroundG; 0]; % Add zero instead of Nan so the loop will not process this time point each time
                    ALLroundR=[ALLroundR; 0]; 
                end
                
            end
            GtBKGround(1,i) = mean(ALLroundG,'omitnan'); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CHECK FOR FIRST 0 AND MAKE ALL THE REST 0?
            RtBKGround(1,i) = mean(ALLroundR,'omitnan');
        end
    end
    
    % Cell Fluorescence extraction
    if strcmp(Chan.Flu1, 'none')% Check if there is a secon fluorescence protein been measure, if so consider the minimum index for both (to take into account that one possition has not been processed yet). If not, then only consider the indexes for protein 1. 
        fluoind = min(cell2mat(maxidF2));
    elseif strcmp(Chan.Flu2, 'none')
        fluoind = min(cell2mat(maxidF1));
    elseif ~strcmp(Chan.Flu1, 'none') && ~strcmp(Chan.Flu2, 'none')
        fluoind = min(min(cell2mat(maxidF1)), min(cell2mat(maxidF2))); 
    else
        fluoind = [];
    end
    
    for i=1:fluoind
        if (isnan(tfluo1(1,i)) || isnan(tfluo2(1,i))) && (~isnan(GtBKGround(1,i)) || ~isnan(RtBKGround(1,i)))
            num = num2str(r(i),'%.3u');
            for di=1:length(CellDirs)
                filePattern4 = fullfile([CellDirs{1,di},'\Segmentation'], 'exp*DIC_001.tif');
                Files4 = dir(filePattern4);
            
                tSegs=imread([CellDirs{1,di},'\Segmentation\Components\img_',num,'.tif']); % Mask
                tBKG=imread([CellDirs{1,di},'\Segmentation\BKG-',Files4(r(i)).name]); % Background image
                
                if ~strcmp(Chan.Flu1, 'none') && ~strcmp(Chan.Flu2, 'none') % 2 fluorescent proteins present
                    tGFP=double(imread([CellDirs{1,di},'\CutFluo1\exp_000',num,'_',Chan.Flu1,'_001.png'])); % Cut GFP image
                    tRFP=double(imread([CellDirs{1,di},'\CutFluo2\exp_000',num,'_',Chan.Flu2,'_001.png'])); % Cut RFP image
                elseif ~strcmp(Chan.Flu1, 'none') && strcmp(Chan.Flu2, 'none') % Only GFP measured
                    tGFP=double(imread([CellDirs{1,di},'\CutFluo1\exp_000',num,'_',Chan.Flu1,'_001.png'])); % Cut GFP image
                    tRFP=nan(size(tSegs)); % Cut RFP image
                elseif strcmp(Chan.Flu1, 'none') && ~strcmp(Chan.Flu2, 'none') % Only RFP measured
                    tGFP=nan(size(tSegs)); % Cut GFP image
                    tRFP=double(imread([CellDirs{1,di},'\CutFluo2\exp_000',num,'_',Chan.Flu2,'_001.png'])); % Cut RFP image
                end
                
                load([mainDir,'\',ident,'_OutputFiles\TemporaryBackgroundROI1GFP.mat'],'GtBKGroundROI1');
                load([mainDir,'\',ident,'_OutputFiles\TemporaryBackgroundROI1RFP.mat'],'RtBKGroundROI1');
                
                GtBKGroundROI1(di,i)=mean(tGFP(logical(tBKG)), 'omitnan'); % Compute Background
                RtBKGroundROI1(di,i)=mean(tRFP(logical(tBKG)), 'omitnan'); % Compute Background
                
                save([mainDir,'\',ident,'_OutputFiles\TemporaryBackgroundROI1GFP.mat'],'GtBKGroundROI1');
                save([mainDir,'\',ident,'_OutputFiles\TemporaryBackgroundROI1RFP.mat'],'RtBKGroundROI1');
                
                [a1,b1] = size(tSegs); % Compute percentage of pixels from background                
                if all(isnan(tRFP(:)))
                    np1 = length(tGFP(logical(tBKG)==1));
                elseif all(isnan(tGFP(:)))
                    np1 = length(tRFP(logical(tBKG)==1));
                else 
                    np1 = length(tGFP(logical(tBKG)==1));
                end
                
                
                % Compute Background intensity
                if np1/(a1*b1)>0.75 % If there is enough background in the cell images, take that
                    GtBKGroundS(1,i)=GtBKGroundROI1(di,i);   % Save background value if condition is meet for the exception 
                    RtBKGroundS(1,i)=RtBKGroundROI1(di,i);   % Save background value if condition is meet for the exception 
                    
                    me1G = nan(1,length(unique(tSegs))-1); % Store mean fluorescence values per cell
                    me1R = nan(1,length(unique(tSegs))-1); % Store mean fluorescence values per cell
                    siz = nan(1,length(unique(tSegs))-1); % Store mean fluorescence values per cell
                    for j=1:(length(unique(tSegs))-1)
                        me1G(j)=mean(tGFP(tSegs==j)-GtBKGroundROI1(di,i),'omitnan');
                        me1R(j)=mean(tRFP(tSegs==j)-RtBKGroundROI1(di,i),'omitnan');
                        siz(j) =length(tSegs(tSegs==j));
                    end
                    singCellG{di,i} = me1G;
                    singCellR{di,i} = me1R;
                    sizeCell{di,i} = siz;
                else % GFP and RFP separated since if one of the two channels is not used, then the script would stop for the other as well
                    
                    % GFP
                    if (GtBKGround(1,i)~=0) && ~isnan(GtBKGround(1,i)) % If there is enough background pixels in the background images
                        
                        GtBKGroundS(1,i)=GtBKGround(1,i);   % Save background value if condition is meet for the exception 
                        me1G = nan(1,length(unique(tSegs))-1); % Store mean fluorescence values per cell
                        siz = nan(1,length(unique(tSegs))-1); % Store mean fluorescence values per cell
                        for j=1:(length(unique(tSegs))-1)
                            me1G(j)=mean(tGFP(tSegs==j)-GtBKGround(1,i),'omitnan');
                            siz(j) =length(tSegs(tSegs==j));
                        end
                        singCellG{di,i} = me1G;
                        sizeCell{di,i} = siz;
                    else % If there is not enough background anywere, just take the average of the past
                        
                        me1G = nan(1,length(unique(tSegs))-1); % Store mean fluorescence values per cell
                        siz = nan(1,length(unique(tSegs))-1); % Store mean fluorescence values per cell
                        for j=1:(length(unique(tSegs))-1)
                            me1G(j)=mean(tGFP(tSegs==j)-mean(GtBKGroundS(1,:),'omitnan'),'omitnan');
                            siz(j) =length(tSegs(tSegs==j));
                        end
                        singCellG{di,i} = me1G;
                        sizeCell{di,i} = siz;
                    end
                    
                    % RFP
                    if (RtBKGround(1,i)~=0) && ~isnan(RtBKGround(1,i))
                        
                        RtBKGroundS(1,i)=RtBKGround(1,i);   % Save background value if condition is meet for the exception 
                        me1R = nan(1,length(unique(tSegs))-1); % Store mean fluorescence values per cell
                        siz = nan(1,length(unique(tSegs))-1); % Store mean fluorescence values per cell
                        for j=1:(length(unique(tSegs))-1)
                            me1R(j)=mean(tRFP(tSegs==j)-GtBKGround(1,i),'omitnan');
                            siz(j) =length(tSegs(tSegs==j));
                        end
                        singCellR{di,i} = me1R;
                        sizeCell{di,i} = siz;

                    else
                        me1R = nan(1,length(unique(tSegs))-1); % Store mean fluorescence values per cell
                        siz = nan(1,length(unique(tSegs))-1); % Store mean fluorescence values per cell
                        for j=1:(length(unique(tSegs))-1)
                            me1R(j)=mean(tRFP(tSegs==j)-mean(RtBKGroundS(1,:),'omitnan'),'omitnan');
                            siz(j) =length(tSegs(tSegs==j));
                        end
                        singCellR{di,i} = me1R;
                        sizeCell{di,i} = siz;
                    end
                end

            end
            tfluo1(1,i)=mean([singCellG{:,i}],'omitnan');
            tfluo1(2,i)=std([singCellG{:,i}],'omitnan');
            tfluo2(1,i)=mean([singCellR{:,i}],'omitnan');
            tfluo2(2,i)=std([singCellR{:,i}],'omitnan');
        end
    end    

end







end