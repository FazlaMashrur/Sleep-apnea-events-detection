function updated = preprocess_ECG(data)
data = detrend(data);
data = normalize(data,2);
updated=data;