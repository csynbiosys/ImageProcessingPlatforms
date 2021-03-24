
%% Image processing by frame

% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INPUTS
% --------> obj,event: Arguments that need to be defined in the function
% for the timer scheduler function to work but do not need to do anything
% inside the function
% --------> pDIC: Directory were the microscope images are going to be
% saved.
% --------> cutcor: matrix indexes of the ROI.
% --------> ident: Identifier to be added to some temporary files
% -------->INP: 2xN matrix containing the time vector and input values
% applied during the experiment

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OUTPUTS
% --------> 


function [] = ImProcSegm_Unif(obj, event,cutcor,CellDirs,ident,INP,Ind2,CitFreq,DicFreq,BackDirs,cutcorBACK,mainDir,IndInf,Chan, webPath, Device)


try
%% Cut Images
[maxidD,maxidF1,maxidF2,maxidDy, maxidDb,maxidF1b,maxidF2b,maxidDyb] = CutImages(cutcor,CellDirs,BackDirs,cutcorBACK,Chan,Device);


%% Segmentation

% Run UNet segmentation Macro code


IJ=ij.IJ();
% Segment Background images
switch Device
    case 'Yeast'
        % Segment cell images
        for di=1:length(CellDirs)
            macro_path = [CellDirs{1,di},'\Segmentation'];
            IJ.runMacroFile(java.lang.String(fullfile(macro_path,[ident,'-MacroSegmentation.ijm'])));
        end


        if ~isempty(cutcorBACK{1,1})
            macro_pathb1 = [BackDirs{1,1},'\SegmentationOne'];
            IJ.runMacroFile(java.lang.String(fullfile(macro_pathb1,[ident,'-MacroSegmentationBackOne.ijm'])));
            if ~isempty(cutcorBACK{1,2})
                macro_pathb2 = [BackDirs{1,1},'\SegmentationTwo'];
                IJ.runMacroFile(java.lang.String(fullfile(macro_pathb2,[ident,'-MacroSegmentationBackTwo.ijm'])));
            end
        end
    case 'Bacteria'
        % Segment cell images
        for di=1:length(CellDirs)
            macro_path = [CellDirs{1,di},'\Segmentation'];
            IJ.runMacroFile(java.lang.String(fullfile(macro_path,[ident,'-MacroSegmentationGFP.ijm'])));
            IJ.runMacroFile(java.lang.String(fullfile(macro_path,[ident,'-MacroSegmentationRFP.ijm'])));
        end

        for di=1:length(BackDirs)
            macro_path = [BackDirs{1,di},'\Segmentation'];
            IJ.runMacroFile(java.lang.String(fullfile(macro_path,[ident,'-MacroSegmentationGFP.ijm'])));
            IJ.runMacroFile(java.lang.String(fullfile(macro_path,[ident,'-MacroSegmentationRFP.ijm'])));
        end
end





%% Generate Background masks

maxidM = cell(1,length(CellDirs));
maxidMa = cell(1,length(CellDirs));
maxidMb = cell(1,length(CellDirs));

tempse=strel('disk',10,8);
for di = 1:length(CellDirs)
    switch Device
        case 'Yeast'
            % Get names of current images 
            filePattern4 = fullfile([CellDirs{1,di},'\Segmentation'], 'exp*DIC_001.tif');
            Files4 = dir(filePattern4);
            % Get number of frames for channel
            imaxidM=length(Files4);
            maxidM{1,di} = imaxidM;

            % Adding background pixels

            for i=1:imaxidM % Cut DIC images
                if ~isfile([CellDirs{1,di},'\Segmentation\BKG-',Files4(i).name])
                    temp1 = imread([CellDirs{1,di},'\Segmentation\',Files4(i).name]);
                    z=~imdilate(temp1,tempse);
                    imwrite(uint16(z), [CellDirs{1,di},'\Segmentation\BKG-',Files4(i).name])
                end
            end
    
        case 'Bacteria'
            % Get names of current images 
            filePattern4a = fullfile([CellDirs{1,di},'\Segmentation'], 'exp*GFP_001.tif');
            filePattern4b = fullfile([CellDirs{1,di},'\Segmentation'], 'exp*mKate2_001.tif');
            Files4a = dir(filePattern4a);
            Files4b = dir(filePattern4b);

            % Get number of frames for channel
            imaxidMa=length(Files4a);
            imaxidMb=length(Files4b);

            maxidMa{1,di} = imaxidMa;
            maxidMb{1,di} = imaxidMb;
            % Adding background pixels

            for i=1:imaxidMa % Cut DIC images
                if ~isfile([CellDirs{1,di},'\Segmentation\BKG-',Files4a(i).name])
                    temp1 = imread([CellDirs{1,di},'\Segmentation\',Files4a(i).name]);
                    z=~imdilate(temp1,tempse);
                    imwrite(uint16(z), [CellDirs{1,di},'\Segmentation\BKG-',Files4a(i).name])
                end
            end
            
            for i=1:imaxidMb % Cut DIC images
                if ~isfile([CellDirs{1,di},'\Segmentation\BKG-',Files4b(i).name])
                    temp1 = imread([CellDirs{1,di},'\Segmentation\',Files4b(i).name]);
                    z=~imdilate(temp1,tempse);
                    imwrite(uint16(z), [CellDirs{1,di},'\Segmentation\BKG-',Files4b(i).name])
                end
            end
    end
end


%% Compute background sulforhodamine levels
load([mainDir,'\',ident,'_OutputFiles\TemporaryDye.mat'],'tSulf');

switch Device
    case 'Yeast'
        if ~isempty(cutcorBACK{1,1})
            load([BackDirs{1,1},'\SegmentationOne\TemporaryCellCount.mat'],'cBacka');
            cBack{1,1} = cBacka;
            if ~isempty(cutcorBACK{1,2})
                load([BackDirs{1,1},'\SegmentationTwo\TemporaryCellCount.mat'],'cBackb');
                cBack{1,2} = cBackb;
            end
            [tSulf, cBack] = ComputeDyeLevels_YST (CellDirs, BackDirs, cBack, tSulf, ...
                CitFreq, DicFreq, maxidD{1}, maxidDy{1}, maxidDyb{1}, Chan, cutcorBACK, tempse);
            cBacka = cBack{1,1};
            save([BackDirs{1,1},'\SegmentationOne\TemporaryCellCount.mat'],'cBacka');
            if ~isempty(cutcorBACK{1,2})
                cBackb = cBack{1,2};
                save([BackDirs{1,1},'\SegmentationTwo\TemporaryCellCount.mat'],'cBackb');
            else
                cBackb = [];
            end
        else
            cBacka = [];
            cBackb = [];
        end
    case 'Bacteria'
        load([mainDir,'\',ident,'_OutputFiles\TemporaryCellCountBackground.mat'],'cBack');
        [tSulf, cBack] = ComputeDyeLevels_Bact (CellDirs, BackDirs, cBack, tSulf, CitFreq, DicFreq, maxidDy, maxidDyb, Chan, tempse);
        save([mainDir,'\',ident,'_OutputFiles\TemporaryCellCountBackground.mat'],'cBack');
end

save([mainDir,'\',ident,'_OutputFiles\TemporaryDye.mat'],'tSulf');


%% Indexing masks
% Get names of current images 

switch Device
    case 'Yeast'
        IndexMasks_Yeast(CellDirs, Device, ident);
    case 'Bacteria'
        IndexMasks_Bact(CellDirs, Device, ident);
end


%% Temporary Fluorescence data extraction

switch Device
    case 'Yeast'
        load([mainDir,'\',ident,'_OutputFiles\TemporaryFluorescence.mat'],'tfluo');
        load([mainDir,'\',ident,'_OutputFiles\TemporaryBackground.mat'],'tBKGround');
        load([mainDir,'\',ident,'_OutputFiles\TemporaryBackgroundShort.mat'],'tBKGroundS');
        load([mainDir,'\',ident,'_OutputFiles\TemporaryBackgroundROI1.mat'],'tBKGroundROI1');
        load([mainDir,'\',ident,'_OutputFiles\TemporarySingleCellFluoCitrine.mat'],'singCell');
        load([mainDir,'\',ident,'_OutputFiles\TemporarySingleCellSize.mat'],'sizeCell');
        
        [tfluo,tBKGround,tBKGroundS,singCell,sizeCell] = ComputeFluorescenceLevels_YST (tfluo,tBKGround,tBKGroundS,singCell,sizeCell, ...
        cutcorBACK, CitFreq, DicFreq, maxidD, Chan, CellDirs, BackDirs, cBacka, cBackb, mainDir, maxidF1, tempse, ident, Files4);
        
        save([mainDir,'\',ident,'_OutputFiles\TemporaryFluorescence.mat'],'tfluo');
        save([mainDir,'\',ident,'_OutputFiles\TemporaryBackground.mat'],'tBKGround');
        save([mainDir,'\',ident,'_OutputFiles\TemporaryBackgroundShort.mat'],'tBKGroundS');
        save([mainDir,'\',ident,'_OutputFiles\TemporaryBackgroundROI1.mat'],'tBKGroundROI1');
        save([mainDir,'\',ident,'_OutputFiles\TemporarySingleCellFluoCitrine.mat'],'singCell');
        save([mainDir,'\',ident,'_OutputFiles\TemporarySingleCellSize.mat'],'sizeCell');
    case 'Bacteria'
        load([mainDir,'\',ident,'_OutputFiles\TemporaryFluorescence1.mat'],'tfluo1');
        load([mainDir,'\',ident,'_OutputFiles\TemporaryFluorescence2.mat'],'tfluo2');
        load([mainDir,'\',ident,'_OutputFiles\TemporaryBackgroundGFP.mat'],'GtBKGround');
        load([mainDir,'\',ident,'_OutputFiles\TemporaryBackgroundRFP.mat'],'RtBKGround');
        load([mainDir,'\',ident,'_OutputFiles\TemporaryBackgroundShortGFP.mat'],'GtBKGroundS');
        load([mainDir,'\',ident,'_OutputFiles\TemporaryBackgroundShortRFP.mat'],'RtBKGroundS');
        load([mainDir,'\',ident,'_OutputFiles\TemporarySingleCellFluoGFP.mat'],'singCellG');
        load([mainDir,'\',ident,'_OutputFiles\TemporarySingleCellFluoRFP.mat'],'singCellR');
        load([mainDir,'\',ident,'_OutputFiles\TemporarySingleCellSizeRFP.mat'],'sizeCellR');
        load([mainDir,'\',ident,'_OutputFiles\TemporarySingleCellSizeGFP.mat'],'sizeCellG');
        
%         [tfluo1,tfluo2,GtBKGround,RtBKGround,GtBKGroundS,RtBKGroundS,singCellG,singCellR,sizeCell] = ComputeFluorescenceLevels_Bact ...
%         (tfluo1,tfluo2,GtBKGround,RtBKGround,GtBKGroundS,RtBKGroundS,singCellG,singCellR,sizeCell , cutcorBACK, CitFreq, DicFreq, maxidD, Chan, CellDirs, ...
%         BackDirs, cBack, mainDir, maxidF1b, maxidF2b, tempse, ident);
        
        [tfluo1,tfluo2,GtBKGround,RtBKGround,GtBKGroundS,RtBKGroundS,singCellG,singCellR,sizeCellG,sizeCellR] = ComputeFluorescenceLevels_Bact ...
        (tfluo1,tfluo2,GtBKGround,RtBKGround,GtBKGroundS,RtBKGroundS,singCellG,singCellR, sizeCellG, sizeCellR, cutcorBACK, CitFreq, DicFreq, maxidD, Chan, CellDirs, ...
        BackDirs, cBack, mainDir, maxidF1, maxidF2, maxidF1b, maxidF2b, tempse, ident);
    
        save([mainDir,'\',ident,'_OutputFiles\TemporaryFluorescence1.mat'],'tfluo1');
        save([mainDir,'\',ident,'_OutputFiles\TemporaryFluorescence2.mat'],'tfluo2');
        save([mainDir,'\',ident,'_OutputFiles\TemporaryBackgroundGFP.mat'],'GtBKGround');
        save([mainDir,'\',ident,'_OutputFiles\TemporaryBackgroundRFP.mat'],'RtBKGround');
        save([mainDir,'\',ident,'_OutputFiles\TemporaryBackgroundShortGFP.mat'],'GtBKGroundS');
        save([mainDir,'\',ident,'_OutputFiles\TemporaryBackgroundShortRFP.mat'],'RtBKGroundS');
        save([mainDir,'\',ident,'_OutputFiles\TemporarySingleCellFluoGFP.mat'],'singCellG');
        save([mainDir,'\',ident,'_OutputFiles\TemporarySingleCellFluoRFP.mat'],'singCellR');
        save([mainDir,'\',ident,'_OutputFiles\TemporarySingleCellSizeGFP.mat'],'sizeCellG');
        save([mainDir,'\',ident,'_OutputFiles\TemporarySingleCellSizeRFP.mat'],'sizeCellR');
end



%% Plot results
for han=1:4
    if ishandle(han)
        close(han);
    end
end
try
    if ishandle(p1)
        close(p1);
    end
catch
end

switch Device
    case 'Yeast'
        time = 0:CitFreq:(length(tfluo)-1)*CitFreq;
        p1 = figure('Renderer', 'painters', 'Position', [100 100 800 500]);        
        
        hold on
        yyaxis left
        errorbar(time, tfluo(1,:), tfluo(2,:), 'g'); % Fluorescence Levels
        set(gca,'ycolor','g')
        title('Temporary Citrine Fluorescence')
        xlabel('time(min)')
        ylabel('Citrine(A.U.)')

        yyaxis right
        stairs(INP(2,:), INP(1,:), 'b') % Input design
        set(gca,'ycolor','b')
        ylabel('IPTG(\muM)')
        hold off

        try
            saveas(gcf,[webPath,'\',ident,'-FluorescencePlots.png']);
        catch
            warning('Problem Saving Citrine Image');
        end
        
        % Dye
        p2 = figure('Renderer', 'painters', 'Position', [1000 300 800 600]);
        hold on
        yyaxis left
        errorbar(time,tSulf(1,:), tSulf(2,:), 'r')
        set(gca,'ycolor','r')
        % saveas(gcf,'Test.png')
        if strcmp(Chan.Dye, 'Sulforhodamine')
            title('Temporary Sulforhodamine Fluorescence')
            xlabel('time(min)')
            ylabel('Sulforhodamine(A.U.)')
        elseif strcmp(Chan.Dye, 'cy5')
            title('Temporary Sulfo-Cy5 Carboxilic Acid Fluorescence')
            xlabel('time(min)')
            ylabel('Sulfo-Cy5 Carboxilic Acid (A.U.)')
        end
        xlim([0,(length(tfluo)-1)*5])

        yyaxis right
        stairs(INP(2,:), INP(1,:), 'b') % Input design
        set(gca,'ycolor','b')
        ylabel('IPTG(\muM)')
        hold off

        try
            saveas(gcf, [webPath,'\',ident,'-Dye.png']);
        catch
            warning('Problem Saving Dye Image');
        end

        
        
        try
            filePattern1 = fullfile(CellDirs{1,1}, 'exp*DIC_001.png');
            filePattern2 = fullfile(CellDirs{1,1}, ['exp*',Chan.Flu1,'_001.png']);
            filePattern4 = fullfile(CellDirs{1,1}, ['exp*',Chan.Dye,'_001.png']);
            Files1 = dir(filePattern1);
            Files2 = dir(filePattern2);
            Files4 = dir(filePattern4);

            d = imread([Files1(end).folder, '\CutDIC\', Files1(end).name]);
            m = imread([Files1(end).folder, '\Segmentation\', strrep(Files1(end).name,'png','tif')]);
            g = imread([Files2(end).folder, '\CutCitrine\', Files2(end).name]);
            dy = imread([Files4(end).folder, '\CutDye\', Files4(end).name]);

            imwrite(mat2gray(d), [webPath,'\',ident,'-LastDIC_Cells','.png'])
            imwrite(mat2gray(m), [webPath,'\',ident,'-LastMask_Cells','.png'])
            imwrite(mat2gray(g), [webPath,'\',ident,'-LastFluo_Cells','.png'])
            imwrite(mat2gray(dy), [webPath,'\',ident,'-LastDye_Cells','.png'])

            ins = 0;
            if ~isempty(cutcorBACK{1,1})
                ins = ins+1;
                if ~isempty(cutcorBACK{1,2})
                    ins = ins+1;
                end
            end
                
            for di=1:ins
                filePattern1 = fullfile(BackDirs{1,1}, 'exp*DIC_001.png');
                filePattern2 = fullfile(BackDirs{1,1}, ['exp*',Chan.Flu1,'_001.png']);
                filePattern4 = fullfile(BackDirs{1,1}, ['exp*',Chan.Dye,'_001.png']);
                Files1 = dir(filePattern1);
                Files2 = dir(filePattern2);
                Files4 = dir(filePattern4);
                
                if di==1
                    d = imread([Files1(end).folder, '\CutDICBackOne\', Files1(end).name]);
                    m = imread([Files1(end).folder, '\SegmentationOne\', strrep(Files1(end).name,'png','tif')]);
                    g = imread([Files2(end).folder, '\CutCitrineBackOne\', Files2(end).name]);
                    dy = imread([Files4(end).folder, '\CutDyeBackOne\', Files4(end).name]);
                elseif di==2
                    d = imread([Files1(end).folder, '\CutDICBackTwo\', Files1(end).name]);
                    m = imread([Files1(end).folder, '\SegmentationTwo\', strrep(Files1(end).name,'png','tif')]);
                    g = imread([Files2(end).folder, '\CutCitrineBackTwo\', Files2(end).name]);
                    dy = imread([Files4(end).folder, '\CutDyeBackTwo\', Files4(end).name]);
                end
                imwrite(mat2gray(d), [webPath,'\',ident,'-LastDIC_Back',num2str(di),'.png'])
                imwrite(mat2gray(m), [webPath,'\',ident,'-LastMask_Back',num2str(di),'.png'])
                imwrite(mat2gray(g), [webPath,'\',ident,'-LastFluo_Back',num2str(di),'.png'])
                imwrite(mat2gray(dy), [webPath,'\',ident,'-LastDye_Back',num2str(di),'.png'])

            end


        catch
            warning('Problem Ploting current time-frame');
        end
        
    case 'Bacteria'
        time = 0:CitFreq:(length(tfluo1)-1)*CitFreq;
        
        p1 = figure('Renderer', 'painters', 'Position', [000 000 1400 1000]);
        % GFP
        subplot(5,1,1:2);
        hold on
        errorbar(time, tfluo1(1,:), tfluo1(2,:), 'g'); % Fluorescence Levels
        set(gca,'ycolor','g')
        title('Temporary GFP Fluorescence')
        ylabel('GFP (A.U.)')
        xlim([time(1), time(end)])

        % RFP
        subplot(5,1,3:4); 
        hold on
        errorbar(time, tfluo2(1,:), tfluo2(2,:), 'r'); % Fluorescence Levels
        set(gca,'ycolor','r')
        title('Temporary RFP Fluorescence')
        ylabel('RFP (A.U.)')
        xlim([time(1), time(end)])

        % Inputs
        subplot(5,1,5); 
        hold on
        yyaxis left % Input 1
        if strcmp(IndInf.Inducer1, 'IPTG')
            stairs(INP(2,:), INP(1,:), 'b') % Input design
            set(gca,'ycolor','b')
            if strcmp(IndInf.Ind1Unit(1), 'u')
                ylabel(['IPTG(\mu',IndInf.Ind1Unit(2:end),')'])
            else
                ylabel(['IPTG(',IndInf.Ind1Unit,')'])
            end
        elseif strcmp(IndInf.Inducer1, 'aTc')
            stairs(INP(2,:), INP(1,:), 'm') % Input design
            set(gca,'ycolor','m')
            if strcmp(IndInf.Ind1Unit(1), 'u')
                ylabel(['aTc(\mu',IndInf.Ind1Unit(2:end),')'])
            else
                ylabel(['aTc(',IndInf.Ind1Unit,')'])
            end
        end
        title('Input(s) Profile')
        xlabel('time(min)')


        yyaxis right % Input 2
        if strcmp(IndInf.Inducer2, 'IPTG')
            stairs(time, Ind2, 'b') % Input design
            set(gca,'ycolor','b')
            if strcmp(IndInf.Ind2Unit(1), 'u')
                ylabel(['IPTG(\mu',IndInf.Ind2Unit(2:end),')'])
            else
                ylabel(['IPTG(',IndInf.Ind2Unit,')'])
            end
        elseif strcmp(IndInf.Inducer2, 'aTc')
            stairs(time, Ind2, 'm') % Input design
            set(gca,'ycolor','m')
            if strcmp(IndInf.Ind2Unit(1), 'u')
                ylabel(['aTc(\mu',IndInf.Ind2Unit(2:end),')'])
            else
                ylabel(['aTc(',IndInf.Ind2Unit,')'])
            end
        else
            if strcmp(IndInf.Inducer1, 'IPTG')
                stairs(time, zeros(1,length(time)), 'm') % Input design
                set(gca,'ycolor','m')
                ylabel(['aTc(0)'])
            elseif strcmp(IndInf.Inducer1, 'aTc')
                stairs(time, zeros(1,length(time)), 'b') % Input design
                set(gca,'ycolor','b')
                ylabel(['IPTG(0)'])
            end
        end
        hold off

        try
            saveas(gcf,[webPath,'\',ident,'-FluorescencePlots.png'])
        catch
            warning('Problem Saving Fluorescence Image');
        end
        
        
        % Fluorescent Dye
        try
            if ishandle(p2)
                close(p2);
            end
        catch
        end

        p2 = figure('Renderer', 'painters', 'Position', [1000 300 800 600]);
        hold on
        yyaxis left
        errorbar(time, tSulf(1,:), tSulf(2,:), 'r'); % Fluorescence Levels
        set(gca,'ycolor','r')
        xlabel('time(min)')
        if strcmp(Chan.Dye, 'cy5')
            title('Temporary Sulfo-Cy5 Carboxilic Acid Fluorescence')
        else
            title(['Temporary ',Chan.Dye,' Fluorescence'])
        end
        ylabel([Chan.Dye,' (A.U.)'])
        xlim([0,(length(tfluo1)-1)*5])


        yyaxis right
        if strcmp(IndInf.Inducer1, 'IPTG')
            stairs(INP(2,:), INP(1,:), 'b') % Input design
            set(gca,'ycolor','b')
            if strcmp(IndInf.Ind1Unit(1), 'u')
                ylabel(['IPTG(\mu',IndInf.Ind1Unit(2:end),')'])
            else
                ylabel(['IPTG(',IndInf.Ind1Unit,')'])
            end
        elseif strcmp(IndInf.Inducer1, 'aTc')
            stairs(INP(2,:), INP(1,:), 'm') % Input design
            set(gca,'ycolor','m')
            if strcmp(IndInf.Ind1Unit(1), 'u')
                ylabel(['aTc(\mu',IndInf.Ind1Unit(2:end),')'])
            else
                ylabel(['aTc(',IndInf.Ind1Unit,')'])
            end
        end
        hold off

        try
            saveas(gcf,[webPath,'\',ident,'-Dye.png'])
        catch
            warning('Problem Saving Dye Image');
        end
        
        
        try
            for di=1:length(CellDirs)
                filePattern1 = fullfile(CellDirs{1,di}, 'exp*DIC_001.png');
                filePattern2 = fullfile(CellDirs{1,di}, ['exp*',Chan.Flu1,'_001.png']);
                filePattern3 = fullfile(CellDirs{1,di}, ['exp*',Chan.Flu2,'_001.png']);
                filePattern4 = fullfile(CellDirs{1,di}, ['exp*',Chan.Dye,'_001.png']);
                Files1 = dir(filePattern1);
                Files2 = dir(filePattern2);
                Files3 = dir(filePattern3);
                Files4 = dir(filePattern4);

                d = imread([Files1(end).folder, '\CutDIC\', Files1(end).name]);
                m = imread([Files1(end).folder, '\Segmentation\', strrep(Files1(end).name,'png','tif')]);
                g = imread([Files2(end).folder, '\CutFluo1\', Files2(end).name]);
                r = imread([Files3(end).folder, '\CutFluo2\', Files3(end).name]);
                dy = imread([Files4(end).folder, '\CutDye\', Files4(end).name]);

                imwrite(mat2gray(d), [webPath,'\',ident,'-LastDIC_Cells_Pos',num2str(di),'.png'])
                imwrite(mat2gray(m), [webPath,'\',ident,'-LastMask_Cells_Pos',num2str(di),'.png'])
                imwrite(mat2gray(g), [webPath,'\',ident,'-LastFluo1_Cells_Pos',num2str(di),'.png'])
                imwrite(mat2gray(r), [webPath,'\',ident,'-LastFluo2_Cells_Pos',num2str(di),'.png'])
                imwrite(mat2gray(dy), [webPath,'\',ident,'-LastDye_Cells_Pos',num2str(di),'.png'])

            end

            for di=1:length(BackDirs)
                filePattern1 = fullfile(BackDirs{1,di}, 'exp*DIC_001.png');
                filePattern2 = fullfile(BackDirs{1,di}, ['exp*',Chan.Flu1,'_001.png']);
                filePattern3 = fullfile(BackDirs{1,di}, ['exp*',Chan.Flu2,'_001.png']);
                filePattern4 = fullfile(BackDirs{1,di}, ['exp*',Chan.Dye,'_001.png']);
                Files1 = dir(filePattern1);
                Files2 = dir(filePattern2);
                Files3 = dir(filePattern3);
                Files4 = dir(filePattern4);

                d = imread([Files1(end).folder, '\CutDIC\', Files1(end).name]);
                m = imread([Files1(end).folder, '\Segmentation\', strrep(Files1(end).name,'png','tif')]);
                g = imread([Files2(end).folder, '\CutFluo1\', Files2(end).name]);
                r = imread([Files3(end).folder, '\CutFluo2\', Files3(end).name]);
                dy = imread([Files4(end).folder, '\CutDye\', Files4(end).name]);

                imwrite(mat2gray(d), [webPath,'\',ident,'-LastDIC_Back_Pos',num2str(di),'.png'])
                imwrite(mat2gray(m), [webPath,'\',ident,'-LastMask_Back_Pos',num2str(di),'.png'])
                imwrite(mat2gray(g), [webPath,'\',ident,'-LastFluo1_Back_Pos',num2str(di),'.png'])
                imwrite(mat2gray(r), [webPath,'\',ident,'-LastFluo2_Back_Pos',num2str(di),'.png'])
                imwrite(mat2gray(dy), [webPath,'\',ident,'-LastDye_Back_Pos',num2str(di),'.png'])

            end


        catch
            warning('Problem Ploting current time-frame');
        end
end



catch err
    %% Potential Errors that can occur
    
    RemoveUnparedImages(CellDirs, Chan, DicFreq, CitFreq);
    RemoveUnparedImages(BackDirs, Chan, DicFreq, CitFreq);
            
    filePattern1 = fullfile(CellDirs{1,1}, 'exp*DIC_001.png');
    Files1 = dir(filePattern1);
    
    %open file
    errorFile = ['Error-',erase(Files1(end).name,'.png'),'.errorLog'];
    fid = fopen(errorFile,'a+');
    fprintf(fid, '%s', err.getReport('extended', 'hyperlinks','off'));
    % close file
    fclose(fid);
end
end






