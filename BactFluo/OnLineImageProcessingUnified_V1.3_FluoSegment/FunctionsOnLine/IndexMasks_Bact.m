
function [] = IndexMasks_Bact(CellDirs, Device, ident)

    for di = 1:length(CellDirs)
        filePattern4a = fullfile([CellDirs{1,di},'\Segmentation'], 'exp*GFP_001.tif');
        filePattern4b = fullfile([CellDirs{1,di},'\Segmentation'], 'exp*mKate2_001.tif');
        Files4a = dir(filePattern4a);
        Files4b = dir(filePattern4b);
        % Get number of frames for channel
        maxidMa=length(Files4a);
        maxidMb=length(Files4b);

        for i=1:maxidMa 
            if ~isfile([CellDirs{1,di},'\Segmentation\Components\imgG_',num2str(i, '%.3u'),'.tif'])

                x = imread([CellDirs{1,di},'\Segmentation\',Files4a(i).name]);
                [x,y] = CorrectSegmentsFull(x, Device); 
                x2 = mat2gray(x);
                L = bwlabel(x2,4);
                L = ResizeIm(L,y);
                f = L;
                save([CellDirs{1,di},'\Segmentation\Components\SegmentG',int2str(i),'.mat'], 'f')

                % Generate Python script with all the specifications
                num = num2str(i,'%.3u');
                fil = fopen([CellDirs{1,di},'\Segmentation\Components\',ident,'-PythonAnotateImageGFP.py'], 'w');

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
                fprintf(fil, ['im = sio.loadmat(r''',dir1,'\\Components\\SegmentG',num2str(i), '.mat'')']);

                fprintf(fil, '\n');
                fprintf(fil, 'k = im[''f'']');
                fprintf(fil, '\n');
                fprintf(fil, 'img = Image.fromarray(k)');
                fprintf(fil, '\n');
                fprintf(fil, ['img.save(r''',dir1,'\\Components\\imgG_',num,'.tif'')']);
                fprintf(fil, '\n');
                fprintf(fil, '\n');

                fclose(fil);

                % Run Python script
        %         addpath 'D:\David\python'
        %         addpath 'C:\Program Files\MATLAB\R2018b\bin\win64'
                system(['python "',CellDirs{1,di},'\Segmentation\Components\',ident,'-PythonAnotateImageGFP.py"']);
            end
        end
        
        
        for i=1:maxidMb 
            if ~isfile([CellDirs{1,di},'\Segmentation\Components\imgR_',num2str(i, '%.3u'),'.tif'])

                x = imread([CellDirs{1,di},'\Segmentation\',Files4b(i).name]);
                [x,y] = CorrectSegmentsFull(x, Device); 
                x2 = mat2gray(x);
                L = bwlabel(x2,4);
                L = ResizeIm(L,y);
                f = L;
                save([CellDirs{1,di},'\Segmentation\Components\SegmentR',int2str(i),'.mat'], 'f')

                % Generate Python script with all the specifications
                num = num2str(i,'%.3u');
                fil = fopen([CellDirs{1,di},'\Segmentation\Components\',ident,'-PythonAnotateImageRFP.py'], 'w');

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
                fprintf(fil, ['im = sio.loadmat(r''',dir1,'\\Components\\SegmentR',num2str(i), '.mat'')']);

                fprintf(fil, '\n');
                fprintf(fil, 'k = im[''f'']');
                fprintf(fil, '\n');
                fprintf(fil, 'img = Image.fromarray(k)');
                fprintf(fil, '\n');
                fprintf(fil, ['img.save(r''',dir1,'\\Components\\imgR_',num,'.tif'')']);
                fprintf(fil, '\n');
                fprintf(fil, '\n');

                fclose(fil);

                % Run Python script
        %         addpath 'D:\David\python'
        %         addpath 'C:\Program Files\MATLAB\R2018b\bin\win64'
                system(['python "',CellDirs{1,di},'\Segmentation\Components\',ident,'-PythonAnotateImageRFP.py"']);
            end
        end
    end


end


