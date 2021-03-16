
function [tSulf, cBack] = ComputeDyeLevels_Bact (CellDirs, BackDirs, cBack, tSulf, CitFreq, DicFreq, maxidDy, maxidDyb, Chan, tempse)


if ~isempty(BackDirs)
    r = 1:CitFreq/DicFreq:min(cell2mat(maxidDyb))*(CitFreq/DicFreq); % You take the min of each channel to consider the case that the images of one possition might not have been processed yet. 
    for i=1:min(cell2mat(maxidDyb)) % Loop if there is Cy5 images
        if isnan(tSulf(1,i))
            sulvec = [];
            for di=1:length(BackDirs)
                num = num2str(r(i),'%.3u');
                sul = imread([BackDirs{1,di},'\CutDye\exp_000',num,'_',Chan.Dye,'_001.png']);
                sul21 = imread([BackDirs{1,di},'\Segmentation\exp_000',num,'_GFP_001.tif']);    
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Patch for segmentation issues when there is no cells
                L = bwlabel(sul21,4);
                cBack{1,di}(i)=length(unique(L));
                if i<360/CitFreq && cBack{1,di}(i)>100  % At the beginning of the experiment there should not be any cells in the background images. This would happen if the flow is not enough and the device starts geting clogged.
                    sul21=sul21*0;
                elseif i>=360/CitFreq && isempty(find((cBack{1,di}<100)==1))
                    sul21=sul21*0;
                end
                sul21=imdilate(sul21,tempse);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                sulvec = [sulvec; double(sul(sul21==0))];
            end
            tSulf(1,i)=mean(sulvec);
            tSulf(2,i)=std(sulvec);
        end
    end
else % In case there is no background positions
    r = 1:CitFreq/DicFreq:min(cell2mat(maxidDy))*(CitFreq/DicFreq);
    for i=1:min(cell2mat(maxidDy)) 
        if isnan(tSulf(1,i))
            sulvec = [];
            for di=1:length(CellDirs)
                num = num2str(r(i),'%.3u');
                sul = imread([CellDirs{1,di},'\CutDye\exp_000',num,'_',Chan.Dye,'_001.png']);
                sul21 = imread([CellDirs{1,di},'\Segmentation\BKG-exp_000',num,'_GFP_001.tif']);
                sulvec = [sulvec; double(sul(sul21==1))];
            end
            tSulf(1,i)=mean(sulvec);
            tSulf(2,i)=std(sulvec);
        end
    end
end





















end