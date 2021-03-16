% In the catch section of the ImProcSegm script


function [] = RemoveUnparedImages(CBDirs, Chan, DicFreq, CitFreq)
    
    rat = CitFreq/DicFreq;
    for di=1:length(CBDirs) % Loop over all directories from CBDirs
        % Get number of specific files in directory
        filePattern1 = fullfile(CBDirs{1,di}, ['exp*',Chan.Flu1,'_001.png']);
        filePattern2 = fullfile(CBDirs{1,di}, ['exp*',Chan.Flu2,'_001.png']);
        filePattern3 = fullfile(CBDirs{1,di}, ['exp*',Chan.Dye,'_001.png']);
        filePattern4 = fullfile(CBDirs{1,di}, ['exp*','DIC','_001.png']);
        Files1 = dir(filePattern1);
        Files2 = dir(filePattern2);
        Files3 = dir(filePattern3);
        Files4 = dir(filePattern4);
        % Get number of frames for channel
        maxidC=length(Files1);
        maxidS=length(Files2);
        maxidCy=length(Files3);
        maxidD=length(Files4);
        
        r = 1:rat:maxidD;
        
        % Loop over the number of images that are unpaired plus one (the
        % unpaired)
        for i=1:min([maxidC, maxidS, maxidCy, maxidD])
            % Check if there is a discrepancy between the numbers in all
            % the tipes of images
            
            % Combinations without repetitions = n!/(r!(n-r)!) where n is
            % the number of elements and r the group of combinations
            if ~strcmp(Files1(i).name(1:10), Files2(i).name(1:10)) || ~strcmp(Files1(i).name(1:10), Files3(i).name(1:10)) || ...
                    ~strcmp(Files2(i).name(1:10), Files3(i).name(1:10)) || ~strcmp(Files4(r(i)).name(1:10), Files2(i).name(1:10)) || ...
                    ~strcmp(Files4(r(i)).name(1:10), Files3(i).name(1:10)) || ~strcmp(Files4(r(i)).name(1:10), Files1(i).name(1:10))
                
                % Make directory to store metadata if it doesn't exist
                if ~exist([CBDirs{1,di},'\UnpairedImages'],'dir')
                    mkdir([CBDirs{1,di},'\UnpairedImages']);
                    addpath([CBDirs{1,di},'\UnpairedImages']);
                end
                
                % Get the number identifier of the files
                unC = str2double(Files1(i).name(8:10));
                unS = str2double(Files2(i).name(8:10));
                unCy = str2double(Files3(i).name(8:10));
                unD = str2double(Files4(i).name(8:10));

                % Copy the existing unpaired images in the metadata
                % directory just in case
                try
                    copyfile([CBDirs{1,di},'\',num2str(min([unC,unS,unCy,unD]), ['exp_000%.3u_',Chan.Flu1,'_001.png'])],...
                        [CBDirs{1,di},'\UnpairedImages'])
                catch
                end
                try
                    copyfile([CBDirs{1,di},'\',num2str(min([unC,unS,unCy,unD]), ['exp_000%.3u_',Chan.Flu2,'_001.png'])],...
                        [CBDirs{1,di},'\UnpairedImages'])
                catch
                end
                try
                    copyfile([CBDirs{1,di},'\',num2str(min([unC,unS,unCy,unD]), ['exp_000%.3u_',Chan.Dye,'_001.png'])], ...
                        [CBDirs{1,di},'\UnpairedImages'])
                catch
                end
                try
                    copyfile([CBDirs{1,di},'\',num2str(min([unC,unS,unCy,unD]), ['exp_000%.3u_','DIC','_001.png'])], ...
                        [CBDirs{1,di},'\UnpairedImages'])
                catch
                end
                
                % Get the name of the position been checked
                out=regexp(CBDirs{di},'\','split');
                pos = out{end};

                subs = zeros(1024,1024)+400; % Empty image to put in the place of the missing one
                
                % Check wich is the missing image
                if max([unC,unS,unCy,unD]) == unC
                    % Write empty image so the main script can continue
                    imwrite(uint16(subs), [CBDirs{1,di},'\',num2str(min([unC,unS,unCy,unD]), ['exp_000%.3u_',Chan.Flu1,'_001.png'])]);
                    
                    % Open the missing image log file if it exists (to not
                    % overwrite things)
                    try
                        fi = fopen([CBDirs{1,di},'\UnpairedImages\','MissFrame',num2str(min([unC,unS,unCy,unD])),'.txt'],'r');
                        pret = fscanf(fi, '%c');
                        fclose(fi);
                    catch
                    end
                    % Open or generate missing image log file
                    fid = fopen([CBDirs{1,di},'\UnpairedImages\','MissFrame',num2str(min([unC,unS,unCy,unD])),'.txt'],'wt');
                    % Add information of the missing image
                    fprintf(fid, [Chan.Flu1, ' frame ',num2str(min([unC,unS,unCy,unD])),' is missing in ', pos, ' \n']);
                    % If something was already in the file, add that too so
                    % it doesn't get lost
                    try
                        fprintf(fid, [pret]);
                    catch
                    end
                    % Close text file
                    fclose(fid);
                elseif max([unC,unS,unCy,unD]) == unS
                    imwrite(uint16(subs), [CBDirs{1,di},'\',num2str(min([unC,unS,unCy,unD]), ['exp_000%.3u_',Chan.Flu2,'_001.png'])]);
                    
                    try
                        fi = fopen([CBDirs{1,di},'\UnpairedImages\','MissFrame',num2str(min([unC,unS,unCy,unD])),'.txt'],'r');
                        pret = fscanf(fi, '%c');
                        fclose(fi);
                    catch
                    end
                    fid = fopen([CBDirs{1,di},'\UnpairedImages\','MissFrame',num2str(min([unC,unS,unCy,unD])),'.txt'],'wt');
                    fprintf(fid, [Chan.Flu2, ' frame ',num2str(min([unC,unS,unCy,unD])),' is missing in ', pos,' \n']);
                    try
                        fprintf(fid, [pret]);
                    catch
                    end
                    fclose(fid);
                    
                elseif max([unC,unS,unCy,unD]) == unCy
                    imwrite(uint16(subs), [CBDirs{1,di},'\',num2str(min([unC,unS,unCy,unD]), ['exp_000%.3u_',Chan.Dye,'_001.png'])]);
                    
                    try
                        fi = fopen([CBDirs{1,di},'\UnpairedImages\','MissFrame',num2str(min([unC,unS,unCy,unD])),'.txt'],'r');
                        pret = fscanf(fi, '%c');
                        fclose(fi);
                    catch
                    end
                    
                    fid = fopen([CBDirs{1,di},'\UnpairedImages\','MissFrame',num2str(min([unC,unS,unCy,unD])),'.txt'],'wt');
                    fprintf(fid, [Chan.Dye, ' frame ',num2str(min([unC,unS,unCy,unD])),' is missing in ', pos,' \n']);
                    try
                        fprintf(fid, [pret]);
                    catch
                    end
                    fclose(fid);
                    
                elseif max([unC,unS,unCy,unD]) == unD
                    imwrite(uint16(subs), [CBDirs{1,di},'\',num2str(min([unC,unS,unCy,unD]), ['exp_000%.3u_','DIC','_001.png'])]);
                    try
                        fi = fopen([CBDirs{1,di},'\UnpairedImages\','MissFrame',num2str(min([unC,unS,unCy,unD])),'.txt'],'r');
                        pret = fscanf(fi, '%c');
                        fclose(fi);
                    catch
                    end
                    fid = fopen([CBDirs{1,di},'\UnpairedImages\','MissFrame',num2str(min([unC,unS,unCy,unD])),'.txt'],'wt');
                    
                    fprintf(fid, ['DIC', ' frame ',num2str(min([unC,unS,unCy,unD])),' is missing in ', pos, '\n']);
                    try
                        fprintf(fid, [pret]);
                    catch
                    end
                    fclose(fid);    

                end

                return
            end
            
        
        end
    
%         % Loop to check missing DIC images that do not have a paired
%         % fluorescent image (if you skep fluorescence at some time points)
%         for i=1:maxidD
%             
%             
%         end
        
        
    end
    
end


