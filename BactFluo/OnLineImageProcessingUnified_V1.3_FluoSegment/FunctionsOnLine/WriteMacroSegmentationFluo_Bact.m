
%% Write Macro ImageJ script to perform image segmentation

% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INPUTS
% --------> pDIC: Directory were the microscope images are going to be
% saved.
% --------> ident: identifier that will be added to the matlab structure
% containing all the cut images (string)
% --------> 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OUTPUTS
% --------> 


function [] = WriteMacroSegmentationFluo_Bact(pDIC,ident,IP,Cmod,RSA,cutcor)

for i=1:length(pDIC)
    if ~exist([pDIC{1,i},'\Segmentation'],'dir')
        mkdir([pDIC{1,i},'\Segmentation']);
        addpath([pDIC{1,i},'\Segmentation']);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GFP
    % Generate Macros ImageJ script
    fil = fopen([pDIC{1,i},'\Segmentation\',ident,'-MacroSegmentationGFP.ijm'], 'w');
    dir1 = [pDIC{1,i},'\CutFluo1'];
    dir12 = [pDIC{1,i},'\Segmentation'];
    dir1 = strrep(dir1,'\','/');
    dir12 = strrep(dir12,'\','/');

    fprintf(fil, ['dir1 = "',dir1,'/";']);
    fprintf(fil, '\n');
    fprintf(fil, ['dir2 = "',dir12,'/";']);
    fprintf(fil, '\n');
    fprintf(fil, 'list = getFileList(dir1);');
    fprintf(fil, '\n');
    fprintf(fil, 'setBatchMode(true);');
    fprintf(fil, '\n\n');
    fprintf(fil, 'for (i=0; i<list.length; i++) {');
    fprintf(fil, '\n');
    fprintf(fil, '    if(!File.exists(dir2+replace(list[i], "png", "tif"))){');
    fprintf(fil, '\n');
    fprintf(fil, ['        open("',dir1,'/"+list[i]);']);
    fprintf(fil, '\n');

    RSA = strrep(RSA,'\','/');
    fprintf(fil, ['        call(''de.unifreiburg.unet.SegmentationJob.processHyperStack'', ''modelFilename=D:/2d_cell_net_v0_model/2d_cell_net_v0_model/2d_cell_net_v0.modeldef.h5, Memory (MB):=5000,weightsFilename=',Cmod,'.caffemodel.h5,gpuId=all available,useRemoteHost=true,hostname=',IP,',port=22,username=ubuntu,RSAKeyfile=//',RSA,',processFolder=,average=none,keepOriginal=false,outputScores=false,outputSoftmaxScores=false'');']);

    fprintf(fil, '\n');

    a=cutcor{1,i}(2)-cutcor{1,i}(1)+1;
    b=cutcor{1,i}(4)-cutcor{1,i}(3)+1;

    fprintf(fil, ['        run("Size...", "width=',num2str(b),' height=',num2str(a),' depth=1 constrain average interpolation=Bilinear");']);
    fprintf(fil, '\n');

    dir2 = [pDIC{1,i},'\Segmentation'];
    dir2 = strrep(dir2,'\','/');

    fprintf(fil, ['        saveAs("Tiff", "',dir2,'/"+list[i]);']);
    fprintf(fil, '\n\n');
    fprintf(fil, '         close();');
    fprintf(fil, '\n');
    fprintf(fil, '    }');
    fprintf(fil, '\n');
    fprintf(fil, '}');
    fprintf(fil, '\n');

    fclose(fil);

    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RFP
    % Generate Macros ImageJ script
    fil = fopen([pDIC{1,i},'\Segmentation\',ident,'-MacroSegmentationRFP.ijm'], 'w');
    dir1 = [pDIC{1,i},'\CutFluo2'];
    dir12 = [pDIC{1,i},'\Segmentation'];
    dir1 = strrep(dir1,'\','/');
    dir12 = strrep(dir12,'\','/');

    fprintf(fil, ['dir1 = "',dir1,'/";']);
    fprintf(fil, '\n');
    fprintf(fil, ['dir2 = "',dir12,'/";']);
    fprintf(fil, '\n');
    fprintf(fil, 'list = getFileList(dir1);');
    fprintf(fil, '\n');
    fprintf(fil, 'setBatchMode(true);');
    fprintf(fil, '\n\n');
    fprintf(fil, 'for (i=0; i<list.length; i++) {');
    fprintf(fil, '\n');
    fprintf(fil, '    if(!File.exists(dir2+replace(list[i], "png", "tif"))){');
    fprintf(fil, '\n');
    fprintf(fil, ['        open("',dir1,'/"+list[i]);']);
    fprintf(fil, '\n');

    RSA = strrep(RSA,'\','/');
    fprintf(fil, ['        call(''de.unifreiburg.unet.SegmentationJob.processHyperStack'', ''modelFilename=D:/2d_cell_net_v0_model/2d_cell_net_v0_model/2d_cell_net_v0.modeldef.h5, Memory (MB):=5000,weightsFilename=',Cmod,'.caffemodel.h5,gpuId=all available,useRemoteHost=true,hostname=',IP,',port=22,username=ubuntu,RSAKeyfile=//',RSA,',processFolder=,average=none,keepOriginal=false,outputScores=false,outputSoftmaxScores=false'');']);

    fprintf(fil, '\n');

    a=cutcor{1,i}(2)-cutcor{1,i}(1)+1;
    b=cutcor{1,i}(4)-cutcor{1,i}(3)+1;

    fprintf(fil, ['        run("Size...", "width=',num2str(b),' height=',num2str(a),' depth=1 constrain average interpolation=Bilinear");']);
    fprintf(fil, '\n');

    dir2 = [pDIC{1,i},'\Segmentation'];
    dir2 = strrep(dir2,'\','/');

    fprintf(fil, ['        saveAs("Tiff", "',dir2,'/"+list[i]);']);
    fprintf(fil, '\n\n');
    fprintf(fil, '         close();');
    fprintf(fil, '\n');
    fprintf(fil, '    }');
    fprintf(fil, '\n');
    fprintf(fil, '}');
    fprintf(fil, '\n');

    fclose(fil);
    
    

end


end




















