
function [tSulf, cBack] = ComputeDyeLevels_YST (CellDirs, BackDirs, cBack, tSulf, CitFreq, DicFreq, maxidD, maxidDy, maxidDyb, Chan, cutcorBACK, tempse)

r = 1:CitFreq/DicFreq:maxidD;

if ~isempty(cutcorBACK{1,1})
    for i=1:maxidDyb % Loop if there is Sulforhodamine images
        if isnan(tSulf(1,i))
            num = num2str(r(i),'%.3u');
            sul = imread([BackDirs{1,1},'\CutDyeBackOne\exp_000',num,'_',Chan.Dye,'_001.png']);
            sul21 = imread([BackDirs{1,1},'\SegmentationOne\exp_000',num,'_DIC_001.tif']);    
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Patch for segmentation issues when there is no cells
            L = bwlabel(sul21,4);
            cBacka = cBack{1,1};
            cBacka(i)=length(unique(L));
            if i<360/CitFreq && cBacka(i)>100
                sul21=sul21*0;
            elseif i>=360/CitFreq && isempty(find((cBacka<100)==1))
                sul21=sul21*0;
            end
            sul21=imdilate(sul21,tempse);
%             save([BackDirs{1,1},'\SegmentationOne\TemporaryCellCount.mat'],'cBacka');
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            sulvec = double(sul(sul21==0));
            if ~isempty(cutcorBACK{1,2})

                sulb = imread([BackDirs{1,1},'\CutDyeBackTwo\exp_000',num,'_',Chan.Dye,'_001.png']);
                sul21b = imread([BackDirs{1,1},'\SegmentationTwo\exp_000',num,'_DIC_001.tif']);    
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Patch for segmentation issues when there is no cells
                L = bwlabel(sul21b,4);
                cBackb = cBack{1,2};
                cBackb(i)=length(unique(L));
                if i<360/CitFreq && cBackb(i)>100
                    sul21b=sul21b*0;
                elseif i>=360/CitFreq && isempty(find((cBackb<100)==1))
                    sul21b=sul21b*0;
                end
                sul21b=imdilate(sul21b,tempse);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                sulvecb = double(sulb(sul21b==0));
                sulvec=[sulvec;sulvecb];
            end
%             if ~isempty(cutcorBACK{1,2})
%                 save([BackDirs{1,1},'\SegmentationTwo\TemporaryCellCount.mat'],'cBackb');
%             end
            tSulf(1,i)=mean(sulvec);
            tSulf(2,i)=std(sulvec);
            
            cBack{1,1} = cBacka;
            if ~isempty(cutcorBACK{1,2})
                cBack{1,2} = cBackb;
            end
        end
    end
    
else
    for i=1:maxidDy % Cut DIC images
        if isnan(tSulf(1,i))
            num = num2str(r(i),'%.3u');
            sul = imread([CellDirs{1,1},'\CutDye\exp_000',num,'_',Chan.Dye,'_001.png']);
            sul21 = imread([pDIC,'\Segmentation\BKG-exp_000',num,'_DIC_001.tif']);
            tSulf(1,i)=mean(sul(logical(sul21)));
            tSulf(2,i)=std(sul(logical(sul21)));
        end
    end
end











































