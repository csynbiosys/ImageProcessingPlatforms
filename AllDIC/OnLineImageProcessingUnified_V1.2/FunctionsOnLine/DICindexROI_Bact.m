
%% Get indexes for the chamber ROI

% This function reads an initial DIC image from the traps, displays it
% with an initial sugested ROI size. The user can modify the ROI as desired
% and the function will output the selected ROI indexes.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INPUTS
% --------> CellDirs: Full path directories specified by the user where the
% initial test image to define the ROI is saved

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OUTPUTS
% --------> cutcor: array of matrix indexes of the ROIs

function [cutcor] = DICindexROI_Bact(Dirss)

    cutcor = cell(1,length(Dirss));
    pat = '*_DIC_001.png'; % Patern for the DIC image files
    
    for i=1:length(Dirss)
        
        Folder=[Dirss{1,i}];
        filePattern = fullfile(Folder, pat);
        Files = dir(filePattern);
        % Get number of frames for channel
        maxid=length(Files);
        
        if maxid==0
            disp('Please, take a DIC image from the chamber and try again or check if the directory path is correct.')
            return
        else
            % Read the image
            Ds=imread([Dirss{1,i},'\',Files(1).name]);

            % Default average ROI size
            indx = [100,100,728,506];

            % User selection and modification of the ROI
            figure;
            s = imshow(mat2gray(Ds));
            hBox = drawrectangle('Position',indx);

            h = msgbox('Finished??');
            set(h, 'position', [100 440 140 60]);
            uiwait(h);% roiPosition = wait(hBox);
            roiPosition=round(hBox.Position);
            close

            % ROI coordenates/indexes
            cutcor{1,i} = [roiPosition(2)+1, roiPosition(2)+(roiPosition(4)-1), roiPosition(1)+1, roiPosition(1)+(roiPosition(3)-1)];
            
        end
        
    end


end