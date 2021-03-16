%% 
function [tfluo1,tfluo2,GtBKGround,RtBKGround,GtBKGroundS,RtBKGroundS,singCellG,singCellR,sizeCellG,sizeCellR] = ComputeFluorescenceLevels_Bact ...
    (tfluo1,tfluo2,GtBKGround,RtBKGround,GtBKGroundS,RtBKGroundS,singCellG,singCellR, sizeCellG, sizeCellR, cutcorBACK, CitFreq, DicFreq, maxidD, Chan, CellDirs, ...
    BackDirs, cBack, mainDir, maxidF1, maxidF2, maxidF1b, maxidF2b, tempse, ident)

% a=GFP, b=RFP
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
                filePattern4a = fullfile([CellDirs{1,di},'\Segmentation'], 'exp*GFP_001.tif');
                filePattern4b = fullfile([CellDirs{1,di},'\Segmentation'], 'exp*mKate2_001.tif');
                
                Files4a = dir(filePattern4a);
                Files4b = dir(filePattern4b);
                
                tBKGa=imread([CellDirs{1,di},'\Segmentation\BKG-',Files4a(r(i)).name]); % Background image
                tBKGb=imread([CellDirs{1,di},'\Segmentation\BKG-',Files4b(r(i)).name]);
                tSegsa=imread([CellDirs{1,di},'\Segmentation\Components\imgG_',num,'.tif']); % Mask
                tSegsb=imread([CellDirs{1,di},'\Segmentation\Components\imgR_',num,'.tif']);
                
                if ~strcmp(Chan.Flu1, 'none') && ~strcmp(Chan.Flu2, 'none') % 2 fluorescent proteins present
                    tGFP=double(imread([CellDirs{1,di},'\CutFluo1\exp_000',num,'_',Chan.Flu1,'_001.png'])); % Cut GFP image
                    tRFP=double(imread([CellDirs{1,di},'\CutFluo2\exp_000',num,'_',Chan.Flu2,'_001.png'])); % Cut RFP image
                elseif ~strcmp(Chan.Flu1, 'none') && strcmp(Chan.Flu2, 'none') % Only GFP measured
                    tGFP=double(imread([CellDirs{1,di},'\CutFluo1\exp_000',num,'_',Chan.Flu1,'_001.png'])); % Cut GFP image
                    tRFP=nan(size(tSegsb)); % Cut RFP image
                elseif strcmp(Chan.Flu1, 'none') && ~strcmp(Chan.Flu2, 'none') % Only RFP measured
                    tGFP=nan(size(tSegsa)); % Cut GFP image
                    tRFP=double(imread([CellDirs{1,di},'\CutFluo2\exp_000',num,'_',Chan.Flu2,'_001.png'])); % Cut RFP image
                end
                
                % Compute Background intensity
                GtBKGround(di,i)=mean(tGFP(logical(tBKGa))); % Compute Background
                RtBKGround(di,i)=mean(tRFP(logical(tBKGb))); % Compute Background

                [a,b] = size(tSegsa); % Compute percentage of pixels from background
                if all(isnan(tRFP(:)))
                    np = length(tGFP(logical(tBKGa)==1));
                elseif all(isnan(tGFP(:)))
                    np = length(tRFP(logical(tBKGa)==1));
                else 
                    np = length(tGFP(logical(tBKGa)==1));
                end

                
                if (np/(a*b)) > 0.50
                    GtBKGroundS(di,i)=GtBKGround(di,i);   % Save background value if condition is meet for the exception 
                    RtBKGroundS(di,i)=RtBKGround(di,i);   % Save background value if condition is meet for the exception 
                    
                    me1G = nan(1,length(unique(tSegsa))-1); % Store mean fluorescence values per cell
                    me1R = nan(1,length(unique(tSegsb))-1); % Store mean fluorescence values per cell
                    siza = nan(1,length(unique(tSegsa))-1); % Store mean fluorescence values per cell
                    sizb = nan(1,length(unique(tSegsa))-1);
                    for j=1:(length(unique(tSegsa))-1)
                        me1G(j)=mean(tGFP(tSegsa==j)-GtBKGround(di,i),'omitnan');
                        siza(j)=length(tSegsa(tSegsa==j));
                    end
                    for j=1:(length(unique(tSegsb))-1)
                        me1R(j)=mean(tRFP(tSegsb==j)-RtBKGround(di,i),'omitnan');
                        sizb(j)=length(tSegsb(tSegsb==j));
                    end
                    singCellG{di,i} = me1G;
                    singCellR{di,i} = me1R;
                    sizeCellG{di,i} = siza;
                    sizeCellR{di,i} = sizb;

                else
                    me1G = nan(1,length(unique(tSegsa))-1); % Store mean fluorescence values per cell
                    me1R = nan(1,length(unique(tSegsb))-1); % Store mean fluorescence values per cell
                    siza = nan(1,length(unique(tSegsa))-1); % Store mean fluorescence values per cell
                    sizb = nan(1,length(unique(tSegsb))-1);
                    for j=1:(length(unique(tSegsa))-1)
                        me1G(j)=mean(tGFP(tSegsa==j)-mean(GtBKGroundS(di,1:end),'omitnan'),'omitnan');
                        siza(j)=length(tSegsa(tSegsa==j));
                    end
                    
                    for j=1:(length(unique(tSegsb))-1)
                        me1R(j)=mean(tRFP(tSegsb==j)-mean(RtBKGroundS(di,1:end),'omitnan'),'omitnan');
                        sizb(j)=length(tSegsb(tSegsb==j));
                    end
                    singCellG{di,i} = me1G;
                    singCellR{di,i} = me1R;
                    sizeCellG{di,i} = siza;
                    sizeCellR{di,i} = sizb;

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
                filePattern4a = fullfile([BackDirs{1,bi},'\Segmentation'], 'exp*GFP_001.tif');
                filePattern4b = fullfile([BackDirs{1,bi},'\Segmentation'], 'exp*mKate2_001.tif');
                Files4a = dir(filePattern4a);
                Files4b = dir(filePattern4b);
                
                tSegsBACKa=imread([BackDirs{1,bi},'\Segmentation\',Files4a(r(i)).name]); % Background Mask
                tSegsBACKb=imread([BackDirs{1,bi},'\Segmentation\',Files4b(r(i)).name]);
                
                if ~strcmp(Chan.Flu1, 'none') && ~strcmp(Chan.Flu2, 'none') % 2 fluorescent proteins present
                    tGFPBACK=double(imread([BackDirs{1,bi},'\CutFluo1\exp_000',num,'_',Chan.Flu1,'_001.png'])); % Cut GFP image
                    tRFPBACK=double(imread([BackDirs{1,bi},'\CutFluo2\exp_000',num,'_',Chan.Flu2,'_001.png'])); % Cut RFP image
                elseif ~strcmp(Chan.Flu1, 'none') && strcmp(Chan.Flu2, 'none') % Only GFP measured
                    tGFPBACK=double(imread([BackDirs{1,bi},'\CutFluo1\exp_000',num,'_',Chan.Flu1,'_001.png'])); % Cut GFP image
                    tRFPBACK=nan(size(tSegsBACKb)); % Cut RFP image
                elseif strcmp(Chan.Flu1, 'none') && ~strcmp(Chan.Flu2, 'none') % Only RFP measured
                    tGFPBACK=nan(size(tSegsBACKa)); % Cut GFP image
                    tRFPBACK=double(imread([BackDirs{1,bi},'\CutFluo2\exp_000',num,'_',Chan.Flu2,'_001.png'])); % Cut RFP image
                end

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Patch for segmentation issues when there is no cells
                firdrop = find((cBack{1,bi}<100)==1); 
                if isempty(firdrop)
                    firdrop=inf;
                end

                if i<360/CitFreq && cBack{1,bi}(i)>100 
                    tSegsBACKa=tSegsBACKa*0;
                    tSegsBACKb=tSegsBACKb*0;
%                 elseif i>=360/CitFreq && firdrop(1)>=i %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% THIS MIGHT NOT BE NEDDED,DEPEND ON HOW THE WAIGHTS WORK
%                     tSegsBACK=tSegsBACK*0; 
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                tSegsBACKa = imdilate(tSegsBACKa,tempse); % Add extra pixels around cells
                tSegsBACKb = imdilate(tSegsBACKb,tempse);
                % Compute Background intensity
                
                [a,b] = size(tSegsBACKa); % Compute percentage of pixels from background
                if all(isnan(tRFPBACK(:)))
                    np = length(tGFPBACK(logical(tSegsBACKa)==0));
                elseif all(isnan(tGFPBACK(:)))
                    np = length(tRFPBACK(logical(tSegsBACKb)==0));
                else 
                    np = length(tGFPBACK(logical(tSegsBACKa)==0));
                end
                
                if (np/(a*b))>=0.40
                    ALLroundG=[ALLroundG; tGFPBACK(tSegsBACKa==0)]; % Compute Background
                    ALLroundR=[ALLroundR; tRFPBACK(tSegsBACKb==0)]; % Compute Background
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
                filePattern4a = fullfile([CellDirs{1,di},'\Segmentation'], 'exp*GFP_001.tif');
                filePattern4b = fullfile([CellDirs{1,di},'\Segmentation'], 'exp*mKate2_001.tif');
                Files4a = dir(filePattern4a);
                Files4b = dir(filePattern4b);
            
                tSegsa=imread([CellDirs{1,di},'\Segmentation\Components\imgG_',num,'.tif']); % Mask
                tSegsb=imread([CellDirs{1,di},'\Segmentation\Components\imgR_',num,'.tif']);
                tBKGa=imread([CellDirs{1,di},'\Segmentation\BKG-',Files4a(r(i)).name]); % Background image
                tBKGb=imread([CellDirs{1,di},'\Segmentation\BKG-',Files4b(r(i)).name]);
                
                if ~strcmp(Chan.Flu1, 'none') && ~strcmp(Chan.Flu2, 'none') % 2 fluorescent proteins present
                    tGFP=double(imread([CellDirs{1,di},'\CutFluo1\exp_000',num,'_',Chan.Flu1,'_001.png'])); % Cut GFP image
                    tRFP=double(imread([CellDirs{1,di},'\CutFluo2\exp_000',num,'_',Chan.Flu2,'_001.png'])); % Cut RFP image
                elseif ~strcmp(Chan.Flu1, 'none') && strcmp(Chan.Flu2, 'none') % Only GFP measured
                    tGFP=double(imread([CellDirs{1,di},'\CutFluo1\exp_000',num,'_',Chan.Flu1,'_001.png'])); % Cut GFP image
                    tRFP=nan(size(tSegsb)); % Cut RFP image
                elseif strcmp(Chan.Flu1, 'none') && ~strcmp(Chan.Flu2, 'none') % Only RFP measured
                    tGFP=nan(size(tSegsa)); % Cut GFP image
                    tRFP=double(imread([CellDirs{1,di},'\CutFluo2\exp_000',num,'_',Chan.Flu2,'_001.png'])); % Cut RFP image
                end
                
                load([mainDir,'\',ident,'_OutputFiles\TemporaryBackgroundROI1GFP.mat'],'GtBKGroundROI1');
                load([mainDir,'\',ident,'_OutputFiles\TemporaryBackgroundROI1RFP.mat'],'RtBKGroundROI1');
                
                GtBKGroundROI1(di,i)=mean(tGFP(logical(tBKGa)), 'omitnan'); % Compute Background
                RtBKGroundROI1(di,i)=mean(tRFP(logical(tBKGb)), 'omitnan'); % Compute Background
                
                save([mainDir,'\',ident,'_OutputFiles\TemporaryBackgroundROI1GFP.mat'],'GtBKGroundROI1');
                save([mainDir,'\',ident,'_OutputFiles\TemporaryBackgroundROI1RFP.mat'],'RtBKGroundROI1');
                
                [a1,b1] = size(tSegsa); % Compute percentage of pixels from background                
                if all(isnan(tRFP(:)))
                    np1 = length(tGFP(logical(tBKGa)==1));
                elseif all(isnan(tGFP(:)))
                    np1 = length(tRFP(logical(tBKGb)==1));
                else 
                    np1 = length(tGFP(logical(tBKGa)==1));
                end
                
                
                % Compute Background intensity
                %% Remove ROI in position1 until segmentation is better!!!!
%                 if np1/(a1*b1)>0.75 % If there is enough background in the cell images, take that
%                     GtBKGroundS(1,i)=GtBKGroundROI1(di,i);   % Save background value if condition is meet for the exception 
%                     RtBKGroundS(1,i)=RtBKGroundROI1(di,i);   % Save background value if condition is meet for the exception 
%                     
%                     me1G = nan(1,length(unique(tSegsa))-1); % Store mean fluorescence values per cell
%                     me1R = nan(1,length(unique(tSegsb))-1); % Store mean fluorescence values per cell
%                     siza = nan(1,length(unique(tSegsa))-1); % Store mean fluorescence values per cell
%                     sizb = nan(1,length(unique(tSegsb))-1);
%                     for j=1:(length(unique(tSegsa))-1)
%                         me1G(j)=mean(tGFP(tSegsa==j)-GtBKGroundROI1(di,i),'omitnan');
%                         siza(j) =length(tSegsa(tSegsa==j));
%                     end
%                     for j=1:(length(unique(tSegsb))-1)
%                         me1R(j)=mean(tRFP(tSegsb==j)-RtBKGroundROI1(di,i),'omitnan');
%                         sizb(j) =length(tSegsb(tSegsb==j));
%                     end
%                     singCellG{di,i} = me1G;
%                     singCellR{di,i} = me1R;
%                     sizeCellG{di,i} = siza;
%                     sizeCellR{di,i} = sizb;
%                 else % GFP and RFP separated since if one of the two channels is not used, then the script would stop for the other as well
                    
                    % GFP
                    if (GtBKGround(1,i)~=0) && ~isnan(GtBKGround(1,i)) % If there is enough background pixels in the background images
                        
                        GtBKGroundS(1,i)=GtBKGround(1,i);   % Save background value if condition is meet for the exception 
                        me1G = nan(1,length(unique(tSegsa))-1); % Store mean fluorescence values per cell
                        siza = nan(1,length(unique(tSegsa))-1); % Store mean fluorescence values per cell
                        for j=1:(length(unique(tSegsa))-1)
                            me1G(j)=mean(tGFP(tSegsa==j)-GtBKGround(1,i),'omitnan');
                            siza(j) =length(tSegsa(tSegsa==j));
                        end
                        singCellG{di,i} = me1G;
                        sizeCellG{di,i} = siza;
                    else % If there is not enough background anywere, just take the average of the past
                        
                        me1G = nan(1,length(unique(tSegsa))-1); % Store mean fluorescence values per cell
                        siza = nan(1,length(unique(tSegsa))-1); % Store mean fluorescence values per cell
                        for j=1:(length(unique(tSegsa))-1)
                            me1G(j)=mean(tGFP(tSegsa==j)-mean(GtBKGroundS(1,:),'omitnan'),'omitnan');
                            siza(j) =length(tSegsa(tSegsa==j));
                        end
                        singCellG{di,i} = me1G;
                        sizeCellG{di,i} = siza;
                    end
                    
                    % RFP
                    if (RtBKGround(1,i)~=0) && ~isnan(RtBKGround(1,i))
                        
                        RtBKGroundS(1,i)=RtBKGround(1,i);   % Save background value if condition is meet for the exception 
                        me1R = nan(1,length(unique(tSegsb))-1); % Store mean fluorescence values per cell
                        sizb = nan(1,length(unique(tSegsb))-1); % Store mean fluorescence values per cell
                        for j=1:(length(unique(tSegsb))-1)
                            me1R(j)=mean(tRFP(tSegsb==j)-GtBKGround(1,i),'omitnan');
                            sizb(j) =length(tSegsb(tSegsb==j));
                        end
                        singCellR{di,i} = me1R;
                        sizeCellR{di,i} = sizb;

                    else
                        me1R = nan(1,length(unique(tSegsb))-1); % Store mean fluorescence values per cell
                        sizb = nan(1,length(unique(tSegsb))-1); % Store mean fluorescence values per cell
                        for j=1:(length(unique(tSegsb))-1)
                            me1R(j)=mean(tRFP(tSegsb==j)-mean(RtBKGroundS(1,:),'omitnan'),'omitnan');
                            sizb(j) =length(tSegsb(tSegsb==j));
                        end
                        singCellR{di,i} = me1R;
                        sizeCellR{di,i} = sizb;
                    end
%                 end

            end
            tfluo1(1,i)=mean([singCellG{:,i}],'omitnan');
            tfluo1(2,i)=std([singCellG{:,i}],'omitnan');
            tfluo2(1,i)=mean([singCellR{:,i}],'omitnan');
            tfluo2(2,i)=std([singCellR{:,i}],'omitnan');
        end
    end    

end







end