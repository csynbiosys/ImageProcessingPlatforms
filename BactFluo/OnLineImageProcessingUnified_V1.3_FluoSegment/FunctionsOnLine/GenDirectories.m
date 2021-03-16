

function [] = GenDirectories(pDIC, cutcorBACK1,cutcorBACK2, bacpat)
    %% Generate necessary directories if they do not exist
if ~exist([pDIC,'\Segmentation'],'dir')
    mkdir([pDIC,'\Segmentation']);
    addpath([pDIC,'\Segmentation']);
end
if ~exist([pDIC,'\CutDIC'],'dir')
    mkdir([pDIC,'\CutDIC']);
    addpath([pDIC,'\CutDIC']);
end
if ~exist([pDIC,'\CutCitrine'],'dir')
    mkdir([pDIC,'\CutCitrine']);
    addpath([pDIC,'\CutCitrine']);
end
if ~exist([pDIC,'\CutDye'],'dir')
    mkdir([pDIC,'\CutDye']);
    addpath([pDIC,'\CutDye']);
end
if ~exist([pDIC,'\Segmentation\Components'],'dir')
    mkdir([pDIC,'\Segmentation\Components']);
    addpath([pDIC,'\Segmentation\Components']);
end

if ~isempty(cutcorBACK1)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if ~exist([bacpat,'\CutDICBackOne'],'dir')
        mkdir([bacpat,'\CutDICBackOne']);                         %
        addpath([bacpat,'\CutDICBackOne']);
    end                                                        %
    if ~exist([bacpat,'\CutDICBackTwo'],'dir') && ~isempty(cutcorBACK2)
        mkdir([bacpat,'\CutDICBackTwo']);                         %
        addpath([bacpat,'\CutDICBackTwo']);
    end                                                        % SECOND POSITION
    if ~exist([bacpat,'\CutCitrineBackOne'],'dir')
        mkdir([bacpat,'\CutCitrineBackOne']);                         %
        addpath([bacpat,'\CutCitrineBackOne']);
    end                                                        %
    if ~exist([bacpat,'\CutCitrineBackTwo'],'dir') && ~isempty(cutcorBACK2)
        mkdir([bacpat,'\CutCitrineBackTwo']);                         %
        addpath([bacpat,'\CutCitrineBackTwo']);
    end                              
    if ~exist([bacpat,'\CutDyeBackOne'],'dir')
        mkdir([bacpat,'\CutDyeBackOne']);                         %
        addpath([bacpat,'\CutDyeBackOne']);
    end                                                        %
    if ~exist([bacpat,'\CutDyeBackTwo'],'dir') && ~isempty(cutcorBACK2)
        mkdir([bacpat,'\CutDyeBackTwo']);                         %
        addpath([bacpat,'\CutDyeBackTwo']);
    end                              
    if ~exist([bacpat,'\SegmentationOne'],'dir')
        mkdir([bacpat,'\SegmentationOne']);                    %
        addpath([bacpat,'\SegmentationOne']);
    end                                                        %                      
    if ~exist([bacpat,'\SegmentationTwo'],'dir') && ~isempty(cutcorBACK2)
        mkdir([bacpat,'\SegmentationTwo']);                    %
        addpath([bacpat,'\SegmentationTwo']);
    end                                                        %
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end