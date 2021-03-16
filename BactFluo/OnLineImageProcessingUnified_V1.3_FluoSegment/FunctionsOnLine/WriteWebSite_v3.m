


function [] = WriteWebSite_v3(ident, webPath, CellDirs, BackDirs, Device)


fil = fopen([webPath, '\',ident,'-Web.html'], 'w');


fprintf(fil, '<!DOCTYPE html>');
fprintf(fil, '\n');
fprintf(fil, '<html>');
fprintf(fil, '\n');
fprintf(fil, '  <head>');
fprintf(fil, '\n');
fprintf(fil, '    <title>My webpage!</title>');
fprintf(fil, '\n');
fprintf(fil, '    <style>');
fprintf(fil, '\n');
fprintf(fil, '    .row {');
fprintf(fil, '\n');
fprintf(fil, '        display: flex;');
fprintf(fil, '\n');
fprintf(fil, '        flex-wrap: wrap;');
fprintf(fil, '\n');
fprintf(fil, '        padding: 0 10px;');
fprintf(fil, '\n');
fprintf(fil, '    }');
fprintf(fil, '\n');
fprintf(fil, '    .column {');
fprintf(fil, '\n');
fprintf(fil, '        flex: 50%;');
fprintf(fil, '\n');
fprintf(fil, '        padding: 0 10px;');
fprintf(fil, '\n');
fprintf(fil, '    }');
fprintf(fil, '\n');
fprintf(fil, '    .column img {');
fprintf(fil, '\n');
fprintf(fil, '        margin-top: 16px;');
fprintf(fil, '\n');
fprintf(fil, '        vertical-align: middle;');
fprintf(fil, '\n');
fprintf(fil, '    }');
fprintf(fil, '\n');
fprintf(fil, '\n');
fprintf(fil, '  </style>');
fprintf(fil, '\n');
fprintf(fil, '  </head>');
fprintf(fil, '\n');
fprintf(fil, '  <body>');
fprintf(fil, '\n');
fprintf(fil, '    <h1> <font size="+14"> Microfluidics Experiments E. Coli </font> </h1>');
fprintf(fil, '\n');
fprintf(fil, '    <div class="image-section">');
fprintf(fil, '\n');
fprintf(fil, '      <div class="section-style">');
fprintf(fil, '\n');
fprintf(fil, '        <p> <font size="+2"> <strong> Fluorescence plots </strong> </font></p>');
fprintf(fil, '\n');
dir1 = ['.\',ident,'-FluorescencePlots.png'];
dir1 = strrep(dir1,'\','/');
switch Device
    case 'Yeast'
        fprintf(fil, ['        <img src="',dir1,'" alt="" width="1000" height="600" />']);
    case 'Bacteria'
        fprintf(fil, ['        <img src="',dir1,'" alt="" width="1600" height="1200" />']);
end
fprintf(fil, '\n');
fprintf(fil, '      </div>');
fprintf(fil, '\n');
fprintf(fil, '    <div class="image-section">');
fprintf(fil, '\n');
fprintf(fil, '      <div class="section-style">');
fprintf(fil, '\n');
fprintf(fil, '        <p> <font size="+2"> <strong> Dye Fluorescence plot </strong> </font></p>');
fprintf(fil, '\n');
dir2 = ['.\',ident,'-Dye.png'];
dir2 = strrep(dir2,'\','/');
switch Device
    case 'Yeast'
        fprintf(fil, ['        <img src="',dir2,'" alt=""  width="1000" height="600" />']);
    case 'Bacteria'
        fprintf(fil, ['        <img src="',dir2,'" alt="" />']);
end

fprintf(fil, '\n');
fprintf(fil, '      </div>');
fprintf(fil, '\n');




fprintf(fil, '    <div class="image-section">');
fprintf(fil, '\n');
fprintf(fil, '      <div class="section-style">');
fprintf(fil, '\n');
fprintf(fil, '        <p> <font size="+2"> <strong> Last time-point Cells </strong> </font> </p>');
fprintf(fil, '\n');
fprintf(fil, '      </div>');
fprintf(fil, '\n');
fprintf(fil, '      </div>');



fprintf(fil, '    <div class="image-section">');
fprintf(fil, '\n');
fprintf(fil, '      <div class="column">');
fprintf(fil, '\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch Device
    case 'Yeast'
        out=regexp(CellDirs{1,1},'\','split');
        pos = out{end};


        fprintf(fil, '\n');
        fprintf(fil, '\n');
        fprintf(fil, ['        <p> <strong> ',pos,' </strong> </p>']);
        fprintf(fil, '\n');
        fprintf(fil, '      <div class="row">');
        fprintf(fil, '\n');


        fprintf(fil, '    <figure>');
        fprintf(fil, '    <p>  DIC:  </p>');
        dir3 = ['.\',ident,'-LastDIC_Cells','.png'];
        dir3 = strrep(dir3,'\','/');
        fprintf(fil, ['    <img src="',dir3,'" alt="" />']);
        fprintf(fil, '\n');
        fprintf(fil, '      </figure>');
        fprintf(fil, '\n');

        fprintf(fil, '    <figure>');
        fprintf(fil, '    <p>  Mask:  </p>');
        dir3 = ['.\',ident,'-LastMask_Cells','.png'];
        dir3 = strrep(dir3,'\','/');
        fprintf(fil, ['    <img src="',dir3,'" alt="" />']);
        fprintf(fil, '\n');
        fprintf(fil, '      </figure>');
        fprintf(fil, '\n');

        fprintf(fil, '    <figure>');
        fprintf(fil, '    <p>  Citrine:  </p>');
        dir3 = ['.\',ident,'-LastFluo_Cells','.png'];
        dir3 = strrep(dir3,'\','/');
        fprintf(fil, ['    <img src="',dir3,'" alt="" />']);
        fprintf(fil, '\n');
        fprintf(fil, '      </figure>');
        fprintf(fil, '\n');


        fprintf(fil, '    <figure>');
        fprintf(fil, '    <p>  Dye:  </p>');
        dir3 = ['.\',ident,'-LastDye_Cells','.png'];
        dir3 = strrep(dir3,'\','/');
        fprintf(fil, ['    <img src="',dir3,'" alt="" />']);
        fprintf(fil, '\n');
        fprintf(fil, '      </figure>');
        fprintf(fil, '\n');
        fprintf(fil, '</div>');
        fprintf(fil, '\n');
        fprintf(fil, '\n');

    case 'Bacteria'

        for di=1:length(CellDirs)

            out=regexp(CellDirs{di},'\','split');
            pos = out{end};


            fprintf(fil, '\n');
            fprintf(fil, '\n');
            fprintf(fil, ['        <p> <strong> ',pos,' </strong> </p>']);
            fprintf(fil, '\n');
            fprintf(fil, '      <div class="row">');
            fprintf(fil, '\n');


            fprintf(fil, '    <figure>');
            fprintf(fil, '    <p>  DIC:  </p>');
            dir3 = ['.\',ident,'-LastDIC_Cells_Pos',num2str(di),'.png'];
            dir3 = strrep(dir3,'\','/');
            fprintf(fil, ['    <img src="',dir3,'" alt="" />']);
            fprintf(fil, '\n');
            fprintf(fil, '      </figure>');
            fprintf(fil, '\n');

            fprintf(fil, '    <figure>');
            fprintf(fil, '    <p>  Mask:  </p>');
            dir3 = ['.\',ident,'-LastMask_Cells_Pos',num2str(di),'.png'];
            dir3 = strrep(dir3,'\','/');
            fprintf(fil, ['    <img src="',dir3,'" alt="" />']);
            fprintf(fil, '\n');
            fprintf(fil, '      </figure>');
            fprintf(fil, '\n');

            fprintf(fil, '    <figure>');
            fprintf(fil, '    <p>  GFP:  </p>');
            dir3 = ['.\',ident,'-LastFluo1_Cells_Pos',num2str(di),'.png'];
            dir3 = strrep(dir3,'\','/');
            fprintf(fil, ['    <img src="',dir3,'" alt="" />']);
            fprintf(fil, '\n');
            fprintf(fil, '      </figure>');
            fprintf(fil, '\n');

            fprintf(fil, '    <figure>');
            fprintf(fil, '    <p>  RFP:  </p>');
            dir3 = ['.\',ident,'-LastFluo2_Cells_Pos',num2str(di),'.png'];
            dir3 = strrep(dir3,'\','/');
            fprintf(fil, ['    <img src="',dir3,'" alt="" />']);
            fprintf(fil, '\n');
            fprintf(fil, '      </figure>');
            fprintf(fil, '\n');

            fprintf(fil, '    <figure>');
            fprintf(fil, '    <p>  Dye:  </p>');
            dir3 = ['.\',ident,'-LastDye_Cells_Pos',num2str(di),'.png'];
            dir3 = strrep(dir3,'\','/');
            fprintf(fil, ['    <img src="',dir3,'" alt="" />']);
            fprintf(fil, '\n');
            fprintf(fil, '      </figure>');
            fprintf(fil, '\n');
            fprintf(fil, '</div>');
            fprintf(fil, '\n');
            fprintf(fil, '\n');


        end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf(fil, '\n');
fprintf(fil, '</div');
fprintf(fil, '\n');
fprintf(fil, '</div>');
fprintf(fil, '\n');





fprintf(fil, '    <div class="image-section">');
fprintf(fil, '\n');
fprintf(fil, '      <div class="section-style">');
fprintf(fil, '\n');
fprintf(fil, '        <p> <font size="+2"> <strong> Last time-point Background </strong> </font> </p>');
fprintf(fil, '\n');


fprintf(fil, '    <div class="image-section">');
fprintf(fil, '\n');
fprintf(fil, '      <div class="column">');
fprintf(fil, '\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch Device
    case 'Yeast'
        out=regexp(BackDirs{1,1},'\','split');
        pos = out{end};
        
        for j=1:2
        
            fprintf(fil, '\n');
            fprintf(fil, '\n');
            fprintf(fil, ['        <p> <strong> ',pos, ' Cut', num2str(j),' </strong> </p>']);
            fprintf(fil, '\n');
            fprintf(fil, '      <div class="row">');
            fprintf(fil, '\n');


            fprintf(fil, '    <figure>');
            fprintf(fil, '    <p>  DIC:  </p>');
            dir3 = ['.\',ident,'-LastDIC_Back',num2str(j),'.png'];
            dir3 = strrep(dir3,'\','/');
            fprintf(fil, ['    <img src="',dir3,'" alt="" />']);
            fprintf(fil, '\n');
            fprintf(fil, '      </figure>');
            fprintf(fil, '\n');

            fprintf(fil, '    <figure>');
            fprintf(fil, '    <p>  Mask:  </p>');
            dir3 = ['.\',ident,'-LastMask_Back',num2str(j),'.png'];
            dir3 = strrep(dir3,'\','/');
            fprintf(fil, ['    <img src="',dir3,'" alt="" />']);
            fprintf(fil, '\n');
            fprintf(fil, '      </figure>');
            fprintf(fil, '\n');

            fprintf(fil, '    <figure>');
            fprintf(fil, '    <p>  Citrine:  </p>');
            dir3 = ['.\',ident,'-LastFluo_Back',num2str(j),'.png'];
            dir3 = strrep(dir3,'\','/');
            fprintf(fil, ['    <img src="',dir3,'" alt="" />']);
            fprintf(fil, '\n');
            fprintf(fil, '      </figure>');
            fprintf(fil, '\n');


            fprintf(fil, '    <figure>');
            fprintf(fil, '    <p>  Dye:  </p>');
            dir3 = ['.\',ident,'-LastDye_Back',num2str(j),'.png'];
            dir3 = strrep(dir3,'\','/');
            fprintf(fil, ['    <img src="',dir3,'" alt="" />']);
            fprintf(fil, '\n');
            fprintf(fil, '      </figure>');
            fprintf(fil, '\n');
            fprintf(fil, '</div>');
            fprintf(fil, '\n');
            fprintf(fil, '\n');
        end
        
    case 'Bacteria'
        for di=1:length(BackDirs)

            out=regexp(BackDirs{di},'\','split');
            pos = out{end};


            fprintf(fil, '\n');
            fprintf(fil, '\n');
            fprintf(fil, ['        <p> <strong> ',pos,' </strong> </p>']);
            fprintf(fil, '\n');
            fprintf(fil, '      <div class="row">');
            fprintf(fil, '\n');


            fprintf(fil, '    <figure>');
            fprintf(fil, '    <p>  DIC:  </p>');
            dir3 = ['.\',ident,'-LastDIC_Back_Pos',num2str(di),'.png'];
            dir3 = strrep(dir3,'\','/');
            fprintf(fil, ['    <img src="',dir3,'" alt="" />']);
            fprintf(fil, '\n');
            fprintf(fil, '      </figure>');
            fprintf(fil, '\n');

            fprintf(fil, '    <figure>');
            fprintf(fil, '    <p>  Mask:  </p>');
            dir3 = ['.\',ident,'-LastMask_Back_Pos',num2str(di),'.png'];
            dir3 = strrep(dir3,'\','/');
            fprintf(fil, ['    <img src="',dir3,'" alt="" />']);
            fprintf(fil, '\n');
            fprintf(fil, '      </figure>');
            fprintf(fil, '\n');

            fprintf(fil, '    <figure>');
            fprintf(fil, '    <p>  GFP:  </p>');
            dir3 = ['.\',ident,'-LastFluo1_Back_Pos',num2str(di),'.png'];
            dir3 = strrep(dir3,'\','/');
            fprintf(fil, ['    <img src="',dir3,'" alt="" />']);
            fprintf(fil, '\n');
            fprintf(fil, '      </figure>');
            fprintf(fil, '\n');

            fprintf(fil, '    <figure>');
            fprintf(fil, '    <p>  RFP:  </p>');
            dir3 = ['.\',ident,'-LastFluo2_Back_Pos',num2str(di),'.png'];
            dir3 = strrep(dir3,'\','/');
            fprintf(fil, ['    <img src="',dir3,'" alt="" />']);
            fprintf(fil, '\n');
            fprintf(fil, '      </figure>');
            fprintf(fil, '\n');

            fprintf(fil, '    <figure>');
            fprintf(fil, '    <p>  Dye:  </p>');
            dir3 = ['.\',ident,'-LastDye_Back_Pos',num2str(di),'.png'];
            dir3 = strrep(dir3,'\','/');
            fprintf(fil, ['    <img src="',dir3,'" alt="" />']);
            fprintf(fil, '\n');
            fprintf(fil, '      </figure>');
            fprintf(fil, '\n');
            fprintf(fil, '</div>');
            fprintf(fil, '\n');
            fprintf(fil, '\n');


        end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf(fil, '\n');
fprintf(fil, '</div');
fprintf(fil, '\n');
fprintf(fil, '</div>');
fprintf(fil, '\n');




fprintf(fil, '\n');
fprintf(fil, '      </div>');
fprintf(fil, '\n');
fprintf(fil, '      </div>');





fprintf(fil, '\n');
fprintf(fil, '    <h4 id=''date''></h4>');
fprintf(fil, '\n');
fprintf(fil, '  </body>');
fprintf(fil, '\n');
fprintf(fil, '</html>');
fprintf(fil, '\n');
fprintf(fil, '\n');
fprintf(fil, '\n');

fclose(fil);


end













