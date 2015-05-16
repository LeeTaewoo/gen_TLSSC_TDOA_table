function []=mk_tdoa_table_full(mic,search_range,Fs,c)
% In : mic: cartesian coordinates of microphones 
%      search_range: e.g.) theta=0:2*pi/360:2*pi, phi=0:pi/90:pi, r=2m.
%      Fs: sampling frequency (Hz).
% Out: TDOA_table.mat: Q x N matrix which stores TDOAs of each microphone 
%                      pair for each coordinates index.
%      cartCoords.mat: cartesian coordinates of each coordinates index
%                      (Q x 3(x,y,z)).
%
% Reference:
% J. Dmochowski, J. Benesty, and S. Affes, "A generalized steered response 
% power method for computationally viable source localization," 
% IEEE Transactions on Audio, Speech, and Language Processing, vol. 15, 
% pp. 2510-2526, 2007.
%
% Author: Taewoo Lee (twlee@speech.korea.ac.kr). 2015.4.28.
%
% This work is licensed under a Creative Commons Attribution 4.0
% International License. See: http://creativecommons.org/licenses/by/4.0/.
% 

M= size(mic,1); % number of microphones
N= M*(M-1)/2; % number of microphone pairs

fprintf('TDOA Table Generation for Full-search\n');
n_theta= search_range.n_theta;
n_phi= search_range.n_phi;
theta= linspace(0, search_range.theta_range, n_theta);
phi= linspace(0, search_range.phi_range, n_phi); 
cartCoords= zeros(1*n_theta*n_phi, 3);
coordCnt= 0;
for r=search_range.r
    for ti=1:n_theta
        for pi=1:n_phi;
            [x(1),x(2),x(3)]= sph2cart(theta(ti),phi(pi),r);
            coordCnt= coordCnt+1;
            cartCoords(coordCnt,:)= x';
        end
    end
end
save('cartCoords.mat','cartCoords','coordCnt');

TDOA_table= zeros(coordCnt,N);
for i=1:coordCnt
    micPairCnt= 0;
    for m1=1:M-1
        for m2=m1+1:M
            d1= norm(mic(m1,:)-cartCoords(i,:),2);
            d2= norm(mic(m2,:)-cartCoords(i,:),2);
            dd= d1-d2;
            sd= round((dd/c)*Fs);
            micPairCnt= micPairCnt+1;
            TDOA_table(i,micPairCnt)= sd;
        end
    end
end
save('TDOA_table.mat','TDOA_table');