%clear
%clc

arr = [0.05	0.13	0.21	0.29	0.38	0.47	0.56	0.64	0.73	0.82	0.91	0.99	1.08	1.17	1.26	1.29	1.3	1.31	1.31	1.31	1.31	1.31	1.31	1.31	1.31	1.31	1.31	1.31	1.31	1.31	1.31	1.31	1.31	1.3	1.29	1.26	1.23	1.21	1.2	1.19	1.18	1.2	1.24	1.31	1.39	1.51	1.65	1.86	2.09	2.44	2.84	3.38	3.99	4.61	5.4	6.43	7.6	8.95	10.4	12.17	13.89	15.92	17.88	20.12	22.25	24.63	26.86	29.3	31.69	34.16	36.38	38.44	40.5	42.43	44.21	45.99	47.59	49.18	50.58	51.97	53.15	54.33	55.28	56.23	56.94	57.64	58.3	58.75	59.1	59.28	59.31	59.21	58.99	58.63	58.24	57.66	56.89	55.97	54.82	53.67	52.28	50.93	49.59	48.09	46.58	44.96	43.34	41.56	39.82	37.83	35.97	34.01	32.16	30.28	28.4	26.51	24.62	22.49	20.62	18.54	16.72	14.72	13	11.13	9.55	7.96	6.52	5.09	3.82	2.56	1.44	0.21	-0.79	-1.78	-2.68	-3.58	-4.43	-5.27	-6.07	-6.88	-7.78	-8.56	-9.43	-10.2	-11.04	-11.77	-12.46	-13.15	-13.89	-14.52	-15.21	-15.77	-16.39	-16.9	-17.45	-17.89	-18.34	-18.73	-19.12	-19.47	-19.84	-20.15	-20.48	-20.75	-21.02	-21.26	-21.49	-21.7	-21.9	-22.08	-22.25	-22.43	-22.58	-22.73	-22.84	-22.9	-22.97	-22.97	-22.97	-22.93	-22.85	-22.72	-22.54	-22.28	-21.97	-21.57	-21.08	-20.6	-19.94	-19.28	-18.42	-17.42	-16.37	-15.04	-13.75	-12.48	-10.97	-9.49	-7.78	-6.1	-4.21	-2.05	0.11	2.42	4.73	6.83	9.11	11.3	13.53	15.75	18.28	20.52	23.05	25.26	27.76	29.93	32.03	34.14	35.92	37.96	39.99	41.94	44.1	45.96	48.01	49.77	51.52	53.16	54.95	56.47	58.11	59.48	60.94	62.4	63.68	64.95	65.99	66.83	67.67	68.3	68.93	69.5	69.9	70.07	70.23	70.17	70.11	69.9	69.64	69.31	68.87	68.43	67.82	67.07	66.32	65.42	64.56	63.54	62.6	61.5	60.49	59.33	58.23	57.02	55.81	54.55	53.29	52.17	51.03	49.88	48.74	47.59	46.46	45.33	44.21	43.1	42.02	40.94	39.9	38.86	37.99	37.01	35.93	35.02	34.03	33.2	32.28	31.52	30.67	29.96	29.18	28.52	27.78	27.16	26.48	25.8	25.16	24.63	24.09	23.59	23.09	22.63	22.17	21.75	21.32	20.92	20.51	20.13	19.76	19.39	19.03	18.72	18.37	17.98	17.63	17.26	16.93	16.57	16.26	15.92	15.65	15.37	15.11	14.83	14.58	14.31	14.04	13.79	13.58	13.37	13.16	12.95	12.75	12.54	12.34	12.13	11.88	11.67	11.45	11.23	11	10.77	10.53	10.28	10.01	9.76	9.47	9.21	8.91	8.64	8.38	8.11	7.84	7.56	7.28	6.97	6.67	6.32	5.93	5.58	5.22	4.88	4.54	4.22	3.91	3.58	3.29	3	2.75	2.51	2.33	2.15	2.05	2	1.94	1.88	1.85	1.8	1.77	1.72	1.68	1.63	1.58	1.52	1.47	1.41	1.35	1.29	1.23	1.18	1.14	1.09	1.06	1.02	1	0.98	0.97	0.97	0.97	0.97	0.98	0.98	0.99	0.99	0.99	0.98	0.98	0.98	0.98	0.98	0.99	0.99	0.99	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1];

Peak = max(arr);
PeakIndex = find(arr == Peak);

up = PeakIndex;
down = PeakIndex;

ad = arr(down);
au = arr(up);
dataCount = 0;


while (ad > -10)
    %if ((abs((arr(down) - arr(down - 1))) < 0.5)&&(arr(down) < 1))
    if ((abs((arr(down) - arr(down + 1))) <= 0.1))
        if (dataCount == 5)
            trough1 = arr(down);
            indices1 = down+3;
            L_indice = down+3;
            disp("Left: ");
            disp(trough1);
            disp(indices1);
            dataCount=0;
            break;
        else
            dataCount = dataCount + 1;
        end
    end
    down = down - 1;
    ad = arr(down);
end


while (au > -10)
    
    %if ((abs((arr(up+1) - arr(up))) < 0.5)&&(arr(up)<1))
    if ((abs((arr(up) - arr(up-1))) <= 0.1))
        if(dataCount == 5)
            trough2 = arr(up);
            indices2 = up-3;
            R_indice = up-3;
            disp("Right: ");
            disp(trough2);
            disp(indices2);
            break;
        else
            dataCount = dataCount +1;
        end
    end
    
    up = up + 1;
    au = arr(up);
end
%%
extRows = abs(indices2 - indices1 + 1);
j = 1;

for i = 1:extRows
    
    acc_ext(j) = arr(indices1);
    y_pos_ext(j) = y_pos(indices1);
    indices1 = indices1+1;
    j = j + 1;
end
%%
findCatch(y_pos, acc_ext, extRows, Peak, PeakIndex);

%%
function [Catch] = findCatch(y_pos, acc_ext, extRows, peakValue, peakIndex)

% %findProm(acc_ext, extRows, 1);
%  peakCount = 1;  
%  peakProminences= zeros(extRows, 1);
% 
% for f = 2:(extRows - 2)
% 
%      
%     minProminence =  1;  
%     
%     
%     if ((acc_ext(f) > acc_ext(f - 1)) && (acc_ext(f) > acc_ext(f + 1)) )
%     
%         %Check if the peak is greater than or equal to the minimum prominence
%         prominence = acc_ext(f) - ((acc_ext(f - 1) + acc_ext(f + 1)) / 2);
%         if (prominence >= minProminence)
%             
%             peakProminences(peakCount) = prominence;
%             prom_max = max(peakProminences);
%             peakCount = peakCount + 1;
%         end
%     end
% end
  % Find the lowest point on the contour line
  contourValue = peakValue;
  
  for i = peakIndex:0  
    if (acc_ext(i) < contourValue) 
      contourValue = acc_ext(i);
    end
  end
  
  %Calculate prominence
  prominence = peakValue - contourValue;


if (prominence > 12.3)
    
   % for j = 0:extRows
   %     
   %     accel_max = max(accel_max, acc_ext(j));
   % end
    accel_max = max(acc_ext);
    accel_ind = find(acc_ext == accel_max);
    
    %minR = y_pos(L_indice); %first instance of y_pos
    %maxR = y_pos(R_indice) - minR; %last instance of y_pos
    minR = y_pos(1,1);
    maxR = y_pos(accel_ind);
    maxR = maxR - minR;
    
    Catch = ((acc_ext(accel_ind) - minR) / maxR) * 100;
    
    disp("minR: ");
    disp(minR);
    disp("maxR: ");
    disp(maxR);
    disp("accel at max: ");
    disp(accel_max);
    disp("The catch percentage for this trial is: ");
    disp(Catch);
    disp("%");
else
    disp("No Catch Detected");
    Catch = 100;
    
end
end

%%
                            
                          


