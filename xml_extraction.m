tic
row=0;
sampling_freq = 250;
load('sampling frequency_shhs2.mat');
load('filter.mat');
%for i=1:99
%for i=751:999
for i=1000:1289
    try
        %         load(sprintf('shhs2-2000%d_ecg.mat',i)); %for i=1:99
        %         load(sprintf('shhs2-200%d_ecg.mat',i));% for i=100:999
                 load(sprintf('shhs2-20%d_ecg.mat',i));% for i=1000:6000
        %         annot = sleep_xmlread(sprintf('shhs2-2000%d-nsrr.xml',i));%for i=1:99
        %         annot = sleep_xmlread(sprintf('shhs2-200%d-nsrr.xml',i));% for i=100:999
                 annot = sleep_xmlread(sprintf('shhs2-20%d-nsrr.xml',i));% for i=1000:6000
        if (sum(i == SR256))==1
            Fs = 256;
            t = 0:1/Fs:1-1/Fs;
            x = data;
            [P,Q] = rat(250/Fs);
            abs(P/Q*Fs-250);
            data = resample(x,P,Q);
            
        elseif (sum(i == SR_random(1,:)))==1
            Fs = 125;
            t = 0:1/Fs:1-1/Fs;
            x = data;
            [P,Q] = rat(250/Fs);
            abs(P/Q*Fs-250);
            data = resample(x,P,Q);
        else
        end
        NN = length(annot.ScoredEvents.ScoredEvent);
        is_to_be_deleted = false( 1,size(data,2));
        data=filtfilt(filt,data);
        data = preprocess_ECG(data);
        for j=1:NN
            if isequal(annot.ScoredEvents.ScoredEvent(j).EventConcept,'Obstructive apnea|Obstructive Apnea')
                row = row+1;
                start_time = (annot.ScoredEvents.ScoredEvent(j).Start-5) * sampling_freq;
                duration = (annot.ScoredEvents.ScoredEvent(j).Duration+10) * sampling_freq;
                is_to_be_deleted(start_time+1 : start_time + duration)=true;
                fulldata{row,1} = data(1,start_time+1 : start_time + duration);
                fulldata{row,2} = 2;
                fulldata{row,3} = i;

                
            elseif isequal(annot.ScoredEvents.ScoredEvent(j).EventConcept,'Central apnea|Central Apnea')
                
                row = row+1;
                start_time = (annot.ScoredEvents.ScoredEvent(j).Start-5) * sampling_freq;
                duration = (annot.ScoredEvents.ScoredEvent(j).Duration+10) * sampling_freq;
                fulldata{row,1} = data(1,start_time+1 : start_time + duration);
                is_to_be_deleted(start_time+1 : start_time + duration)=true;
                fulldata{row,2} = 2;
                fulldata{row,3} = i;
                
            elseif isequal(annot.ScoredEvents.ScoredEvent(j).EventConcept,'SpO2 artifact|SpO2 artifact')
                
                start_time = annot.ScoredEvents.ScoredEvent(j).Start * sampling_freq;
                duration = annot.ScoredEvents.ScoredEvent(j).Duration * sampling_freq;
                is_to_be_deleted(start_time+1 : start_time + duration)=true;
                
            elseif isequal(annot.ScoredEvents.ScoredEvent(j).EventConcept,'Arousal|Arousal ()')
                
                start_time = annot.ScoredEvents.ScoredEvent(j).Start * sampling_freq;
                duration = annot.ScoredEvents.ScoredEvent(j).Duration * sampling_freq;
                is_to_be_deleted(start_time+1 : start_time + duration)=true;
                
            elseif isequal(annot.ScoredEvents.ScoredEvent(j).EventConcept,'SpO2 desaturation|SpO2 desaturation')
                
                start_time = annot.ScoredEvents.ScoredEvent(j).Start * sampling_freq;
                duration = annot.ScoredEvents.ScoredEvent(j).Duration * sampling_freq;
                is_to_be_deleted(start_time+1 : start_time + duration)=true;
                
            elseif isequal(annot.ScoredEvents.ScoredEvent(j).EventConcept,'Hypopnea|Hypopnea')
                row = row+1;
                start_time = (annot.ScoredEvents.ScoredEvent(j).Start-5) * sampling_freq;
                duration = (annot.ScoredEvents.ScoredEvent(j).Duration+10) * sampling_freq;
                is_to_be_deleted(start_time+1 : start_time + duration)=true;
                fulldata{row,1} = data(1,start_time+1 : start_time + duration);
                fulldata{row,2} = 3;
                fulldata{row,3} = i;
            end
        end
%         data(:,is_to_be_deleted(1:size(data,2)) ) = [];
%         row = row+1;
%         fulldata{row,1} = data;
%         fulldata{row,2} = 1;
%         fulldata{row,3} = i;
    catch
    end
end
save('shhs2_751-1289_Apnea2_hypoapnea3.mat','-v7.3','fulldata');
clearvars fulldata row i j NN
toc