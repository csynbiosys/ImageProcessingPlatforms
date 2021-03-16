


function [] = IndexMasks_Yeast(CellDirs, Device, ident)

    for di = 1:length(CellDirs)
        filePattern4 = fullfile([CellDirs{1,di},'\Segmentation'], 'exp*DIC_001.tif');
        Files4 = dir(filePattern4);
        % Get number of frames for channel
        maxidM=length(Files4);

        for i=1:maxidM 
            if ~isfile([CellDirs{1,di},'\Segmentation\Components\img_',num2str(i, '%.3u'),'.tif'])

                x = imread([CellDirs{1,di},'\Segmentation\',Files4(i).name]);
                [x,y] = CorrectSegmentsFull(x, Device); 
                x2 = mat2gray(x);
                L = bwlabel(x2,4);
                L = ResizeIm(L,y);
                f = L;
                save([CellDirs{1,di},'\Segmentation\Components\Segment',int2str(i),'.mat'], 'f')

                % Generate Python script with all the specifications
                num = num2str(i,'%.3u');
                fil = fopen([CellDirs{1,di},'\Segmentation\Components\',ident,'-PythonAnotateImage.py'], 'w');

                fprintf(fil, '# -*- coding: utf-8 -*-');
                fprintf(fil, '\n');
                fprintf(fil, 'import scipy');
                fprintf(fil, '\n');
                fprintf(fil, 'from os.path import dirname, join as pjoin');
                fprintf(fil, '\n');
                fprintf(fil, 'import scipy.io as sio');
                fprintf(fil, '\n');
                fprintf(fil, 'from PIL import Image');
                fprintf(fil, '\n');
                fprintf(fil, 'import numpy as np');
                fprintf(fil, '\n \n');

                dir1 = strrep([CellDirs{1,di},'\Segmentation'],'\1','\\1');
                dir1 = strrep([dir1],'\2','\\2');
                dir1 = strrep([dir1],'\3','\\3');
                dir1 = strrep([dir1],'\4','\\4');
                dir1 = strrep([dir1],'\5','\\5');
                dir1 = strrep([dir1],'\6','\\6');
                dir1 = strrep([dir1],'\7','\\7');
                dir1 = strrep([dir1],'\8','\\8');
                dir1 = strrep([dir1],'\9','\\9');
                dir1 = strrep([dir1],'\0','\\0');
                dir1 = strrep(dir1,'\','\\');
                fprintf(fil, ['im = sio.loadmat(r''',dir1,'\\Components\\Segment',num2str(i), '.mat'')']);

                fprintf(fil, '\n');
                fprintf(fil, 'k = im[''f'']');
                fprintf(fil, '\n');
                fprintf(fil, 'img = Image.fromarray(k)');
                fprintf(fil, '\n');
                fprintf(fil, ['img.save(r''',dir1,'\\Components\\img_',num,'.tif'')']);
                fprintf(fil, '\n');
                fprintf(fil, '\n');

                fclose(fil);

                % Run Python script
        %         addpath 'D:\David\python'
        %         addpath 'C:\Program Files\MATLAB\R2018b\bin\win64'
                system(['python "',CellDirs{1,di},'\Segmentation\Components\',ident,'-PythonAnotateImage.py"']);
            end
        end
    end


end






















