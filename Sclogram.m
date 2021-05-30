%% image genrate for test and val
sig =struct.ecg(1,:); 
Number_of_current_image=0;
signalLength = length(sig);
Fs = 250;
fb = cwtfilterbank('SignalLength',signalLength,'SamplingFrequency',Fs)

fb = cwtfilterbank('SignalLength',signalLength,'Wavelet','amor','SamplingFrequency',Fs,'VoicesPerOctave',48)
[wt,f] = fb.wt(sig);
[r,c] = size(struct.ecg);
lab = struct.info(:,1);
%% lebels correction
clearvars labels
for ii=1:length(lab) 
    if lab(ii,1)== 3
       labels(Number_of_current_image+ii,1) = {'Hypopnea'}; 
    end
    if lab(ii,1)== 2
       labels(Number_of_current_image+ii,1) = {'Apnea'};
    end
end
%% file directory

ret = exist('E:\shhs2\normal vs apnea vs hypopnea','dir');
if ret ==0
    mkdir('E:\shhs2\normal vs apnea vs hypopnea');
end
tic
k=0;
for ii=Number_of_current_image+1:Number_of_current_image+r
    k=k+1;
    [wt,~] = fb.wt(struct.ecg(k,:));
    imageRoot = fullfile(pwd,'image');
    im = ind2rgb(im2uint8(rescale(abs(wt))),jet(256));
    imgLoc = fullfile(imageRoot,char(labels(ii)));
    imFileName = strcat(num2str(ii),'.jpg');
    imwrite(imresize(im,[512 512]),fullfile(imgLoc,imFileName));   
end
toc