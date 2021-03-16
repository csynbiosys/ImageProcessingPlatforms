
% Put after deffinition of pDIC

function [answer] = CheckEmptyFoldersP1(pDIC)

answer = '';
if exist([pDIC,'\Segmentation'],'dir') || exist([pDIC,'\CutDIC'],'dir') || exist([pDIC,'\CutCitrine'],'dir') || ...
        exist([pDIC,'\CutDye'],'dir') || exist([pDIC,'\Segmentation\Components'],'dir') 
    
    answer = questdlg('Do you want to remove already processed images?');
    
    switch answer
        case 'Yes'
            if exist([pDIC,'\Segmentation'],'dir')
                rmdir([pDIC,'\Segmentation'], 's')
            end
            if exist([pDIC,'\CutDIC'],'dir')
                rmdir([pDIC,'\CutDIC'], 's')
            end
            if exist([pDIC,'\CutCitrine'],'dir')
                rmdir([pDIC,'\CutCitrine'], 's')
            end
            if exist([pDIC,'\CutDye'],'dir')
                rmdir([pDIC,'\CutDye'], 's')
            end
            if exist([pDIC,'\Segmentation\Components'],'dir')
                rmdir([pDIC,'\Segmentation\Components'], 's')
            end
    end
end
end