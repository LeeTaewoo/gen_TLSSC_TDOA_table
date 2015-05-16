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

% Release date: May 2015
% Author: Taewoo Lee, (twlee@speech.korea.ac.kr)
%
% Copyright (C) 2015 Taewoo Lee
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program. If not, see <http://www.gnu.org/licenses/>.

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
