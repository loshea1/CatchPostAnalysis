%%
%NOTES.....................................................................

%This code determines when the linear acceleration peaks in a given
%%flexion or extension relative to that motion's ROM and returns that value
%%in %ROM

%S01, S02, S06 open as text files; all other newer subjects open as MATLAB file 

%You will be prompted to open data; this can be any trial slow or fast, NP
%or P

%FUNCTION DEFINTIONS.......................................................

%loadData: used to load older data files from S01 and S02, loads as an
%array of all variables in this order: time, x,y,z position, x,y,z
%acceleration, sen1, sen2, x,y,z gyro, total torque, net linear
%acceleration

%loadRawData: used to load newer data files, loads data into array as
%described above

%separate: used to separate the trial into separate flexions and
%extensions; sometimes this is not fully automated and the user will be
%prompted to select 4 mins and/or 3 maxes. When this happens the user
%should select the 4 lowest points in between the 3 peaks on the y-pos data
%plot that appears as well as the 3 highest points. This function remains
%to be further automated but works well for testing purposes. Sometimes the
%data presents to be "upside down" for unknown reasons. When prompted the
%user should select YES (Y) in command wind. and the data will flip right
%side up.  Function returns separate flexions and extensions

%findCatch: converts ROM of given extension or flexion into a %ROM and then
%finds the instance when most prominent net acceleration peaks compared.
%Returns catch % when called

%VARIABLES.................................................................
%E1-E3 and F1-F3: Flexions and extensions with time, y_pos, net linear
%acceleration, and total torque of data1

%eCatch1-3: Percentage ROM where net acceleration peaks for extensions

%fCatch1-3: Percentage ROM where net accelerations peaks for flexions

%%
clc
clear
close all

%Data 1
disp("Please load in data: ");
prompt = "TXT (T), Excel (X), or MATLAB (M)?: ";
type = input(prompt,"s");
if type == 'M' || type == 'm'
    filename1 = uigetfile('*.mat');
    [data] = loadRawData(filename1);
    disp("Thank you :) ")
elseif type == 'T' || type == 't'
    filename1 = uigetfile('*.txt');
    [data] = loadData(type,filename1);
    disp("Thank you :) ")
elseif type == 'X' || type == 'x'
    filename1 = uigetfile('*.xlsx');
    [data] = loadData(filename1);
    disp("Thank you :) ")
else
    disp("ERROR: Please run again (T, X, or M) >:( ")
end

time = data(:,1);
x_pos = data(:,2);
y_pos = data(:,3);
z_pos = data(:,4);
x_accel = data(:,5);
y_accel = data(:,6);
z_accel = data(:,7);
sen_val = data(:,8);
h_val = data(:,9);
gyro_x = data(:,10);
gyro_y = data(:,11);
gyro_z = data(:,12);
torque = data(:,13);
net_accel = ((x_accel.^2)+(y_accel.^2)+(z_accel.^2)).^(1/2);

%%
%separate flexion and extensions
[E1, E2, E3, F1, F2, F3]=separate(data);
fprintf("\n")
disp("FLEXORS: ")
eCatch1 = findCatch(E1,1);
eCatch2 = findCatch(E2,2);
eCatch3 = findCatch(E3,3);
etotalCatches = [eCatch1,eCatch2,eCatch3];
eAvgCatch = mean(etotalCatches);

if eAvgCatch > 95
    disp("Conclusion: No Catch Detected for flexors");
else
    disp("Conclusion: The average catch percentage for flexors is " + eAvgCatch + "%");
end

fprintf("\n")
disp("EXTENSORS: ")
fCatch1 = findCatch(F1,1);
fCatch2 = findCatch(F2,2);
fCatch3 = findCatch(F3,3);
ftotalCatches = [fCatch1,fCatch2,fCatch3];
fAvgCatch = mean(ftotalCatches);

if fAvgCatch > 95
    disp("Conclusion: No catch detected for extensors");
else
    disp("Conclusion: The average catch percentage for extensors is " + fAvgCatch + "%");
end

%%
%Uncomment this if you want to compare two datasets in one run

% %Data 2
% disp("Please load in data: ");
% prompt = "TXT (T), Excel (X), or MATLAB (M)?: ";
% type = input(prompt,"s");
% if type == 'M' || type == 'm'
%     filename1 = uigetfile('*.mat');
%     [data2] = loadRawData(filename1);
%     disp("Thank you :) ")
% elseif type == 'T' || type == 't'
%     filename1 = uigetfile('*.txt');
%     [data2] = loadData(type,filename1);
%     disp("Thank you :) ")
% elseif type == 'X' || type == 'x'
%     filename1 = uigetfile('*.xlsx');
%     [data2] = loadData(filename1);
%     disp("Thank you :) ")
% else
%     disp("ERROR: Please run again (T, X, or M) >:( ")
% end
% 
% [E1_2, E2_2, E3_2, F1_2, F2_2, F3_2]=separate(data2);
% eCatch1_2 = findCatch(E1_2,1);
% eCatch2_2 = findCatch(E2_2,2);
% eCatch3_2 = findCatch(E3_2,3);

%%
%test: shows how flexions(in blue) and extensions (in red) are separated
%for visual inspection
plot(time,y_pos)
hold on
plot(E1(:,1),E1(:,2),'LineWidth', 2, 'Color','r')
plot(E2(:,1),E2(:,2),'LineWidth', 2, 'Color','r')
plot(E3(:,1),E3(:,2),'LineWidth', 2, 'Color','r')

plot(F1(:,1),F1(:,2),'LineWidth', 2, 'Color','b')
plot(F2(:,1),F2(:,2),'LineWidth', 2, 'Color','b')
plot(F3(:,1),F3(:,2),'LineWidth', 2, 'Color','b')

%%
% %for BMES abstract
% figure;plot(E1(:,1),E1(:,3),'LineWidth',2);hold on; plot(E1_2(:,1),E1_2(:,3),'LineWidth',2);ylabel("Acceleration (m/s^2)");yyaxis right;
% plot(E1(:,1),E1(:,2),'LineWidth',2);hold on; plot(E1_2(:,1),E1_2(:,2),'LineWidth',2);
% xlabel("Time (s)");ylabel("Joint Angle (degrees)")
% 
% %for stakeholders
% %S01: (TS=2), 0SR and 0FR, E1; 2SL,2FL, E3
% %S02: (TS=1), e3 and e1, forgot which ones I used...
% figure;plot(E3(:,1),E3(:,2));ylabel("Joint Angle (degrees)"); hold on;yyaxis right; plot(E3(:,1), E3(:,3));ylabel("Acceleration (m/s^2)");
% title("Paretic Fast Extension: TS = 2 ");xlabel("Time (s)");
% grid on;
% 
% figure;plot(E1_2(:,1),E1_2(:,2));ylabel("Joint Angle (degrees)"); hold on;yyaxis right; plot(E1_2(:,1), E1_2(:,3));ylabel("Acceleration (m/s^2)");
% title("Paretic Slow Extension: TS = 2 ");xlabel("Time (s)");
% grid on;
% 
% %for poster
% figure('Color',[1 0.47 0.2]); set(gca, 'color', [1 1 1])
% colororder({'r'})
% plot(E3(:,1),E3(:,2),'LineWidth', 2,'Color', [0.5 0.5 1]);
% hold on
% plot(E3_2(:,1),E3_2(:,2),'LineWidth', 2, 'Color', [1 0.5 0]);
% xlabel("Time (s)");
% ylabel("Y-position (degrees)");
% title("Acceleration Peak in %ROM: TS=1") 
% yyaxis right
% plot(E3(:,1),E3(:,3),'Color', [0.5 0.5 1], 'LineWidth', 2, 'LineStyle', '--');
% ylabel("Net Acceleration (m/s^2)");
% grid on
% hold on
% plot(E3_2(:,1),E3_2(:,3),'Color', [1 0.5 0], 'LineWidth', 2, 'LineStyle', '--');
% legend("Non-paretic extension", "Paretic Extension", "Non-paretic net acceleration", "Paretic net acceleration");

%%
function [Catch]= findCatch(ext,trialnum)
[peak_accel, times,width,prominence] = findpeaks(ext(:,3),ext(:,1));
prom_max = max(prominence);                     %Net accel,  Time (x)
if prom_max > 12.3 
    accel_max = max(peak_accel);
    accel_ind = find(ext(:,3)==accel_max);
    minROM = ext(1,2);
    maxROM = ext(length(ext),2);
    maxROM = maxROM - minROM;
    Catch = ext(accel_ind,2);
    Catch = Catch - minROM;
    Catch = (Catch/maxROM)*100;
    disp("The catch percentage of trial " + trialnum + " is: " + Catch + "%")
%     disp("The AoC is: " + abs(ext(accel_ind,2)) + " degrees");
else 
    disp("No catch detected for trial " +trialnum);
    Catch = 100;
end
end

%%
function [ext1, ext2, ext3, flex1, flex2, flex3] = separate(newArray)
time = newArray(:,1);
y_pos = newArray(:,3);
torque = newArray(:,13);
net_accel = newArray(:,14);
plot(time,y_pos)
prompt = "Is the data upside down (Y) or (N)??: ";
upsideDown = input(prompt,"s");

if upsideDown == 'Y' || upsideDown == 'y'
    close all
    y_pos= (y_pos.*-1)+180;
    newArray(:,3) = y_pos;
    plot(time, y_pos)
    %manually select mins and maxes.
     fprintf("\n")
     disp("Please select 4 mins")
     temp1 = ginput(1);
     temp2 = ginput(1);
     temp3 = ginput(1);
     temp4 = ginput(1);
     temp = [temp1(1);temp2(1);temp3(1);temp4(1)];
     
     for i = 1:4
         indices2(i) = max(find(time<temp(i)));
     end
     hold on
     plot(time(indices2),y_pos(indices2),'ro')
     fprintf("\n")
     disp("Please select 3 maxes")
     temp1 = ginput(1);
     temp2 = ginput(1);
     temp3 = ginput(1);
     temp = [temp1(1);temp2(1);temp3(1)];
     
     for i = 1:3
         indices(i) = max(find(time<temp(i)));
     end
     plot(time(indices),y_pos(indices),'go')

elseif upsideDown == 'N' || upsideDown == 'n'
    %separate flexion and extensions and number them
    [pks,locs]= findpeaks(y_pos,time,'MinPeakProminence',5,'MinPeakDistance',1.2, 'MinPeakHeight', 100, 'NPeaks', 3);
    findpeaks(y_pos,time,'MinPeakProminence',5,'MinPeakDistance',1.2, 'MinPeakHeight', 100, 'NPeaks', 3);
    
    for k = 1:length(newArray)
        if newArray(k,1) == locs(1,1)
            indices(1,1) = k;
        end
        if newArray(k,1) == locs(2,1)
            indices(end+1) = k;
        end
        if length(locs) > 2
            if newArray(k,1) == locs(3,1)
                indices(end+1) = k;
            end
        end
        if length(locs) > 3
            if newArray(k,1) == locs(4,1)
                indices(end+1) = k;
            end
        end
    end
    
    y_pos_neg = y_pos * -1;
    hold on
    [pks2, locs2] = findpeaks(y_pos_neg,time,'MinPeakProminence',3,'MinPeakDistance',2, 'MinPeakHeight', -80);%,'MinPeakDistance',0.4);
    findpeaks(y_pos_neg,time,'MinPeakProminence',3,'MinPeakDistance',2, 'MinPeakHeight', -80 );%,'MinPeakDistance',0.4);
    
    %extensions and flexions
    if locs2(1,1) > locs(1,1)
        for i = length(locs2):-1:1
            locs2(i+1,1) = locs2(i);
        end
        dy = gradient(y_pos(:))./gradient(time(:));
        hold on
        for i = 1:length(dy)
            if dy(i) > 23
                locs2(1,1) = time(i);
                break;
            end
        end
        plot(locs2(1,1),0,'^');
    end
    
    indices2 = zeros(1,1);
    for j = 1:length(newArray)
        if newArray(j,1) == locs2(1,1)
            indices2(1,1) = j;
        end
        if newArray(j,1) == locs2(2,1)
            indices2(end+1) = j;
        end
        if length(locs2) > 2
            if newArray(j,1) == locs2(3,1)
                indices2(end+1) = j;
            end
        end
        if length(locs2) > 3
            if newArray(j,1) == locs2(4,1)
                indices2(end+1)= j;
            end
        end
    end
    
    %if there are no problems in detecting indices, let flexions and extensions
    %be automatically detected; if not then DO IT YOURSELF!!!!! >:(
    if length(indices2) ~= 4 || indices2(2)-indices2(1) < 15 || indices2(3)-indices2(2) < 15 || indices2(4)-indices2(3) < 15 || indices2(1) > indices(1) || indices2(2) > indices(2) || indices2(3) > indices(3) || y_pos(indices2(1)) > 100
        fprintf("\n")
        disp("Please select 4 mins")
        temp1 = ginput(1);
        temp2 = ginput(1);
        temp3 = ginput(1);
        temp4 = ginput(1);
        temp = [temp1(1);temp2(1);temp3(1);temp4(1)];
        
        for i = 1:4
            indices2(i) = max(find(time<temp(i)));
        end
        hold on
        plot(time(indices2),y_pos(indices2),'ro')
    end
    
    if length(indices) ~=3 || indices(2)-indices(1) < 15 || indices(3)-indices(2) < 15 || indices2(1) > indices(1) || indices2(2) > indices(2) || indices2(3) > indices(3)
        fprintf("\n")
        disp("Please select 3 maxes")
        temp1 = ginput(1);
        temp2 = ginput(1);
        temp3 = ginput(1);
        temp = [temp1(1);temp2(1);temp3(1)];
        
        for i = 1:3
            indices(i) = max(find(time<temp(i)));
        end
        plot(time(indices),y_pos(indices),'go')
    end
    close all
end

%extension 1
ext1(:,1) = time(indices2(1,1):indices(1,1));
ext1(:,2) = y_pos(indices2(1,1):indices(1,1));
ext1(:,3) = net_accel(indices2(1,1):indices(1,1));
ext1(:,4) = torque(indices2(1,1):indices(1,1));

%extension 2
ext2(:,1) = time(indices2(1,2):indices(1,2));
ext2(:,2) = y_pos(indices2(1,2):indices(1,2));
ext2(:,3) = net_accel(indices2(1,2):indices(1,2));
ext2(:,4) = torque(indices2(1,2):indices(1,2));

%extension 3
ext3(:,1) = time(indices2(1,3):indices(1,3));
ext3(:,2) = y_pos(indices2(1,3):indices(1,3));
ext3(:,3) = net_accel(indices2(1,3):indices(1,3));
ext3(:,4) = torque(indices2(1,3):indices(1,3));

%EXTENSORS
%flexion 1
flex1(:,1) = time(indices(1,1):indices2(1,2));
flex1(:,2) = y_pos(indices(1,1):indices2(1,2));
flex1(:,3) = net_accel(indices(1,1):indices2(1,2));
flex1(:,4) = torque(indices(1,1):indices2(1,2));

%flexion 2
flex2(:,1) = time(indices(1,2):indices2(1,3));
flex2(:,2) = y_pos(indices(1,2):indices2(1,3));
flex2(:,3) = net_accel(indices(1,2):indices2(1,3));
flex2(:,4) = torque(indices(1,2):indices2(1,3));

%flexion 3
flex3(:,1) = time(indices(1,3):indices2(1,4));
flex3(:,2) = y_pos(indices(1,3):indices2(1,4));
flex3(:,3) = net_accel(indices(1,3):indices2(1,4));
flex3(:,4) = torque(indices(1,3):indices2(1,4));
clc
close all
end

%%
function [dataArray] = loadData(type,filename)
if type == 'T' || type == 't'
    T = readtable(filename,'Delimiter',',');
    T(:, 13) = [];
    %convert to array and make every entry a double
    A = table2array(T);
    B = str2double(A);
    %label the initial time and zero out the time and convert to seconds
    initialTime = B(1,1);
    height = length(B);
    for i = 1:height - 1
        B(i,1) = B(i,1) - initialTime;
        B(i,1) = B(i,1) / 1000000;
    end
    %zero-out total sensor measurement
    tot_sensInitial = B(1,8) - B(1,9);
    for j = 1:height - 1
        B(j,13) = abs((B(j,8) - B(j,9)) - tot_sensInitial);
    end
    %delete last row of data which imports as NAN
    newArray = B;
%     y_pos = newArray(:,3);
%     if y_pos(1,1) > 0
%         y_pos = y_pos.*-1;
%     end
%     y_pos = y_pos+90;
%     newArray(:,3) = y_pos;

test = newArray(:,3);
%when the y_pos data is increasing, do not flip data
%when the y_pos data is decreasing, flip data

figure;plot(test);
prompt = "Is data upside down (Y) or (N)?: ";
upsideDown  = input(prompt,"s");
if upsideDown == 'Y' || upsideDown == 'y'
test = test.*-1;
else
    test = test;
end
plot(test);
close all
prompt = "Min ROM: ";
minROM  = input(prompt);
prompt = "Max ROM: ";
maxROM = input(prompt);

minTest = min(test);
for i = 1:length(test)
    if minTest < 0
        test(i,1) = test(i,:)+abs(minTest);
    elseif minTest > 0
        test(i,1) = test(i,:)-abs(minTest);
    end
    
end

%find min and max of the positive torques
maxTest = max(test); %100%
minTest = min(test); %0%

for i =1:length(test)
    test(i,1) = (test(i,1)/maxTest);
end

test = test * (maxROM - minROM);
diff = minROM - min(test);
test = test + diff;
newArray(:,3) = test;

elseif type == "x" || type == "X"
    newArray = readtable(filename);
    newArray = table2array(newArray);
    initialTime = newArray(1,1);
    for i = 1:length(newArray) - 1
        %newArray(i,1) = newArray(i,1) - initialTime;
        newArray(i,1) = newArray(i,1);
    end 
end
newArray(length(newArray),:) = [];
dataArray = newArray;
dataArray(:,14) = sqrt((dataArray(:,5)).^2 + (dataArray(:,6)).^2 + (dataArray(:,7)).^2);
end
%%
%load data in using .mat file
function [data] = loadRawData(filename)
Data = importdata(filename);

initialTime = Data.Raw.T(1,1);
    height = length(Data.Raw.T);
    for i = 1:height - 1
        Data.Raw.T(i,1) = Data.Raw.T(i,1) - initialTime;
        Data.Raw.T(i,1) = Data.Raw.T(i,1) / 1000000;
    end
    
tot_sen = abs((Data.Raw.S - Data.Raw.H) - (Data.Raw.S(1,1) - Data.Raw.H(1,1)));
Data.Raw.Y = (Data.Raw.Y*-1)+90;

time = Data.Raw.T;
x_pos = Data.Raw.X;
y_pos = Data.Raw.Y;
z_pos = Data.Raw.Z;
x_acc = Data.Raw.U;
y_acc = Data.Raw.V;
z_acc = Data.Raw.W;
h_val = Data.Raw.H;
s_val = Data.Raw.S;
gyro_x = Data.Raw.A;
gyro_y = Data.Raw.B;
gyro_z = Data.Raw.C;
net_accel= sqrt((x_acc).^2 + (y_acc).^2 + (z_acc).^2);

data = [time,x_pos,y_pos,z_pos,x_acc,y_acc,z_acc,s_val,h_val,gyro_x,gyro_y,gyro_z,tot_sen,net_accel];
data(length(data),:) = [];
end