
%% File paths
%csv_path = '../redcap data - deid/PNESPrediction-Deidentified_DATA_2020-08-12_1514.csv';
csv_path = '../redcap data - deid/PNESPrediction-Deidentified_DATA_2020-09-08_1530.csv';

%% Load csv file
data = readtable(csv_path);

% What percent complete
complete = data.clinical_data_complete==2;
fprintf('\n%d of %d (%1.1f%%) records for DDx/class reviewed.\n',...
    sum(complete),length(complete),sum(complete)/length(complete)*100);

n_complete = sum(complete);


% Define discharge diagnoses
epilepsy_alone = data.diagnosis_discharge == 1;
nee_alone = data.diagnosis_discharge == 2;
epilepsy_and_nee = data.diagnosis_discharge == 3;
other = data.diagnosis_discharge == 4;
no_diagnosis = data.diagnosis_discharge == 5;
epilepsy = (epilepsy_alone | epilepsy_and_nee);

% Of all reviewed records, how many got a diagnosis of epilepsy or nee
n_diagnosis = sum((complete & (epilepsy_alone | nee_alone | epilepsy_and_nee)));
fprintf('\nOf all reviewed records, %d of %d (%1.1f%%) got an EMU diagnosis\n of epilepsy or NEE.\n',...
   n_diagnosis,n_complete,n_diagnosis/n_complete*100);

% How many with a diagnosis were epilepsy
fprintf(['\nOf %d reviewed records with EMU diagnosis, %d (%1.1f%%) were diagnosed with epilepsy,\n'...
    'and %d (%1.1f%%) were diagnosed with NEE.\n'], n_diagnosis, sum(epilepsy&complete),...
    sum(epilepsy&complete)/n_diagnosis*100,sum(nee_alone&complete),sum(nee_alone&complete)/n_diagnosis*100);

fprintf('\nExtrapolating to full dataset, I expect %d (%d epilepsy and %d NEE)\n will receive a diagnosis.\n',...
    round(n_diagnosis/n_complete*length(complete)),...
    round(n_diagnosis/n_complete*length(complete)*sum(epilepsy&complete)/n_diagnosis),...
    round(n_diagnosis/n_complete*length(complete)*sum(nee_alone&complete)/n_diagnosis));

% How many with epilepsy had focal epilepsy
focal = data.classification == 2;
generalized = data.classification == 1;
mixed = data.classification == 3;
unknown_class = data.classification == 4;
fprintf(['\nOf %d patients with epilepsy, %d (%1.1f%%) had focal epilepsy,\n'...
    '%d (%1.1f%%) had generalized epilepsy, %d (%1.1f%%) mixed, and %d (%1.1f%%) unknown classification.\n'],...
    sum(epilepsy),sum(focal),sum(focal)/sum(epilepsy)*100,...
    sum(generalized),sum(generalized)/sum(epilepsy)*100,...
    sum(mixed),sum(mixed)/sum(epilepsy)*100,...
    sum(unknown_class),sum(unknown_class)/sum(epilepsy)*100);

% How many focal epilepsy patients had EEGs
no_eeg = data.exclusion_checkboxes___1 == 1;
fprintf('\nOf %d patients with focal epilepsy, %d (%1.1f%%) had outpatient EEGs available for review.\n',...
    sum(focal),sum(focal & ~no_eeg),sum(focal & ~no_eeg)/sum(focal)*100);

fprintf('\nExtrapolating to full dataset, I expect %d patients will have focal epilepsy with outpatient EEGs.\n',...
    round(sum(focal & ~no_eeg)/n_complete*length(complete)));

