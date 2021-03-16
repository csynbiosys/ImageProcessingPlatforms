

function [] = GenDirectories_Bact(CellDirs, BackDirs)
    %% Generate necessary directories if they do not exist

for i=1:length(CellDirs)    
    if ~exist([CellDirs{1,i},'\Segmentation'],'dir')
        mkdir([CellDirs{1,i},'\Segmentation']);
        addpath([CellDirs{1,i},'\Segmentation']);
    end
    if ~exist([CellDirs{1,i},'\CutDIC'],'dir')
        mkdir([CellDirs{1,i},'\CutDIC']);
        addpath([CellDirs{1,i},'\CutDIC']);
    end
    if ~exist([CellDirs{1,i},'\CutFluo1'],'dir')
        mkdir([CellDirs{1,i},'\CutFluo1']);
        addpath([CellDirs{1,i},'\CutFluo1']);
    end
    if ~exist([CellDirs{1,i},'\CutFluo2'],'dir')
        mkdir([CellDirs{1,i},'\CutFluo2']);
        addpath([CellDirs{1,i},'\CutFluo2']);
    end
    if ~exist([CellDirs{1,i},'\CutDye'],'dir')
        mkdir([CellDirs{1,i},'\CutDye']);
        addpath([CellDirs{1,i},'\CutDye']);
    end
    if ~exist([CellDirs{1,i},'\Segmentation\Components'],'dir')
        mkdir([CellDirs{1,i},'\Segmentation\Components']);
        addpath([CellDirs{1,i},'\Segmentation\Components']);
    end
end

for i=1:length(BackDirs)
    
    if ~exist([BackDirs{1,i},'\Segmentation'],'dir')
        mkdir([BackDirs{1,i},'\Segmentation']);
        addpath([BackDirs{1,i},'\Segmentation']);
    end
    if ~exist([BackDirs{1,i},'\CutDIC'],'dir')
        mkdir([BackDirs{1,i},'\CutDIC']);
        addpath([BackDirs{1,i},'\CutDIC']);
    end
    if ~exist([BackDirs{1,i},'\CutFluo1'],'dir')
        mkdir([BackDirs{1,i},'\CutFluo1']);
        addpath([BackDirs{1,i},'\CutFluo1']);
    end
    if ~exist([BackDirs{1,i},'\CutFluo2'],'dir')
        mkdir([BackDirs{1,i},'\CutFluo2']);
        addpath([BackDirs{1,i},'\CutFluo2']);
    end
    if ~exist([BackDirs{1,i},'\CutDye'],'dir')
        mkdir([BackDirs{1,i},'\CutDye']);
        addpath([BackDirs{1,i},'\CutDye']);
    end
    
end


end