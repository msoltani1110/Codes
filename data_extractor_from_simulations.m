clc
clear all
close all
 
% Uploading data from StochKit:
% Note that first you need to change the directory of MATLAB to the
% directory that the file 'trajectory0.txt' is there
% This file is usually in the folder built by running StochKit and into the folder named "trajectories"

fileName = strcat('trajectory0.txt'); 
A = load(fileName);   

% Reading the time point from simulated data
t = A(:,1);
% Reading the values of z^a from simulated data
za = A(:,2);
% Reading the values of z^b from simulated data
zb = A(:,23);

% Calculating the mean to make sure simulated data has a mean around 55
Mean_zb=mean(zb)

% Filtering the data to remove noise from time trend
% Note that we selected 40 for the current set of data. This value should
% change for different delay times. 
zb_f=smooth(zb,40,'moving');

% We plot the raw data and filtered data to make sure: 1- Simulations are in
% synchrony. 2- We did not over or under filtered the data  
plot(t,za)
hold on
plot(t,zb)
hold on
plot(t,zb_f)

% Finding the peak times of the oscillations
[zb_p0,t_p0] = findpeaks(zb_f);
t_p= 0.1.*t_p0;
% Finding the values of timetrend of z^b at peak times of the oscillations
zb_p=zb(t_p0);

% Finding the period of the oscillations
T_p0 = circshift(t_p,[1 1]);
T_p = [t_p(1) (t_p([2:end])-T_p0([2:end]))']';

% We only accept the peak points that are far from each other.
% If two peaks are very cloe to eachother then they belong to the same oscillation cycle. 
% Note that the number 15 here should change for different time delays.
T_P=T_p(T_p>15);
zb_P=zb_p(T_p>15);


% Calculating the  %95 confidence interval for period of oscillations
for j=1:length(T_P)
   rt=randsample(T_P,length(T_P),true); 
Rt(j)= mean(rt);
end
RT = sort(Rt);
Confidence_period= [RT(floor(0.025 * length(RT )))    RT(floor(0.5 * length(RT )))   RT(floor(0.975 * length(RT )))]

% Calculating the %95 confidence interval for noise in protein level
for j=1:length(zb_P)
   rp=randsample(zb_P,length(zb_P),true); 
Rz(j)= var(rp)/(mean(rp)^2);
end
RZ = sort(Rz);
Confidence_noise_zb= [RZ(floor(0.025 * length(RZ)))    RZ(floor(0.5 * length(RZ )))   RZ(floor(0.975 * length(RZ)))]







