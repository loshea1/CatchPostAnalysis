%Pseudo-Machine Learning Data Code
close all
clear
clc

%Load Matlab file
filename = uigetfile('*MAT');

% filename ={...
%     'MITSS01_1FN.MAT' 'MITSS01_1FP.MAT' 'MITSS01_1SN.MAT' 'MITSS01_1SP.MAT'...
%     'MITSS01_2FN.MAT' 'MITSS01_2FP.MAT' 'MITSS01_2SN.MAT' 'MITSS01_2SP.MAT'...
%     'MITSS01_3FN.MAT' 'MITSS01_3FP.MAT' 'MITSS01_3SN.MAT' 'MITSS01_3SP.MAT'...
%     'MITSS02_1FN.MAT' 'MITSS02_1FP.MAT' 'MITSS02_1SN.MAT' 'MITSS02_1SP.MAT'...
%     'MITSS02_2FN.MAT' 'MITSS02_2FP.MAT' 'MITSS02_2SN.MAT' 'MITSS02_2SP.MAT'...
%     'MITSS02_3FN.MAT' 'MITSS02_3FP.MAT' 'MITSS02_3SN.MAT' 'MITSS02_3SP.MAT'...
%     'MITSS03_1FN.MAT' 'MITSS03_1FP.MAT' 'MITSS03_1SN.MAT' 'MITSS03_1SP.MAT'...
%     'MITSS03_2FN.MAT' 'MITSS03_2FP.MAT' 'MITSS03_2SN.MAT' 'MITSS03_2SP.MAT'...
%     'MITSS03_3FN.MAT' 'MITSS03_3FP.MAT' 'MITSS03_3SN.MAT' 'MITSS03_3SP.MAT'...
%     'MITSS04_1FN.MAT' 'MITSS04_1FP.MAT' 'MITSS04_1SN.MAT' 'MITSS04_1SP.MAT'...
%     'MITSS04_2FN.MAT' 'MITSS04_2FP.MAT' 'MITSS04_2SN.MAT' 'MITSS04_2SP.MAT'...
%     'MITSS04_3FN.MAT' 'MITSS04_3FP.MAT' 'MITSS04_3SN.MAT' ...
%     'MITSS05_1FN.MAT' 'MITSS05_1FP.MAT' 'MITSS05_1SN.MAT' 'MITSS05_1SP.MAT'...
%     'MITSS05_2FN.MAT' 'MITSS05_2FP.MAT' 'MITSS05_2SN.MAT' 'MITSS05_2SP.MAT'...
%     'MITSS05_3FN.MAT' 'MITSS05_3FP.MAT' 'MITSS05_3SN.MAT' 'MITSS05_3SP.MAT'...
%     'MITSS06_1FN.MAT' 'MITSS06_1FP.MAT' 'MITSS06_1SN.MAT' 'MITSS06_1SP.MAT'...
%     'MITSS06_2FN.MAT' 'MITSS06_2FP.MAT' 'MITSS06_2SN.MAT' 'MITSS06_2SP.MAT'...
%     'MITSS08_1FP.MAT' 'MITSS08_1SP.MAT' 'MITSS08_2FP.MAT' 'MITSS08_2SP.MAT'...
%     'MITSS08_3FP.MAT' 'MITSS08_3SP.MAT'...
%     'MITSS09_1FP.MAT' 'MITSS09_1SN.MAT' 'MITSS09_1SP.MAT'};

%for w = 1:length(filename)
clc
clearvars -except w filename

load(filename);
%load(filename{w});

%Looks to see if the first cell array of the structure is empty or not 
%becasue V1 will not have anything in that cell
%1 = true  (V1)
%0 = false (V2)
textID = isempty(Raw(1).raw);

if textID == 1
    %For V1 data collection
    time = table2array(Filt(1).data);
    y_pos = table2array(Filt(5).data);
    x_accel = table2array(Filt(7).data); %U
    y_accel = table2array(Filt(8).data); %V
    z_accel = table2array(Filt(9).data); %W
    net_accel = ((x_accel.^2)+(y_accel.^2)+(z_accel.^2)).^(1/2);
else
    %For V2 data collection
    for i = 1:length(Raw(1).data)
        if (Raw(1).data(i,1) == 0)
            Raw(1).data(i,1) = (Raw(1).data(i-1,1)-Raw(1).data(i-2,1))+...
                Raw(1).data(i-1,1);
        end
    end
    
    time = (Raw(1).data - Raw(1).data(1,1))/1000000; %zero the time data
    y_pos = Raw(5).data;
    net_accel =((Raw(7).data.^2)+(Raw(8).data.^2)+(Raw(9).data.^2)).^(1/2);   
end

if y_pos(1,1) > 0
    y_pos = y_pos * -1;
end
y_pos = y_pos + 90;

y_pos_neg = y_pos * -1;

if length(time) > length(y_pos)
 time(end, :) = [];   
end

%find positive peaks (blue)
[pks,locs]= findpeaks(y_pos,time,'MinPeakProminence',5,'MinPeakDistance',0.85);
findpeaks(y_pos,time,'MinPeakProminence',5,'MinPeakDistance',0.85);

indices = zeros(1,1);

%Peaks from User input
title('Pick correct peaks: To peak each peak, hold SHIFT and click desired datatip. When finished hit ENTER');
set(gcf, 'CurrentCharacter', char(1));
d = datacursormode;
waitfor(gcf, 'CurrentCharacter', char(32));
vals = getCursorInfo(d);

%sort the structure
T = struct2table(vals); %convert to a table
sortedT = sortrows(T, 'DataIndex');
vals = table2struct(sortedT);

for k = 1:length(time)
    if time(k,1) == vals(1).Position(1,1)
        indices(1,1) = k;
    end
    if time(k,1) == vals(2).Position(1,1)
        indices(end+1) = k;
    end
    if length(vals) > 2
        if time(k,1) == vals(3).Position(1,1)
            indices(end+1) = k;
        end
    end
    if length(vals) > 3
        if time(k,1) == vals(4).Position(1,1)
            indices(end+1) = k;
        end
    end
end

sort(indices);

close all
%find negative peaks (orange)
[pks2,locs2]= findpeaks(y_pos_neg,time,'MinPeakProminence',5,'MinPeakDistance',0.85);
hold on
findpeaks(y_pos_neg,time,'MinPeakProminence',5,'MinPeakDistance',0.85);

%Peaks from User input
title('Pick correct peaks from left to right. Hold SHIFT and click desired datatip. When finished hit SPACE BAR');
set(gcf, 'CurrentCharacter', char(1));
d = datacursormode;
waitfor(gcf, 'CurrentCharacter', char(32));
vals2 = getCursorInfo(d);


%sort the structure
T = struct2table(vals2); %convert to a table
sortedT = sortrows(T, 'DataIndex');
vals2 = table2struct(sortedT);

%if vals2(1).Position(1,1) > vals(1).Position(1,1)
    for i = length(vals):-1:1
        vals2(i+1).Position(1,1) = vals2(i).Position(1,1);
        
        %locs2(i+1,1) = locs2(i);
    end
    dy = gradient(y_pos(:))./gradient(time(:));
    hold on 
    for i = 1:length(dy)
        if (dy(i) > 23) || (dy(i)<-4)
            vals2(1).Position(1,1) = time(i);
            break;
        end
    end
 %  hold on
 %  plot(vals2(1).Position(1,1),0,'^'); 
    
%end

indices2 = zeros(1,1);
for j = 1:length(time)
    if time(j,1) == vals2(1).Position(1,1)
        indices2(1,1) = j;
    end
    if time(j,1) == vals2(2).Position(1,1)
        indices2(end+1) = j;
    end
    if length(vals2) > 2
        if time(j,1) == vals2(3).Position(1,1)
            indices2(end+1) = j;
        end
    end
    if length(vals2) > 3
        if time(j,1) == vals2(4).Position(1,1)
            indices2(end+1)= j;
        end
    end
end


%FLEXORS
%extension 1
ext1(:,1) = time(indices2(1,1):indices(1,1));
ext1(:,2) = y_pos(indices2(1,1):indices(1,1));
ext1(:,3) = net_accel(indices2(1,1):indices(1,1));

%extension 2
ext2(:,1) = time(indices2(1,2):indices(1,2));
ext2(:,2) = y_pos(indices2(1,2):indices(1,2));
ext2(:,3) = net_accel(indices2(1,2):indices(1,2));

disp(filename);
%disp(filename{w});
fprintf("\n")
disp("FLEXORS: ")
[ECatch1,Eprominence1,Ewidth1,Epeak_accel1,EminROM1,EmaxROM1] = findCatch(ext1,1);
E(1,1) = ECatch1;
E(1,2) = Eprominence1;
E(1,3) = Ewidth1;
E(1,4) = Epeak_accel1;
E(1,5) = EminROM1;
E(1,6) = EmaxROM1;
prompt = "Catch or NO?(C or N):";
answer = input(prompt,"s");
if answer == 'C' || answer == 'c'
    E(1,7) = 1;
else
    E(1,7) = 0;
end
[ECatch2,Eprominence2,Ewidth2,Epeak_accel2,EminROM2,EmaxROM2] = findCatch(ext2,2);
E(2,1) = ECatch2;
E(2,2) = Eprominence2;
E(2,3) = Ewidth2;
E(2,4) = Epeak_accel2;
E(2,5) = EminROM2;
E(2,6) = EmaxROM2;
prompt = "Catch or NO?(C or N): ";
answer = input(prompt,"s");
if answer == 'C' || answer == 'c'
    E(2,7) = 1;
else
    E(2,7) = 0;
end

EtotalCatches = [ECatch1,ECatch2];
EAvgCatch = mean(EtotalCatches);

if length(vals)> 2
%extension 3
ext3(:,1) = time(indices2(1,3):indices(1,3));
ext3(:,2) = y_pos(indices2(1,3):indices(1,3));
ext3(:,3) = net_accel(indices2(1,3):indices(1,3));
    
[ECatch3,Eprominence3,Ewidth3,Epeak_accel3,EminROM3,EmaxROM3] = findCatch(ext3,3);
E(3,1) = ECatch3;
E(3,2) = Eprominence3;
E(3,3) = Ewidth3;
E(3,4) = Epeak_accel3;
E(3,5) = EminROM3;
E(3,6) = EmaxROM3;
prompt = "Catch or NO?(C or N): ";
answer = input(prompt,"s");
if answer == 'C' || answer == 'c'
    E(3,7) = 1;
else
    E(3,7) = 0;
end

EtotalCatches = [ECatch1,ECatch2,ECatch3];
EAvgCatch = mean(EtotalCatches);
end

%EXTENSORS
if vals2(2).Position(1,1) > vals(1).Position(1,1)
    Q = 1;
    P = 2;
    a = indices(1,Q);
    b = indices2(1,P);
else 
    Q = 2;
    P = 1;
    a = indices2(1,Q);
    b = indices(1,P);
end

%flexion 1
flex1(:,1) = time(a:b);
flex1(:,2) = y_pos(a:b);
flex1(:,3) = net_accel(a:b);

Q = Q+1;
P = P+1;
%flexion 2
flex2(:,1) = time(a:b);
flex2(:,2) = y_pos(a:b);
flex2(:,3) = net_accel(a:b);

fprintf("\n")
disp("EXTENSORS: ")
[FCatch1,Fprominence1,Fwidth1,Fpeak_accel1,FminROM1,FmaxROM1] = findCatch(flex1,1);
F(1,1) = FCatch1;
F(1,2) = Fprominence1;
F(1,3) = Fwidth1;
F(1,4) = Fpeak_accel1;
F(1,5) = FminROM1;
F(1,6) = FmaxROM1;
prompt = "Catch or NO?(C or N): ";
answer = input(prompt,"s");
if answer == 'C' || answer == 'c'
    F(1,7) = 1;
else
    F(1,7) = 0;
end
[FCatch2,Fprominence2,Fwidth2,Fpeak_accel2,FminROM2,FmaxROM2] = findCatch(flex2,2);
F(2,1) = FCatch2;
F(2,2) = Fprominence2;
F(2,3) = Fwidth2;
F(2,4) = Fpeak_accel2;
F(2,5) = FminROM2;
F(2,6) = FmaxROM2;
prompt = "Catch or NO?(C or N): ";
answer = input(prompt,"s");
if answer == 'C' || answer == 'c'
    F(2,7) = 1;
else
    F(2,7) = 0;
end

FtotalCatches = [FCatch1,FCatch2];
FAvgCatch = mean(FtotalCatches);

if length(vals)> 2
%flexion 3
Q = Q+1;
P = P+1;
flex3(:,1) = time(a:b);
flex3(:,2) = y_pos(a:b);
flex3(:,3) = net_accel(a:b);

[FCatch3,Fprominence3,Fwidth3,Fpeak_accel3,FminROM3,FmaxROM3] = findCatch(flex3,3);
F(3,1) = FCatch3;
F(3,2) = Fprominence3;
F(3,3) = Fwidth3;
F(3,4) = Fpeak_accel3;
F(3,5) = FminROM3;
F(3,6) = FmaxROM3;
prompt = "Catch or NO?(C or N): ";
answer = input(prompt,"s");
if answer == 'C' || answer == 'c'
    F(3,7) = 1;
else
    F(3,7) = 0;
end

FtotalCatches = [FCatch1,FCatch2,FCatch3];
FAvgCatch = mean(FtotalCatches);
end


E = array2table(E);
F = array2table(F);

file = split(convertCharsToStrings(filename), '_');
%file = split(convertCharsToStrings(filename{w}), '_');
trial = split(file(2,1), '.');
trial = trial(1,1);

eTable = cell2table(cell(height(E), 1));
fTable = cell2table(cell(height(F), 1));

eTable(:,1) = array2table(cellstr(trial));
fTable(:, 1) = array2table(cellstr(trial));

E = [E eTable];
F = [F fTable];

E.Properties.VariableNames(1:8) = {'Catch', 'Prominence', 'Width', 'Peak Acc', 'Min ROM', 'Max ROM', 'Catch = 1', 'Trial'};
F.Properties.VariableNames(1:8) = {'Catch', 'Prominence', 'Width', 'Peak Acc', 'Min ROM', 'Max ROM', 'Catch = 1', 'Trial'};

an = filename;
%an = filename{w};
excelFile = 'PseudoMachineLearningTest.xlsx';
prompt = "Save? (Y/N): ";
answer = input(prompt,"s");
if answer == 'Y' || answer == 'y'
    writetable(E,excelFile, 'WriteMode','append', 'Sheet', 'Ext');
    writetable(F,excelFile, 'WriteMode','append','Sheet', 'Flex');
end


if EAvgCatch > 95
    disp("Conclusion: No Catch Detected for flexors");
else
    disp("Conclusion: The average catch percentage for flexors is " + EAvgCatch + "%");
end

if FAvgCatch > 95
    disp("Conclusion: No Catch Detected for extensors");
else
    disp("Conclusion: The average catch percentage for extensors is " + FAvgCatch + "%");
end

close all
pause(5.0);
%end
function [Catch,prom_max,widthmax,peak, minROM, maxROM1]= findCatch(ext,trialnum)
[peak_accel, times,width,prominence] = findpeaks(ext(:,3),ext(:,1));
prom_max = max(prominence);
for i =1:length(prominence)
    if prominence(i) == prom_max
        promind = i;
    end
end
widthmax = width(promind);
% for i=1:length(prominence)
%     if prom_max == prominence(i,1)
%         width_loc = i;
%     end
% end  
% width_peak = width(width_loc,1);
minROM = ext(1,2);
maxROM1 = ext(length(ext),2);
peak = max(peak_accel);
if prom_max > 12.3 %&& width_peak < 0.09
    accel_max = max(peak_accel);
    accel_ind = find(ext(:,3)==accel_max);
    minROM = ext(1,2);
    maxROM = ext(length(ext),2);
    maxROM = maxROM - minROM;
    Catch = ext(accel_ind,2);
    Catch = Catch - minROM;
    Catch = (Catch/maxROM)*100;
    
    if Catch < 0
        Catch = 0;
    end
    
    disp("The catch percentage of trial " + trialnum + " is: " + Catch + "%")
else 
    disp("No catch detected for trial " +trialnum);
    Catch = 100;
end
end


