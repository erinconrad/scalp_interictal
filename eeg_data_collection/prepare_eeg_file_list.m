function prepare_eeg_file_list

%% Parameters and file locations
data_folder = '../../data/EEG lists/';
data_file = [data_folder,'interictal_clip_list.xlsx'];
starter_path = 'isilon-neurology/Neurology/';

%% read in table
T = readtable(data_file);
nrows = size(T,1);

%% Initialize thing of all names
all_names = cell(nrows,1);

%% Create a new column with full file path
full_path = cell(nrows,1);

%% Loop over rows
for r = 1:nrows
    curr_emu_folder = T.CDLabel{r};
    curr_sub_folder = T.FilePath{r};
    full_name = [T.FirstName{r},' ',T.LastName{r}];
    all_names{r} = full_name;
    
    %% if the curr_emu_folder is empty, try filling it with that of a nearby patient
    if isempty(curr_emu_folder)
        % Look one up and one down
        for jr = [r-20:r+20]
            
            if jr < 1 || jr > nrows, continue; end
            
            % if same patient
            if strcmp(full_name,[T.FirstName{jr},' ',T.LastName{jr}])
                
                % skip if this curr_emu_folder also empty
                if isempty(T.CDLabel{jr}), continue; end
                
                % fill up the curr_emu_folder with that row's info
                curr_emu_folder = T.CDLabel{jr};
                T.CDLabel{r} = curr_emu_folder;
                
                % break out of loop
                break
            end
            
        end
    end
    
    %% Make full file path
    if ~isempty(curr_emu_folder)
        full_path{r} = [starter_path,curr_emu_folder,'/',curr_sub_folder,'/'];
    end
    
end

%% Add the new column with the full path to the table
T = [T,full_path];

%% Save updated table
writetable(T,[data_folder,'edited_interictal_clips.xlsx']);

%% Get number of unique patients
fprintf('\nThere are %d unique patients.\n',length(unique(all_names)))

end