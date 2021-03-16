
% Put after deffinition of bacpat

function [] = CheckEmptyFoldersP2(bacpat, answer)

    switch answer
        case 'Yes'
            if exist([bacpat,'\CutDICBackOne'],'dir')
                rmdir([bacpat,'\CutDICBackOne'], 's')
            end                                                        %
            if exist([bacpat,'\CutDICBackTwo'],'dir')
                rmdir([bacpat,'\CutDICBackTwo'], 's')
            end                                                        % SECOND POSITION
            if exist([bacpat,'\CutCitrineBackOne'],'dir')
                rmdir([bacpat,'\CutCitrineBackOne'], 's')
            end                                                        %
            if exist([bacpat,'\CutCitrineBackTwo'],'dir')
                rmdir([bacpat,'\CutCitrineBackTwo'], 's')
            end                              
            if exist([bacpat,'\CutDyeBackOne'],'dir')
                rmdir([bacpat,'\CutDyeBackOne'], 's')
            end                                                        %
            if exist([bacpat,'\CutDyeBackTwo'],'dir')
                rmdir([bacpat,'\CutDyeBackTwo'], 's')
            end
            if exist([bacpat,'\SegmentationOne'],'dir')
                rmdir([bacpat,'\SegmentationOne'], 's')
            end                                                        %                      
            if exist([bacpat,'\SegmentationTwo'],'dir')
                rmdir([bacpat,'\SegmentationTwo'], 's')
            end                                                        %
    end


end