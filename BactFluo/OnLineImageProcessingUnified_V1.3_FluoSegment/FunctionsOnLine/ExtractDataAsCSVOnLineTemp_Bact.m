%% Extract data as CSV

% This script exrtacts the experimental results as well as the experimental
% information (time, inputs) and generates a csv file.

% --------> direct: Directory path where the images are saved (string)
% --------> ident: identifier that will be added to the matlab structure
% containing all the cut images (string)
% --------> fic: Name of the CSV file containing the information of the
% inputs for an experiment

function [] = ExtractDataAsCSVOnLineTemp_Bact(direct, INP, CitFreq, ident, IndInf)

% Load data
load([direct,'\',ident,'_OutputFiles\TemporaryFluorescence1.mat'],'tfluo1');
load([direct,'\',ident,'_OutputFiles\TemporaryFluorescence2.mat'],'tfluo2');

%% Single-cell data

% Get time vector
time = INP(2,1):CitFreq:INP(2,end)-CitFreq;

% Generate Inducer1 vector
Ind1 = nan(1,length(time));
for i=1:length(INP(1,:))
    for j=1:length(time)
        if time(j) >= INP(2,i)
            Ind1(j) = INP(1,i);
        end
    end
end

Ind1pre = ones(1,length(time))*IndInf.ON1;

% Generate Inducer 2 vector

Ind2 = nan(1,length(time));

if ~isempty(IndInf.Inducer2)
    if strcmp(IndInf.Ind2Type,'Constant')
        for j=1:length(time)
            Ind2(j) = IndInf.Ind2Con;
        end
    elseif strcmp(IndInf.Ind2Type,'Complementary')
        ind1norm = Ind1/max(Ind1);
        ind2norm = 1-ind1norm;
        Ind2 = IndInf.Ind2Con * ind2norm;
    end
    Ind2pre = ones(1,length(time))*IndInf.ON2;
else
    Ind2pre = nan(1,length(time));
    Ind2 = zeros(1,length(time));
end


% Generate matrix with all data to be converted into CSV

finMat = zeros(length(time),9);

finMat(:,1) = Ind1pre;
finMat(:,2) = Ind2pre;
finMat(:,3) = Ind1;
finMat(:,4) = Ind2;
finMat(:,5) = time;
finMat(:,6) = tfluo1(1,:);
finMat(:,7) = tfluo1(2,:);
finMat(:,8) = tfluo2(1,:);
finMat(:,9) = tfluo2(2,:);

% Write the heathers for the CSV file
header2 = strings(1,9);
header2(1) = [IndInf.Inducer1, 'pre (', IndInf.Ind1Unit,')'];
% If not empty
header2(2) = [IndInf.Inducer2, 'pre (', IndInf.Ind2Unit,')'];
header2(3) = [IndInf.Inducer1, ' (', IndInf.Ind1Unit,')'];
header2(4) = [IndInf.Inducer2, ' (', IndInf.Ind2Unit,')'];
header2(5) = 'time(min)';
header2(6) = 'GFP_Mean';
header2(7) = 'GFP_SD';
header2(8) = 'RFP_Mean';
header2(9) = 'RFP_SD';

% Write CSV file
cHeader2 = num2cell(header2); %dummy header
for i=1:length(cHeader2)
cHeader2{i} = char(cHeader2{i});
end
textHeader = strjoin(cHeader2, ',');
%write header to file
fid = fopen([direct,'\',ident,'_OutputFiles\ExperimentalData_',ident,'.csv'],'w'); 
fprintf(fid,'%s\n',textHeader);
fclose(fid);
%write data to end of file
dlmwrite([direct,'\',ident,'_OutputFiles\ExperimentalData_',ident,'.csv'],finMat,'-append');


end





