function []=mk_tdoa_table_ssc(tdoa_table_filename)
% In : TDOA_table.mat
% Out: TDOA_table_SSC.mat
%
% Reference:
% Youngkyu Cho, Dongsuk Yook, Seokmun Jang, and Hyunsoo Kim, 
% "Sound Source Localization for Robot Auditory Systems," 
% IEEE Transactions on Consumer Electronics, vol. 55, no. 3, pp. 1663-1668, 
% Aug. 2009.
%
% Author: Taewoo Lee (twlee@speech.korea.ac.kr). 2015.4.28.
%
% This work is licensed under a Creative Commons Attribution 4.0
% International License. See: http://creativecommons.org/licenses/by/4.0/.
% 

% For all microphone pairs, the coordinates with a same TDOA are annotated 
% as a same cluster ID. Then, it is saved into the CoordClusterTable.
load(tdoa_table_filename);
N= size(TDOA_table,2);
fprintf('Search Space Clustering ...\n');
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
        if (max(diffVec) == 0)
            CoordClusterTable(j,1)= clusterID;
        end
    end
end
if (CoordClusterTable(nCoord,1)==0)
    clusterID= clusterID+1;
    CoordClusterTable(nCoord,1)= clusterID;
end

% Gathering coordinates with a same cluster ID, then save it in SSC.
nCluster= max(CoordClusterTable);
SSC= cell(nCluster,1);
for clusterID=1:nCluster
    SSC{clusterID}= find(CoordClusterTable==clusterID);
end

% Extracting representative coordinates in each cluster. Then, it is saved
% in TDOA_table_SSC. The representative coordinates is determined as the 
% first coordinates in the cluster.
nCluster= size(SSC,1);
TDOA_table_SSC= zeros(nCluster,N);
for i=1:nCluster
    clusterIdx= SSC{i}(1);
    TDOA_table_SSC(i,:)= TDOA_table(clusterIdx,:);
end
save ('TDOA_table_SSC.mat','TDOA_table_SSC');