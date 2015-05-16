% SRP-PHAT Two-level Search Space Clustering
% 2015.4.28. Taewoo Lee, twlee@speech.korea.ac.kr
%
% This work is licensed under a Creative Commons Attribution 4.0
% International License. (See: http://creativecommons.org/licenses/by/4.0/)
% 
clc; clear all; close all;

% coordinates of a microphone array (cartesian coordinates), milli meter
mic=[0, 122.5, 438; ...		%0
	86.6, 86.6, 438; ...	%1
	122.5, 0, 438; ... 		%2
	86.6, -86.6, 438; ...	%3
	0, -122.5, 438; ...		%4
	-86.6, -86.6, 438; ...	%5
	-122.5, 0, 438; ...		%6
	-86.6, 86.6, 438; ...	%7
	0, 122.5, 200; ...		%8
	86.6, 86.6, 200; ...	%9
	122.5, 0, 200; ...  	%10
	86.6, -86.6, 200; ...	%11
	0, -122.5, 200; ... 	%12
	-86.6, -86.6, 200; ...	%13
	-122.5, 0, 200; ...		%14
	-86.6, 86.6, 200];  	%15

% Search range setting (hemispherical or spherical coordinates)
search_range.theta_range= 2*pi; % radian
search_range.n_theta= 360;      % degree (e.g. theta range=0:2*pi/360:2*pi)
search_range.phi_range= pi;     % radian (pi=hemisphere, 2*pi=sphere)
search_range.n_phi= 90;         % degree (e.g. phi range=0:pi/360:2*pi)
search_range.r= 2000;           % milli meter

Fs= 16000; % sampling frequency (Hz)
c= 340000; % speed of sound (mm/s)

mk_tdoa_table_full(mic,search_range,Fs,c);
mk_tdoa_table_inverse('TDOA_table.mat');
mk_tdoa_table_ssc('TDOA_table.mat');
mk_tdoa_table_tlssc('TDOA_table.mat',Fs,c);