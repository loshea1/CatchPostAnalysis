%//#include <iostream>
%using namespace std;
%#include <PeakDetection.h>          //Peak Detection library. Used for moving average filter
%PeakDetection peakDetection;

clear
clc


arr = [0.06	0.13	0.22	0.31	0.4	0.49	0.59	0.68	0.77	0.86	0.95	1.05	1.14	1.23	1.32	1.36	1.37	1.38	1.38	1.38	1.38	1.38	1.38	1.38	1.38	1.38	1.38	1.38	1.38	1.38	1.38	1.38	1.38	1.38	1.39	1.41	1.43	1.47	1.51	1.58	1.67	1.81	2	2.21	2.46	2.76	3.12	3.52	3.91	4.33	4.78	5.25	5.75	6.31	6.85	7.54	8.18	8.88	9.66	10.51	11.42	12.25	13.15	14.12	15.13	16.18	17.28	18.33	19.39	20.53	21.58	22.71	23.73	24.8	25.76	26.69	27.68	28.63	29.54	30.38	31.19	31.95	32.75	33.51	34.21	34.83	35.38	35.94	36.35	36.75	37.08	37.33	37.52	37.65	37.75	37.79	37.75	37.67	37.53	37.32	37.07	36.74	36.32	35.87	35.34	34.72	34.05	33.28	32.54	31.73	30.85	29.91	28.85	27.73	26.52	25.24	24.03	22.77	21.44	20.07	18.68	17.26	15.93	14.49	13.03	11.56	10.09	8.61	7.14	5.77	4.42	2.96	1.52	0.1	-1.31	-2.7	-3.98	-5.36	-6.73	-8.08	-9.42	-10.73	-11.93	-13.09	-14.3	-15.45	-16.54	-17.58	-18.56	-19.48	-20.3	-21.17	-21.95	-22.66	-23.28	-23.81	-24.24	-24.67	-25.01	-25.27	-25.46	-25.61	-25.68	-25.69	-25.62	-25.51	-25.32	-25.06	-24.71	-24.37	-23.96	-23.49	-22.97	-22.4	-21.85	-21.25	-20.57	-19.83	-19.03	-18.17	-17.35	-16.47	-15.53	-14.52	-13.39	-12.2	-10.93	-9.58	-8.31	-6.88	-5.4	-3.84	-2.22	-0.55	1.17	2.89	4.64	6.42	8.21	10.01	11.81	13.58	15.33	17.08	18.79	20.45	22.07	23.62	25.03	26.38	27.8	29.15	30.42	31.6	32.66	33.65	34.56	35.4	36.25	37.01	37.68	38.25	38.72	39.19	39.57	39.86	40.1	40.25	40.34	40.39	40.37	40.28	40.14	39.94	39.69	39.39	39.07	38.71	38.32	37.95	37.56	37.14	36.69	36.22	35.74	35.29	34.81	34.3	33.78	33.24	32.74	32.22	31.67	31.1	30.48	29.86	29.24	28.66	28.09	27.53	26.94	26.36	25.77	25.24	24.71	24.14	23.58	23.04	22.55	22.07	21.59	21.11	20.6	20.07	19.49	18.94	18.37	17.79	17.16	16.53	15.89	15.3	14.7	14.06	13.41	12.76	12.15	11.52	10.94	10.42	9.89	9.4	8.97	8.53	8.15	7.81	7.45	7.13	6.86	6.63	6.43	6.23	6.05	5.86	5.68	5.48	5.27	5.04	4.83	4.62	4.42	4.18	3.96	3.7	3.44	3.19	2.94	2.7	2.49	2.29	2.12	1.98	1.86	1.77	1.68	1.6	1.57	1.54	1.54	1.54	1.55	1.55	1.56	1.56	1.56	1.56	1.56	1.56	1.56	1.56	1.56	1.56	1.56	1.56	1.56	1.56	1.56	1.56	1.56	1.56	1.56	1.56	1.56	1.56	1.56	1.56	1.56	1.57	1.57	1.58	1.58	1.58	1.59	1.59	1.6	1.6	1.61	1.61	1.62	1.62	1.63	1.63	1.63	1.63	1.63	1.63	1.63	1.63	1.63	1.63	1.63	1.63	1.63	1.63	1.63	1.63	1.63	1.63	1.63	1.63	1.63	1.63	1.63	1.63	1.63	1.63	1.63	1.63	1.63	1.63];

n = length(arr);
Filt = movmean(arr, 3);

[MAX, MAXi, MIN, MINi] = printPeaksTroughs(Filt, n);

disp(MAX);
disp(MAXi);
disp(MIN);
disp(MINi);


%///////////////////////////////////////////////////////////////////////
% Function that returns true if num is
% greater than both arr[i] and arr[j]
function [statement] = isPeak(arr,  n, num, i,  j)
% If num is smaller than the element
% on the left (if exists)
if (i >= 1 && arr(i) > num && arr(i-1) ~= arr(i))
    statement = false;
    % If num is smaller than the element
    % on the right (if exists)
elseif (j < n && arr(j) > num && arr(j-1) ~= arr(j))
    statement = false;
else
    statement = true;
end
end
%///////////////////////////////////////////////////////////////////////
% Function that returns true if num is
% smaller than both arr[i] and arr[j]
function [statement] = isTrough(arr, n, num, i,  j)

% If num is greater than the element
% on the left (if exists)
if (i >= 1 && arr(i) < num && arr(i-1) ~= arr(i))
    statement = false;
    % If num is greater than the element
    % on the right (if exists)
elseif (j < n && arr(j) < num && arr(j+1) ~= arr(j))
    statement = false;
else
    statement = true;
end
end
%////////////////////////////////////////////////////////////////////////
function [MAX, MAXi, MIN, MINi] = printPeaksTroughs(arr, n)
k = 1;
m = 1;
disp("Peaks : ");
% For every element
for i = 1:n-1
    % If the current element is a peak
    if ( isPeak(arr, n, arr(i), i - 1, i + 1) == true)
        disp(arr(i));
        disp(" ");
        mins(k,m) = arr(i);
        m = m+1;
        mins(k,m) = i;
        
        m = m-1;
        k = k + 1;
    end
    
    %Find the 3 minimum points. Using isPeak becuase the data is upside
    %down peaks = mins
    if (i == n)
        A = sortrows(mins);
        MIN = A(end-2:end,1);
        MINi = A(end-2:end);
    end
end
disp(" ");

k = 1;
m = 1;
disp("Troughs : ");
% For every element
for i = 1:n-1
    
    % If the current element is a trough
    if (isTrough(arr, n, arr(i), i - 1, i + 1) == true)
        disp(arr(i));
        disp(" ");
        maxs(k,m) = arr(i);
        m = m+1;
        maxs(k,m) = i;
        
        m = m-1;
        k = k + 1;
    end
    
    if(i == n)
        A = sortrows(maxs);
        MAX = A(1:2);
        MAXi = A(1:2, end);
    end
end
disp(" ");
end


