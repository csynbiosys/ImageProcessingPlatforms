
%%
function [] = CheckFileTransfer_YST(pDIC, ident, datenow)

    % Check if the hard drive is connected (so if the directory exists)
    % ---------------- TO CHANGEEEEEEE
    exDrive = 'D:\PhD\Year_1\2019_07_31_OEDinVivo\Scripts\ImageProcessing\MoveFilesToExternalDrive\DestinationTest';
    if ~exist(exDrive, 'dir')
        disp('---------------- Images NOT transfered to external hard drive (make sure it is connected and turned on) ----------------')
        return;
    end
    
    % Folder for Microfluidic experiments Yeast device
    if ~exist([exDrive,'\YeastMicrofluidics'], 'dir')
       mkdir([exDrive,'\YeastMicrofluidics'])
    end
    
    indes = 1:1000000;
    
    Files1 = dir([exDrive,'\YeastMicrofluidics\*_YST']); % Check previous directories of experiments
    if isempty(Files1) % Check if it is the first experiment of all 
        mkdir([exDrive,'\YeastMicrofluidics\0000001_',ident,'_',datenow,'_YST'])
        copyfile([pDIC, '\..'], [exDrive,'\YeastMicrofluidics\0000001_',ident,'_',datenow,'_YST'])
        disp('...... Transfering files to external drive ......')
    else
        ldn = Files1(end).name; % last directory name
        nus = str2double(ldn(1:7));
        mkdir([exDrive,'\YeastMicrofluidics\',num2str(nus+1,'%.7u'),'_',ident,'_',datenow,'_YST'])
        copyfile([pDIC, '\..'], [exDrive,'\YeastMicrofluidics\',num2str(nus+1,'%.7u'),'_',ident,'_',datenow,'_YST'])
        disp('...... Transfering files to external drive ......')
    end
    
    disp('---------------- Images transfered to external hard drive ----------------')




end




























