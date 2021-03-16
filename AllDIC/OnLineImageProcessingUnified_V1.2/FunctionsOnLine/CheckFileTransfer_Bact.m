

function [] = CheckFileTransfer_Bact(pDIC, ident, datenow)

    % Check if the hard drive is connected (so if the directory exists)
    % ---------------- TO CHANGEEEEEEE
    exDrive = 'D:\PhD\Year_1\2019_07_31_OEDinVivo\Scripts\ImageProcessing\MoveFilesToExternalDrive\DestinationTest';
    if ~exist(exDrive, 'dir')
        disp('---------------- Images NOT transfered to external hard drive (make sure it is connected and turned on) ----------------')
        return;
    end
    
    % Folder for Microfluidic experiments Yeast device
    if ~exist([exDrive,'\BacteriaMicrofluidics'], 'dir')
       mkdir([exDrive,'\BacteriaMicrofluidics'])
    end
    
    indes = 1:1000000;
    
    Files1 = dir([exDrive,'\BacteriaMicrofluidics\*_BCT']); % Check previous directories of experiments
    if isempty(Files1) % Check if it is the first experiment of all 
        mkdir([exDrive,'\BacteriaMicrofluidics\0000001_',ident,'_',datenow,'_BCT'])
        copyfile([pDIC, '\..'], [exDrive,'\BacteriaMicrofluidics\0000001_',ident,'_',datenow,'_BCT'])
        disp('...... Transfering files to external drive ......')
    else
        ldn = Files1(end).name; % last directory name
        nus = str2double(ldn(1:7));
        mkdir([exDrive,'\BacteriaMicrofluidics\',num2str(nus+1,'%.7u'),'_',ident,'_',datenow,'_BCT'])
        copyfile([pDIC, '\..'], [exDrive,'\BacteriaMicrofluidics\',num2str(nus+1,'%.7u'),'_',ident,'_',datenow,'_BCT'])
        disp('...... Transfering files to external drive ......')
    end
    
    disp('---------------- Images transfered to external hard drive ----------------')




end




























