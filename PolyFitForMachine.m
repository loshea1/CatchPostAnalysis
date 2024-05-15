%Pseudo-Machine Learning Data Code

clc
clear
close all

%Decide what type of data
prompt = "Data Type? (T or M): ";

type = input(prompt,"s");

pat = ".txt";

if type == 'T' || type == 't'
    filename = uigetfile('*txt');
    T = readtable(filename,'Delimiter',',');
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
        B(j,13) = (B(j,8) - B(j,9)) - tot_sensInitial;
    end
    %delete last row of data which imports as NAN
    newArray = B;
    newArray(length(newArray),:) = [];
    time = newArray(:,1);
    y_pos = newArray(:,3);
    x_accel = newArray(:,5);
    y_accel = newArray(:,6);
    z_accel = newArray(:,7);
    net_accel = ((x_accel.^2)+(y_accel.^2)+(z_accel.^2)).^(1/2);
else
    time = (Raw.T - Raw.T(1,1))/1000000;
    y_pos = Raw.Y;
    net_accel = ((Raw.U.^2)+(Raw.V.^2)+(Raw.W.^2)).^(1/2);
end

if y_pos(1,1) > 0
    y_pos = y_pos * -1;
end
y_pos = y_pos + 90;

y_pos_neg = y_pos * -1;

[pks,locs]= findpeaks(y_pos,time,'MinPeakProminence',5,'MinPeakDistance',0.85);
findpeaks(y_pos,time,'MinPeakProminence',5,'MinPeakDistance',0.85);

indices = zeros(1,1);

for k = 1:length(time)
    if time(k,1) == locs(1,1)
        indices(1,1) = k;
    end
    if time(k,1) == locs(2,1)
        indices(end+1) = k;
    end
    if length(locs) > 2
        if time(k,1) == locs(3,1)
            indices(end+1) = k;
        end
    end
    if length(locs) > 3
        if time(k,1) == locs(4,1)
            indices(end+1) = k;
        end
    end
end

[pks2,locs2]= findpeaks(y_pos_neg,time,'MinPeakProminence',5,'MinPeakDistance',0.85);
hold on
findpeaks(y_pos_neg,time,'MinPeakProminence',5,'MinPeakDistance',0.85);

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
    hold on
    plot(locs2(1,1),0,'^'); 
end

indices2 = zeros(1,1);
for j = 1:length(time)
    if time(j,1) == locs2(1,1)
        indices2(1,1) = j;
    end
    if time(j,1) == locs2(2,1)
        indices2(end+1) = j;
    end
    if length(locs2) > 2
        if time(j,1) == locs2(3,1)
            indices2(end+1) = j;
        end
    end
    if length(locs2) > 3
        if time(j,1) == locs2(4,1)
            indices2(end+1)= j;
        end
    end
end

Cycle1(:,1) = time(indices2(1,1):indices2(1,2));
Cycle1(:,2) = y_pos(indices2(1,1):indices2(1,2));
Cycle1(:,3) = net_accel(indices2(1,1):indices2(1,2));

Cycle2(:,1) = time(indices2(1,2):indices2(1,3));
Cycle2(:,2) = y_pos(indices2(1,2):indices2(1,3));
Cycle2(:,3) = net_accel(indices2(1,2):indices2(1,3));


Cycle3(:,1) = time(indices2(1,3):indices2(1,4));
Cycle3(:,2) = y_pos(indices2(1,3):indices2(1,4));
Cycle3(:,3) = net_accel(indices2(1,3):indices2(1,4));


cy1 = polyfit(Cycle1(:,1),Cycle1(:,2),10);
cy2 = polyfit(Cycle2(:,1),Cycle2(:,2),10);
cy3 = polyfit(Cycle3(:,1),Cycle3(:,2),10);

for i = 1:11
    E(1,i+2) = cy1(i);
    E(2,i+2) = cy2(i);
    E(3,i+2) = cy3(i);
end

prompt = "Subject?: ";
answer = input (prompt,"s");
answer = str2double(answer);
for i = 1:3
    E(i,1) = answer;
end
prompt = "Trial?: ";
answer = input(prompt,"s");
answer = str2double(answer);
for i = 1:3
    E(i,2) = answer;
end

filename = 'PseudoMachineLearningwithPolyfit.xlsx';
prompt = "Save? (Y/N): ";
answer = input(prompt,"s");
if answer == 'Y' || answer == 'y'
    writematrix(E,filename,'WriteMode','append');
end




% hold on 
% y = polyval(cy1,Cycle1(:,1));
% plot(Cycle1(:,1),y);
% hold on
% y = polyval(cy2,Cycle2(:,1));
% plot(Cycle2(:,1),y);

%FLEXORS
%extension 1
% ext1(:,1) = time(indices2(1,1):indices(1,1));
% ext1(:,2) = y_pos(indices2(1,1):indices(1,1));
% ext1(:,3) = net_accel(indices2(1,1):indices(1,1));
% 
% %extension 2
% ext2(:,1) = time(indices2(1,2):indices(1,2));
% ext2(:,2) = y_pos(indices2(1,2):indices(1,2));
% ext2(:,3) = net_accel(indices2(1,2):indices(1,2));
% 
% %extension 3
% ext3(:,1) = time(indices2(1,3):indices(1,3));
% ext3(:,2) = y_pos(indices2(1,3):indices(1,3));
% ext3(:,3) = net_accel(indices2(1,3):indices(1,3));
% 
% prompt = "Subject?: ";
% answer = input (prompt,"s");
% answer = str2double(answer);
% for i = 1:3
%     E(i,8) = answer;
% end
% prompt = "Trial?: ";
% answer = input(prompt,"s");
% answer = str2double(answer);
% for i = 1:3
%     E(i,9) = answer;
% end
% 
% 
% fprintf("\n")
% disp("FLEXORS: ")
% [eCatch1,prominence1,width1,peak_accel1,minROM1,maxROM1] = findCatch(ext1,1);
% E(1,1) = eCatch1;
% E(1,2) = prominence1;
% E(1,3) = width1;
% E(1,4) = peak_accel1;
% E(1,5) = minROM1;
% E(1,6) = maxROM1;
% prompt = "Catch or NO?(C or N): ";
% answer = input(prompt,"s");
% if answer == 'C' || answer == 'c'
%     E(1,7) = 1;
% else
%     E(1,7) = 0;
% end
% [eCatch2,prominence2,width2,peak_accel2,minROM2,maxROM2] = findCatch(ext2,2);
% E(2,1) = eCatch2;
% E(2,2) = prominence2;
% E(2,3) = width2;
% E(2,4) = peak_accel2;
% E(2,5) = minROM2;
% E(2,6) = maxROM2;
% prompt = "Catch or NO?(C or N): ";
% answer = input(prompt,"s");
% if answer == 'C' || answer == 'c'
%     E(2,7) = 1;
% else
%     E(2,7) = 0;
% end
% [eCatch3,prominence3,width3,peak_accel3,minROM3,maxROM3] = findCatch(ext3,3);
% E(3,1) = eCatch3;
% E(3,2) = prominence3;
% E(3,3) = width3;
% E(3,4) = peak_accel3;
% E(3,5) = minROM3;
% E(3,6) = maxROM3;
% prompt = "Catch or NO?(C or N): ";
% answer = input(prompt,"s");
% if answer == 'C' || answer == 'c'
%     E(3,7) = 1;
% else
%     E(3,7) = 0;
% end
% 
% filename = 'PseudoMachineLearningTest.xlsx';
% prompt = "Save? (Y/N): ";
% answer = input(prompt,"s");
% if answer == 'Y' || answer == 'y'
%     writematrix(E,filename,'WriteMode','append');
% end
% 
% etotalCatches = [eCatch1,eCatch2,eCatch3];
% eAvgCatch = mean(etotalCatches);
% 
% 
% if eAvgCatch > 95
%     disp("Conclusion: No Catch Detected for flexors");
% else
%     disp("Conclusion: The average catch percentage for flexors is " + eAvgCatch + "%");
% end
% 
% function [Catch,prom_max,widthmax,peak, minROM, maxROM1]= findCatch(ext,trialnum)
% [peak_accel, times,width,prominence] = findpeaks(ext(:,3),ext(:,1));
% prom_max = max(prominence);
% for i =1:length(prominence)
%     if prominence(i) == prom_max
%         promind = i;
%     end
% end
% widthmax = width(promind);
% % for i=1:length(prominence)
% %     if prom_max == prominence(i,1)
% %         width_loc = i;
% %     end
% % end  
% % width_peak = width(width_loc,1);
% minROM = ext(1,2);
% maxROM1 = ext(length(ext),2);
% peak = max(peak_accel);
% if prom_max > 12.3 %&& width_peak < 0.09
%     accel_max = max(peak_accel);
%     accel_ind = find(ext(:,3)==accel_max);
%     minROM = ext(1,2);
%     maxROM = ext(length(ext),2);
%     maxROM = maxROM - minROM;
%     Catch = ext(accel_ind,2);
%     Catch = Catch - minROM;
%     Catch = (Catch/maxROM)*100;
%     disp("The catch percentage of trial " + trialnum + " is: " + Catch + "%")
% else 
%     disp("No catch detected for trial " +trialnum);
%     Catch = 100;
% end
% end
% 
