NN=length(fulldata);
for i=1:NN
    temp=fulldata{i};
    if length(temp) >3750
        struct.ecg(i,:)= temp(1:3750);
        struct.info(i,1)= fulldata{i,2};
        struct.info(i,2)= fulldata{i,3};
    end
end
%% Amount of zero in data:delete the bad signals
is_to_be_deleted = false( size(struct.ecg,1), 1 );
n=0;
for r=1:size(struct.ecg,1)
    j=0;
    for c=1:3750
        if  struct.ecg(r,c) >= -1e-3 && struct.ecg(r,c) <= 1e-3
            j=j+1;
        end
    end
    if j >=500
        is_to_be_deleted(r) = true;
    end
end
struct.ecg( is_to_be_deleted, : ) = [];
struct.info( is_to_be_deleted, : ) = [];



% save('shhs2_5251-5800_struct.mat','-v7.3','struct');
% clearvars struct fulldata
%
% is_to_be_deleted = false(1,(length(fulldata)));
% NN=length(fulldata);
% for i=1:NN
%     if fulldata{i,2} == 1
%     is_to_be_deleted(i) = true;
%     end
% end
% fulldata(is_to_be_deleted,:)=[];
%
% load('shhs2_5251-5800.mat')
for i=1:size(struct.ecg,1)
    click=struct.info(i,2)==struct.info(:,2);
    
end



