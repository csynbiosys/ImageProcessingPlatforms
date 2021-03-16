
% Put after deffinition of pDIC

function [answer] = CheckEmptyFolders_Bact(CellDirs)

answer = '';
if exist([CellDirs{1,1},'\Segmentation'],'dir') || exist([CellDirs{1,1},'\CutDIC'],'dir') || exist([CellDirs{1,1},'\CutFluo1'],'dir') || ...
        exist([CellDirs{1,1},'\CutDye'],'dir') || exist([CellDirs{1,1},'\Segmentation\Components'],'dir') || exist([CellDirs{1,1},'\CutFluo2'],'dir') 

    answer = questdlg('Do you want to remove already processed images?');
end

for i=1:length(CellDirs)
    

        switch answer
            case 'Yes'
                if exist([CellDirs{1,i},'\Segmentation'],'dir')
                    rmdir([CellDirs{1,i},'\Segmentation'], 's')
                end
                if exist([CellDirs{1,i},'\CutDIC'],'dir')
                    rmdir([CellDirs{1,i},'\CutDIC'], 's')
                end
                if exist([CellDirs{1,i},'\CutFluo1'],'dir')
                    rmdir([CellDirs{1,i},'\CutFluo1'], 's')
                end
                if exist([CellDirs{1,i},'\CutFluo2'],'dir')
                    rmdir([CellDirs{1,i},'\CutFluo2'], 's')
                end
                if exist([CellDirs{1,i},'\CutDye'],'dir')
                    rmdir([CellDirs{1,i},'\CutDye'], 's')
                end
                if exist([CellDirs{1,i},'\Segmentation\Components'],'dir')
                    rmdir([CellDirs{1,i},'\Segmentation\Components'], 's')
                end
        end
    
    
end
end