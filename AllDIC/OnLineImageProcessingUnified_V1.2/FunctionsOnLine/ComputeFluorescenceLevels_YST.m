
function [tfluo,tBKGround,tBKGroundS,singCell,sizeCell] = ComputeFluorescenceLevels_YST (tfluo,tBKGround,tBKGroundS,singCell,sizeCell, ...
    cutcorBACK, CitFreq, DicFreq, maxidD, Chan, CellDirs, BackDirs, cBacka, cBackb, mainDir, maxidF1, tempse, ident, Files4)


r = 1:CitFreq/DicFreq:maxidD{1};
if isempty(cutcorBACK{1,1})
    for i=1:maxidF1{1} % Cut DIC images
        if isnan(tfluo(1,i))
            num = num2str(r(i),'%.3u');
            tBKG=imread([CellDirs{1,1},'\Segmentation\BKG-',Files4(r(i)).name]); % Background image
            tSegs=imread([CellDirs{1,1},'\Segmentation\Components\img_',num,'.tif']); % Mask
            tCitr=double(imread([CellDirs{1,1},'\CutCitrine\exp_000',num,'_',Chan.Flu1,'_001.png'])); % Cut citrine image

            % Compute Background intensity
            tBKGround(i)=mean(tCitr(logical(tBKG))); % Compute Background

            [a,b] = size(tSegs); % Compute percentage of pixels from background
            np = length(tCitr(logical(tBKG)==1));
            
            if (np/(a*b)) > 0.60
                tBKGroundS(i)=tBKGround(i);   % Save background value if condition is meet for the exception 

                me1 = nan(1,length(unique(tSegs))-1); % Store mean fluorescence values per cell
                siz = nan(1,length(unique(tSegs))-1); % Store mean fluorescence values per cell
                for j=1:(length(unique(tSegs))-1)
                    me1(j)=mean(tCitr(tSegs==j)-tBKGround(i),'omitnan');
                    siz(j)=length(tSegs(tSegs==j));
                end

                singCell{1,i} = me1;
                sizeCell{1,i} = siz;
                tfluo(1,i)=mean(me1,'omitnan'); % Mean and standard deviation fluorescence value of the image
                tfluo(2,i)=std(me1,'omitnan');

            else
                me1 = nan(1,length(unique(tSegs))-1);
                siz = nan(1,length(unique(tSegs))-1); % Store mean fluorescence values per cell
                for j=1:(length(unique(tSegs))-1)
                    me1(j)=mean(tCitr(tSegs==j)-mean(tBKGroundS(1:end),'omitnan'),'omitnan');
                    siz(j)=length(tSegs(tSegs==j));
                end
                
                singCell{1,i} = me1;
                sizeCell{1,i} = siz;
                tfluo(1,i)=mean(me1,'omitnan');
                tfluo(2,i)=std(me1,'omitnan');

            end

        end
    end
else
    for i=1:maxidF1{1}
        if isnan(tfluo(1,i))
            num = num2str(r(i),'%.3u');
%             Background
            tSegsBACK=imread([BackDirs{1,1},'\SegmentationOne\',Files4(r(i)).name]); % Background image
            tCitrBACK=double(imread([BackDirs{1,1},'\CutCitrineBackOne\exp_000',num,'_',Chan.Flu1,'_001.png'])); % Cut citrine image
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Patch for segmentation issues when there is no cells
            firdrop = find((cBacka<100)==1);
            if isempty(firdrop)
                firdrop=inf;
            end
            
            if i<360/CitFreq && cBacka(i)>100
                tSegsBACK=tSegsBACK*0;
            elseif i>=360/CitFreq && firdrop(1)>=i
                tSegsBACK=tSegsBACK*0;
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            %%%%%%%%%%%%%%%%%%%%%%%%%% TO MODIFY!!!!!!! %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            tSegsBACK = imdilate(tSegsBACK,tempse);
            
            
            % Compute Background intensity
            ALLround=(tCitrBACK(tSegsBACK==0)); % Compute Background
            if ~isempty(cutcorBACK{1,2})
                tSegsBACK2=imread([BackDirs{1,1},'\SegmentationTwo\',Files4(r(i)).name]); % Background image
                tCitrBACK2=double(imread([BackDirs{1,1},'\CutCitrineBackTwo\exp_000',num,'_',Chan.Flu1,'_001.png'])); % Cut citrine image
                % Compute Background intensity
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Patch for segmentation issues when there is no cells
                firdropb = find((cBackb<100)==1);
                if isempty(firdropb)
                    firdropb=inf;
                end
                if i<360/CitFreq && cBackb(i)>100
                    tSegsBACK2=tSegsBACK2*0;
                elseif i>=360/CitFreq && firdropb(1)>=i
                    tSegsBACK2=tSegsBACK2*0;
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                %%%%%%%%%%%%%%%%%%%%%%%%%% TO MODIFY!!!!!!! %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                tSegsBACK2 = imdilate(tSegsBACK2,tempse);
                
                
                
                ALLround2=(tCitrBACK2(tSegsBACK2==0)); % Compute Background
            end
            
            % ROI
            tSegs=imread([CellDirs{1,1},'\Segmentation\Components\img_',num,'.tif']); % Mask
            tCitr=double(imread([CellDirs{1,1},'\CutCitrine\exp_000',num,'_',Chan.Flu1,'_001.png'])); % Cut citrine image

            [a,b] = size(tSegsBACK); % Compute percentage of pixels from background
            np = length(tCitrBACK(tSegsBACK==0));
            if ~isempty(cutcorBACK{1,2})
                [a2,b2] = size(tSegsBACK2); % Compute percentage of pixels from background
                np2 = length(tCitrBACK2(tSegsBACK2==0));
            end
            
            % Only first square of second position
            if ~isempty(cutcorBACK{1,1}) && isempty(cutcorBACK{1,2}) && (np/(a*b))>=0.65
                tBKGround(i)=mean(ALLround); % Get mean of background pixels
                tBKGroundS(i)=tBKGround(i); % Stored in temporary vector that would be used for average if needed
            elseif ~isempty(cutcorBACK{1,1}) && isempty(cutcorBACK{1,2}) && (np/(a*b))>=0.40 && (np/(a*b))<0.65
                tSegsBACK = MorePix(tSegsBACK); % Add more pixels around the cells
                ALLround=(tCitrBACK(tSegsBACK==0)); % Get the background pixels again
                tBKGround(i)=mean(ALLround); 
                tBKGroundS(i)=tBKGround(i);
            elseif ~isempty(cutcorBACK{1,1}) && isempty(cutcorBACK{1,2}) && (np/(a*b))<0.40
                tBKGround(i)=mean(ALLround);
            
            % If there is a second square in the second position   
            % If second square is higher than 65%
            elseif ~isempty(cutcorBACK{1,2}) && (np2/(a2*b2))>=0.65 && (np/(a*b))>=0.65
                tBKGround(i)=mean([ALLround; ALLround2]);
                tBKGroundS(i)=tBKGround(i);
            elseif ~isempty(cutcorBACK{1,2}) && (np2/(a2*b2))>=0.65 && (np/(a*b))>=0.40 && (np/(a*b))<0.65
                tSegsBACK = MorePix(tSegsBACK);
                ALLround=(tCitrBACK(tSegsBACK==0));
                tBKGround(i)=mean([ALLround; ALLround2]);
                tBKGroundS(i)=tBKGround(i);
            elseif ~isempty(cutcorBACK{1,2}) && (np2/(a2*b2))>=0.65 && (np/(a*b))<0.40
                tBKGround(i)=mean(ALLround2);
                tBKGroundS(i)=tBKGround(i);
                
            % If second square is between 65% and 35%    
            elseif ~isempty(cutcorBACK{1,2}) && (np2/(a2*b2))>=0.40 && (np2/(a2*b2))<0.65 && (np/(a*b))>=0.65    
                tSegsBACK2 = MorePix(tSegsBACK2);
                ALLround2=(tCitrBACK2(tSegsBACK2==0));
                tBKGround(i)=mean([ALLround; ALLround2]);
                tBKGroundS(i)=tBKGround(i);
            elseif ~isempty(cutcorBACK{1,2}) && (np2/(a2*b2))>=0.40 && (np2/(a2*b2))<0.65 && (np/(a*b))>=0.40 && (np/(a*b))<0.65
                tSegsBACK2 = MorePix(tSegsBACK2);
                ALLround2=(tCitrBACK2(tSegsBACK2==0));
                tSegsBACK = MorePix(tSegsBACK);
                ALLround=(tCitrBACK(tSegsBACK==0));
                tBKGround(i)=mean([ALLround; ALLround2]);
                tBKGroundS(i)=tBKGround(i);
            elseif ~isempty(cutcorBACK{1,2}) && (np2/(a2*b2))>=0.40 && (np2/(a2*b2))<0.65 && (np/(a*b))<0.40
                tSegsBACK2 = MorePix(tSegsBACK2);
                ALLround2=(tCitrBACK2(tSegsBACK2==0));
                tBKGround(i)=mean(ALLround2);
                tBKGroundS(i)=tBKGround(i);
                
            % If second square is below 35%    
            elseif ~isempty(cutcorBACK{1,2}) && (np2/(a2*b2))<0.40 && (np/(a*b))>=0.65
                tBKGround(i)=mean(ALLround); 
                tBKGroundS(i)=tBKGround(i);
            elseif ~isempty(cutcorBACK{1,2}) && (np2/(a2*b2))<0.40 && (np/(a*b))>=0.40 && (np/(a*b))<0.65
                tSegsBACK = MorePix(tSegsBACK); % Add more pixels around the cells
                ALLround=(tCitrBACK(tSegsBACK==0)); % Get the background pixels again
                tBKGround(i)=mean(ALLround); 
                tBKGroundS(i)=tBKGround(i);
            elseif ~isempty(cutcorBACK{1,2}) && (np2/(a2*b2))<0.40 && (np/(a*b))<0.40
                tBKGround(i)=mean([ALLround; ALLround2]);
            end
            
            tBKG=imread([CellDirs{1,1},'\Segmentation\BKG-',Files4(r(i)).name]); % Background image
            load([mainDir,'\',ident,'_OutputFiles\TemporaryBackgroundROI1.mat'],'tBKGroundROI1');
            % Compute Background intensity
            tBKGroundROI1(i)=mean(tCitr(logical(tBKG))); % Compute Background
            save([mainDir,'\',ident,'_OutputFiles\TemporaryBackgroundROI1.mat'],'tBKGroundROI1');

            [a1,b1] = size(tSegs); % Compute percentage of pixels from background
            np1 = length(tCitr(logical(tBKG)==1));
            
            % Extract cell fluorescence
            if np1/(a1*b1)>0.75
                me1 = nan(1,length(unique(tSegs))-1); % Store mean fluorescence values per cell
                siz = nan(1,length(unique(tSegs))-1); % Store mean fluorescence values per cell
                for j=1:(length(unique(tSegs))-1)
                    me1(j)=mean(tCitr(tSegs==j)-tBKGroundROI1(i),'omitnan');
                    siz(j)=length(tSegs(tSegs==j));
                end
                singCell{1,i} = me1;
                sizeCell{1,i} = siz;
                tfluo(1,i)=mean(me1,'omitnan'); % Mean and standard deviation fluorescence value of the image
                tfluo(2,i)=std(me1,'omitnan');
            else
                if ~isnan(tBKGroundS(i))
                    me1 = nan(1,length(unique(tSegs))-1); % Store mean fluorescence values per cell
                    siz = nan(1,length(unique(tSegs))-1); % Store mean fluorescence values per cell
                    for j=1:(length(unique(tSegs))-1)
                        me1(j)=mean(tCitr(tSegs==j)-tBKGround(i),'omitnan');
                        siz(j)=length(tSegs(tSegs==j));
                    end
                    singCell{1,i} = me1;
                    sizeCell{1,i} = siz;
                    tfluo(1,i)=mean(me1,'omitnan'); % Mean and standard deviation fluorescence value of the image
                    tfluo(2,i)=std(me1,'omitnan');
                elseif isnan(tBKGroundS(i))
                    me1 = nan(1,length(unique(tSegs))-1);
                    siz = nan(1,length(unique(tSegs))-1); % Store mean fluorescence values per cell
                    for j=1:(length(unique(tSegs))-1)
                        me1(j)=mean(tCitr(tSegs==j)-mean(tBKGroundS(1:end),'omitnan'),'omitnan');
                        siz(j)=length(tSegs(tSegs==j));
                    end
                    singCell{1,i} = me1;
                    sizeCell{1,i} = siz;
                    tfluo(1,i)=mean(me1,'omitnan');
                    tfluo(2,i)=std(me1,'omitnan');
                end
            end
%             singCell{1,i} = me1;
        end
    end
end



end









