function []=mk_tdoa_table_tlssc(tdoa_table_filename,Fs,c)
% In : TDOA_table.mat
% Out: TDOA_table_SSC.mat
%
% Reference:
% Dongsuk Yook, Taewoo Lee, and Youngkyu Cho, 
% "Fast Sound Source Localization Using Two-Level Search Space Clustering,"
% IEEE Transactions on Cybernetics, In Press, Feb. 2015.
%
% Author: Taewoo Lee (twlee@speech.korea.ac.kr). 2015.4.28.
%
% This work is licensed under a Creative Commons Attribution 4.0
% International License. See: http://creativecommons.org/licenses/by/4.0/.
% 

threshold= round((1/5) * (55/c) * Fs);
load(tdoa_table_filename);
N= size(TDOA_table,2);

% Theta is determined by the equation (7) in the reference paper.
% For all microphone pairs, the coordinates within the range of a same TDOA 
% -theta to +theta are annotated as a same cluster ID. Then, it is saved
% into the CoordClusterTable.
fprintf('Two-Level Search Space Clustering ...\n');
clusterID= 0;
nCoord= size(TDOA_table,1);
CoordClusterTable= zeros(nCoord,1);
for i=1:nCoord-1
    if(rem(i,100)==0)
        fprintf('Processing ... clutser %d/%d\n',i,nCoord);
    end    
    if (CoordClusterTable(i,1)~=0)
        continue;
    end
    
    clusterID= clusterID+1;
    coordCnt=1;
    CoordClusterTable(i,1)= clusterID;
    for j=i+1:nCoord
        diffVec= abs(TDOA_table(i,:) - TDOA_table(j,:));
        if (max(diffVec) <= threshold)
            CoordClusterTable(j,1)= clusterID;
        end
    end
end
if (CoordClusterTable(nCoord,1)==0)
    clusterID= clusterID+1;
    CoordClusterTable(nCoord,1)= clusterID;
end

% Gathering coordinates with a same cluster ID, then save it in SSC.
load 'TDOA_table.mat';
nCluster= max(CoordClusterTable);
SSC2= cell(nCluster,1);
for clusterID=1:nCluster
    SSC2{clusterID}= find(CoordClusterTable==clusterID);
end

% Extracting representative coordinates in each cluster. Then, it is saved 
% in TDOA_table_SSC2. The representative coordinates is determined as
% the first coordinates in each cluster.
nCluster= size(SSC2,1);
TDOA_table_SSC2= zeros(nCluster,N);
for i=1:nCluster
    clusterIdx= SSC2{i}(1);
    TDOA_table_SSC2(i,:)= TDOA_table(clusterIdx,:);
end
save ('TDOA_table_SSC2.mat','TDOA_table_SSC2');