



function [maxidD,maxidF1,maxidF2,maxidDy, maxidDb,maxidF1b,maxidF2b,maxidDyb] = CutImages(cutcor,CellDirs,BackDirs,cutcorBACK,Chan,Device)


%% Cell Images
maxidD=cell(1,length(CellDirs));
maxidF1=cell(1,length(CellDirs));
maxidF2=cell(1,length(CellDirs));
maxidDy=cell(1,length(CellDirs));
    
for di = 1:length(CellDirs)
% Get names of current images 
    filePattern1 = fullfile(CellDirs{1,di}, 'exp*DIC_001.png');
    filePattern2 = fullfile(CellDirs{1,di}, ['exp*',Chan.Flu1,'_001.png']);
    filePattern3 = fullfile(CellDirs{1,di}, ['exp*',Chan.Flu2,'_001.png']);
    filePattern4 = fullfile(CellDirs{1,di}, ['exp*',Chan.Dye,'_001.png']);
    Files1 = dir(filePattern1);
    Files2 = dir(filePattern2);
    Files3 = dir(filePattern3);
    Files4 = dir(filePattern4);
    % Get number of frames for channel
    imaxidD=length(Files1);
    maxidD{1,di} = imaxidD;
    imaxidF1=length(Files2);
    maxidF1{1,di} = imaxidF1;
    imaxidF2=length(Files3);
    maxidF2{1,di} = imaxidF2;
    imaxidDy=length(Files4);
    maxidDy{1,di} = imaxidDy;


    for i=1:imaxidD % Cut DIC images
        if ~isfile([CellDirs{1,di},'\CutDIC\',Files1(i).name])
            temp1 = imread([CellDirs{1,di},'\',Files1(i).name]);
            temp2 = temp1(cutcor{1,di}(1):cutcor{1,di}(2),cutcor{1,di}(3):cutcor{1,di}(4));
            imwrite(temp2, [CellDirs{1,di},'\CutDIC\',Files1(i).name])
        end
    end
    switch Device
        case 'Yeast'
            for i=1:imaxidF1 % Cut GFP images
                if ~isfile([CellDirs{1,di},'\CutCitrine\',Files2(i).name])
                    temp1 = imread([CellDirs{1,di},'\',Files2(i).name]);
                    temp2 = temp1(cutcor{1,di}(1):cutcor{1,di}(2),cutcor{1,di}(3):cutcor{1,di}(4));
                    imwrite(temp2, [CellDirs{1,di},'\CutCitrine\',Files2(i).name])
                end
            end
        case 'Bacteria'
            for i=1:imaxidF1 % Cut GFP images
                if ~isfile([CellDirs{1,di},'\CutFluo1\',Files2(i).name])
                    temp1 = imread([CellDirs{1,di},'\',Files2(i).name]);
                    temp2 = temp1(cutcor{1,di}(1):cutcor{1,di}(2),cutcor{1,di}(3):cutcor{1,di}(4));
                    imwrite(temp2, [CellDirs{1,di},'\CutFluo1\',Files2(i).name])
                end
            end

            for i=1:imaxidF2 % Cut RFP images
                if ~isfile([CellDirs{1,di},'\CutFluo2\',Files3(i).name])
                    temp1 = imread([CellDirs{1,di},'\',Files3(i).name]);
                    temp2 = temp1(cutcor{1,di}(1):cutcor{1,di}(2),cutcor{1,di}(3):cutcor{1,di}(4));
                    imwrite(temp2, [CellDirs{1,di},'\CutFluo2\',Files3(i).name])
                end
            end
    end

    for i=1:imaxidDy % Cut Cy5 images
        if ~isfile([CellDirs{1,di},'\CutDye\',Files4(i).name])
            temp1 = imread([CellDirs{1,di},'\',Files4(i).name]);
            temp2 = temp1(cutcor{1,di}(1):cutcor{1,di}(2),cutcor{1,di}(3):cutcor{1,di}(4));
            imwrite(temp2, [CellDirs{1,di},'\CutDye\',Files4(i).name])
        end
    end

end


%% Background Images
switch Device
    case 'Yeast'
        if ~isempty(cutcorBACK{1,1})
            maxidDb=cell(1,1);
            maxidF1b=cell(1,1);
            maxidF2b=cell(1,1);
            maxidDyb=cell(1,1);

            filePattern1b = fullfile(BackDirs{1,di}, 'exp*DIC_001.png');
            filePattern2b = fullfile(BackDirs{1,di}, ['exp*',Chan.Flu1,'_001.png']);
            filePattern3b = fullfile(BackDirs{1,di}, ['exp*',Chan.Flu2,'_001.png']);
            filePattern4b = fullfile(BackDirs{1,di}, ['exp*',Chan.Dye,'_001.png']);
            Files1b = dir(filePattern1b);
            Files2b = dir(filePattern2b);
            Files3b = dir(filePattern3b);
            Files4b = dir(filePattern4b);
            % Get number of frames for channel
            maxidDb{1,1}=length(Files1b);
            maxidF1b{1,1}=length(Files2b);
            maxidF2b{1,1}=length(Files3b);
            maxidDyb{1,1}=length(Files4b);
            
            for i=1:maxidDb{1,1} % Cut DIC images
                if ~isfile([BackDirs{1,1},'\CutDICBackOne\',Files1b(i).name])
                    temp1 = imread([BackDirs{1,1},'\',Files1b(i).name]);
                    temp2 = temp1(cutcorBACK{1,1}(1):cutcorBACK{1,1}(2),cutcorBACK{1,1}(3):cutcorBACK{1,1}(4));
                    imwrite(temp2, [BackDirs{1,1},'\CutDICBackOne\',Files1b(i).name])
                end
                if ~isfile([BackDirs{1,1},'\CutDICBackTwo\',Files1b(i).name]) && ~isempty(cutcorBACK{1,2})
                    temp1 = imread([BackDirs{1,1},'\',Files1b(i).name]);
                    temp2 = temp1(cutcorBACK{1,2}(1):cutcorBACK{1,2}(2),cutcorBACK{1,2}(3):cutcorBACK{1,2}(4));
                    imwrite(temp2, [BackDirs{1,1},'\CutDICBackTwo\',Files1b(i).name])
                end
            end
            
            for i=1:maxidF1b{1,1} % Cut Citrine images
                if ~isfile([BackDirs{1,1},'\CutCitrineBackOne\',Files2b(i).name])
                    temp1 = imread([BackDirs{1,1},'\',Files2b(i).name]);
                    temp2 = temp1(cutcorBACK{1,1}(1):cutcorBACK{1,1}(2),cutcorBACK{1,1}(3):cutcorBACK{1,1}(4));
                    imwrite(temp2, [BackDirs{1,1},'\CutCitrineBackOne\',Files2b(i).name])
                end
                if ~isfile([BackDirs{1,1},'\CutCitrineBackTwo\',Files2b(i).name]) && ~isempty(cutcorBACK{1,2})
                    temp1 = imread([BackDirs{1,1},'\',Files2b(i).name]);
                    temp2 = temp1(cutcorBACK{1,2}(1):cutcorBACK{1,2}(2),cutcorBACK{1,2}(3):cutcorBACK{1,2}(4));
                    imwrite(temp2, [BackDirs{1,1},'\CutCitrineBackTwo\',Files2b(i).name])
                end
            end
            
            for i=1:maxidDyb{1,1} % Cut Cy5 images
                if ~isfile([BackDirs{1,1},'\CutDyeBackOne\',Files4b(i).name])
                    temp1 = imread([BackDirs{1,1},'\',Files4b(i).name]);
                    temp2 = temp1(cutcorBACK{1,1}(1):cutcorBACK{1,1}(2),cutcorBACK{1,1}(3):cutcorBACK{1,1}(4));
                    imwrite(temp2, [BackDirs{1,1},'\CutDyeBackOne\',Files4b(i).name])
                end
                if ~isfile([BackDirs{1,1},'\CutDyeBackTwo\',Files4b(i).name]) && ~isempty(cutcorBACK{1,2})
                    temp1 = imread([BackDirs{1,1},'\',Files4b(i).name]);
                    temp2 = temp1(cutcorBACK{1,2}(1):cutcorBACK{1,2}(2),cutcorBACK{1,2}(3):cutcorBACK{1,2}(4));
                    imwrite(temp2, [BackDirs{1,1},'\CutDyeBackTwo\',Files4b(i).name])
                end
            end
        
        end
    case 'Bacteria'
        maxidDb=cell(1,length(BackDirs));
        maxidF1b=cell(1,length(BackDirs));
        maxidF2b=cell(1,length(BackDirs));
        maxidDyb=cell(1,length(BackDirs));


        for di=1:length(BackDirs)
            filePattern1b = fullfile(BackDirs{1,di}, 'exp*DIC_001.png');
            filePattern2b = fullfile(BackDirs{1,di}, ['exp*',Chan.Flu1,'_001.png']);
            filePattern3b = fullfile(BackDirs{1,di}, ['exp*',Chan.Flu2,'_001.png']);
            filePattern4b = fullfile(BackDirs{1,di}, ['exp*',Chan.Dye,'_001.png']);
            Files1b = dir(filePattern1b);
            Files2b = dir(filePattern2b);
            Files3b = dir(filePattern3b);
            Files4b = dir(filePattern4b);
            % Get number of frames for channel
            imaxidDb=length(Files1b);
            maxidDb{1,di} = imaxidDb;
            imaxidF1b=length(Files2b);
            maxidF1b{1,di} = imaxidF1b;
            imaxidF2b=length(Files3b);
            maxidF2b{1,di} = imaxidF2b;
            imaxidDyb=length(Files4b);
            maxidDyb{1,di} = imaxidDyb;


            for i=1:imaxidDb % Cut DIC images
                if ~isfile([BackDirs{1,di},'\CutDIC\',Files1b(i).name])
                    temp1 = imread([BackDirs{1,di},'\',Files1b(i).name]);
                    temp2 = temp1(cutcorBACK{1,di}(1):cutcorBACK{1,di}(2),cutcorBACK{1,di}(3):cutcorBACK{1,di}(4));
                    imwrite(temp2, [BackDirs{1,di},'\CutDIC\',Files1b(i).name])
                end
            end

            for i=1:imaxidF1b % Cut GFP images
                if ~isfile([BackDirs{1,di},'\CutFluo1\',Files2b(i).name])
                    temp1 = imread([BackDirs{1,di},'\',Files2b(i).name]);
                    temp2 = temp1(cutcorBACK{1,di}(1):cutcorBACK{1,di}(2),cutcorBACK{1,di}(3):cutcorBACK{1,di}(4));
                    imwrite(temp2, [BackDirs{1,di},'\CutFluo1\',Files2b(i).name])
                end
            end

            for i=1:imaxidF2b % Cut RFP images
                if ~isfile([BackDirs{1,di},'\CutFluo2\',Files3b(i).name])
                    temp1 = imread([BackDirs{1,di},'\',Files3b(i).name]);
                    temp2 = temp1(cutcorBACK{1,di}(1):cutcorBACK{1,di}(2),cutcorBACK{1,di}(3):cutcorBACK{1,di}(4));
                    imwrite(temp2, [BackDirs{1,di},'\CutFluo2\',Files3b(i).name])
                end
            end
            for i=1:imaxidDyb % Cut Cy5 images
                if ~isfile([BackDirs{1,di},'\CutDye\',Files4b(i).name])
                    temp1 = imread([BackDirs{1,di},'\',Files4b(i).name]);
                    temp2 = temp1(cutcorBACK{1,di}(1):cutcorBACK{1,di}(2),cutcorBACK{1,di}(3):cutcorBACK{1,di}(4));
                    imwrite(temp2, [BackDirs{1,di},'\CutDye\',Files4b(i).name])
                end
            end
        end
end

end































